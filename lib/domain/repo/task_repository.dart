import 'package:time_tracking_app/data/model/Task/Task_res.dart';
import 'package:time_tracking_app/data/model/task/comment_res.dart';
import 'package:time_tracking_app/data/model/task/completed_task_res.dart';

import '../../data/api/task_api.dart';
import '../../data/local/database_service.dart';

class TaskRepository {
  TaskRepository(this._api,this._databaseManager);

  final TaskApi _api;
  final DatabaseManager _databaseManager;

  Future<TaskRes> createTask({required String projectId,required String name}) async {
    return _api.createTask(name: name, projectId: projectId).then((response) {
      _databaseManager.insertTask(response);
      return response;
    });
  }

  Future<List<TaskRes>> getAllTasks({required String projectId}) async {
    return _databaseManager.getTasks(projectId);
  }

  Future<void> deleteTask({required String taskId}) async {
    return _api.deleteTask(taskId: taskId).then((response) {
      _databaseManager.deleteTask(taskId);
      return response;
    });
  }

  Future<List<CommentRes>> getComments({required String taskId}) async {
    return _databaseManager.getComments(taskId);
  }

  Future<void> addComment({required CommentRes comment}) async {
    _databaseManager.insertComment(comment);
  }

  Future<void> updateTask({required TaskRes task}) async {
    _databaseManager.updateTask(task);
  }

  Future<void> addTaskToHistory({required CompletedTaskRes task}) async {
    _databaseManager.insertHistory(task);
  }

  Future<void> deleteFromHistory({required String projectId,required String taskId}) async {
    _databaseManager.deleteHistory(projectId,taskId);
  }

  Future<List<CompletedTaskRes>> getHistory({required String projectId}) async {
    return _databaseManager.getHistory(projectId);
  }

  Future<TaskRes> getTask({required String projectId,required String taskId}) async {
    return _databaseManager.getTaskInfo(projectId,taskId).then((task) async{
      _databaseManager.getComments(taskId).then((comments){
        task.comments=comments;
      });
      return task;
    });
  }

}