import 'package:time_tracking_app/data/local/database_service.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';

import '../../data/api/project_api.dart';

class ProjectRepository {
  ProjectRepository(this._api, this._databaseManager);

  final ProjectApi _api;
  final DatabaseManager _databaseManager;

  Future<ProjectRes> createProject({required String name}) async {
    return _api.createProject(name: name).then((response) {
      _databaseManager.insertProject(response);
      return response;
    });
  }

  Future<List<ProjectRes>> getAllProjects() async {
    try {
      return _api.getAllProjects();
    } catch (exception) {
      return _databaseManager.getProjects();
    }
  }

  Future<ProjectRes> updateProject({required ProjectRes project}) async {
    return _api
        .updateProject(projectId: project.id ?? "", name: project.name ?? "")
        .then((response) {
      _databaseManager.updateProject(project);
      return response;
    });
  }

  Future<void> deleteProject({required String projectId}) async {
    return _api.deleteProject(projectId: projectId).then((response) {
      _databaseManager.deleteProject(projectId);
      return response;
    });
  }
}
