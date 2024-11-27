import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/domain/repo/project_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ProjectRepository _projectRepository;

  DashboardBloc(
      {required ProjectRepository projectRepository,
      })
      : _projectRepository = projectRepository,
        super(DashboardInitial(projects: [])) {
    on<GetProjectsEvent>(_getProjectsEvent);
    on<CreateProjectEvent>(_createProjectEvent);
    on<UpdateProjectEvent>(_updateProjectEvent);
    on<DeleteProjectEvent>(_deleteProjectEvent);
  }

  void _getProjectsEvent(_, Emitter<DashboardState> emit) async {
    emit(DashboardLoading(projects: state.projects));
    try {
      await _projectRepository.getAllProjects().then((response) {
        state.projects?.clear();
        state.projects?.addAll(response);
        emit(DashboardSuccess(projects: state.projects));
      });
    } catch (exception) {
      emit(DashboardFailure(
          message: StringConstants.couldNotRefresh, projects: state.projects));
    }
  }

  void _createProjectEvent(
      CreateProjectEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading(projects: state.projects));
    try {
      await _projectRepository.createProject(name: event.name).then((response) {
        state.projects?.add(response);
        emit(DashboardSuccess(projects: state.projects));
      });
    } catch (exception) {
      emit(DashboardFailure(
          message: exception.toString(), projects: state.projects));
    }
  }

  void _updateProjectEvent(
      UpdateProjectEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading(projects: state.projects));
    try {
      await _projectRepository.updateProject(project: event.project).then((response) {
        final updatedProject = state.projects?.map((project) {
          if (project.id == event.project.id) {
            project.name = event.project.name;
            return project;
          }
          return project;
        }).toList();
        emit(DashboardSuccess(projects: updatedProject));
      });
    } catch (exception) {
      emit(DashboardFailure(
          message: exception.toString(), projects: state.projects));
    }
  }

  void _deleteProjectEvent(
      DeleteProjectEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading(projects: state.projects));
    try {
      await _projectRepository.deleteProject(projectId: event.project.id??"").then((response) {
        state.projects?.remove(event.project);
        emit(DashboardSuccess(projects: state.projects));
      });
    } catch (exception) {
      emit(DashboardFailure(
          message: exception.toString(), projects: state.projects));
    }
  }

}
