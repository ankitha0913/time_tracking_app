import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/data/model/task/comment_res.dart';
import 'package:time_tracking_app/data/model/task/completed_task_res.dart';

class DatabaseManager {
  late Database _database;
  final lock = Lock();
  Future<Database> initDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "task_manager.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE project(id TEXT PRIMARY KEY, name TEXT NOT NULL)",
      );
      await db.execute(
        "CREATE TABLE task(id TEXT PRIMARY KEY, content TEXT NOT NULL, description TEXT,timeSpent INTEGER,state TEXT, projectId TEXT NOT NULL,FOREIGN KEY(projectId) REFERENCES project(id) ON DELETE CASCADE)",
      );
      await db.execute(
        "CREATE TABLE comments(id TEXT PRIMARY KEY, content TEXT NOT NULL, taskId TEXT NOT NULL, FOREIGN KEY (taskId) REFERENCES task(id) ON DELETE CASCADE)",
      );
      await db.execute(
        "CREATE TABLE history(projectId TEXT NOT NULL,taskId TEXT NOT NULL,name TEXT NOT NULL, dateCompleted TEXT NOT NULL, FOREIGN KEY (taskId) REFERENCES task(id) ON DELETE CASCADE,FOREIGN KEY (projectId) REFERENCES project(id) ON DELETE CASCADE,PRIMARY KEY (projectId, taskId))",
      );
    });
    return _database;
  }

  Future<void> insertProject(ProjectRes project) async {
    await initDb();
    await _database.insert('project', project.toJson());
  }

  Future<void> insertTask(TaskRes task) async {
    await initDb();
    await _database.insert('task', task.toDbJson());
  }

  Future<void> insertComment(CommentRes comment) async {
    await initDb();
    await _database.insert('comments', comment.toJson());
  }

  Future<void> insertHistory(CompletedTaskRes task) async {
    await initDb();
    await lock.synchronized(() async {
      await _database.insert('history', task.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<ProjectRes>> getProjects() async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult = await db.query('project');
    return List.generate(queryResult.length, (i) {
      return ProjectRes(
        id: queryResult[i]['id'],
        name: queryResult[i]['name'],
      );
    });
  }

  Future<List<TaskRes>> getTasks(String projectId) async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery("SELECT * FROM task WHERE projectId=$projectId");
    return List.generate(queryResult.length, (i) {
      return TaskRes(
          id: queryResult[i]['id'],
          projectId: queryResult[i]['projectId'],
          name: queryResult[i]['content'],
          description: queryResult[i]['description'],
          state: queryResult[i]['state'],
          timeSpent: queryResult[i]['timeSpent']);
    });
  }

  Future<TaskRes> getTaskInfo(String projectId, String taskId) async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        "SELECT * FROM task WHERE projectId = ? AND id = ?",
        [projectId, taskId]);
    return TaskRes(
        id: queryResult[0]['id'],
        projectId: queryResult[0]['projectId'],
        name: queryResult[0]['content'],
        description: queryResult[0]['description'],
        state: queryResult[0]['state'],
        timeSpent: queryResult[0]['timeSpent']);
  }

  Future<List<CommentRes>> getComments(String taskId) async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery("SELECT * FROM comments WHERE taskId=$taskId");
    return List.generate(queryResult.length, (i) {
      return CommentRes(
          id: queryResult[i]['id'],
          content: queryResult[i]['content'],
          taskId: queryResult[i]['taskId']);
    });
  }

  Future<List<CompletedTaskRes>> getHistory(String projectId) async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery("SELECT * FROM history WHERE projectId=$projectId");
    return List.generate(queryResult.length, (i) {
      return CompletedTaskRes(
        projectId: queryResult[i]['projectId'],
        taskId: queryResult[i]['taskId'],
        name: queryResult[i]['name'],
        dateCompleted: queryResult[i]['dateCompleted'],
      );
    });
  }

  Future<int> updateProject(ProjectRes project) async {
    final db = await initDb();
    return await db.update('project', project.toJson(),
        where: "id = ?", whereArgs: [project.id]);
  }

  Future<int> updateTask(TaskRes task) async {
    final db = await initDb();
    int response = await db
        .update('task', task.toDbJson(), where: "id = ?", whereArgs: [task.id]);
    return response;
  }

  Future<int> deleteTask(String taskId) async {
    final db = await initDb();
    return await db.delete('task', where: "id = ?", whereArgs: [taskId]);
  }

  Future<int> deleteProject(String projectId) async {
    final db = await initDb();
    return await db.delete('project', where: "id = ?", whereArgs: [projectId]);
  }

  Future<int> deleteHistory(String projectId, String taskId) async {
    final db = await initDb();
    await lock.synchronized(() async {
      return await db.delete('history',
          where: "projectId = ? and taskId = ?",
          whereArgs: [projectId, taskId]);
    });
    return 0;
  }
}
