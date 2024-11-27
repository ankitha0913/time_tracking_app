import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/data/model/task/comment_res.dart';
import 'package:time_tracking_app/data/model/task/completed_task_res.dart';

import '../../../../core/constants/task_board.dart';
import '../../../../data/model/Task/Task_res.dart';
import '../../../../domain/repo/task_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final TaskRepository _taskRepository;

  ProjectBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(ProjectInitial(tasks: [])) {
    on<GetTasksEvent>(_getTasksEvent);
    on<CreateTaskEvent>(_createTaskEvent);
    on<GetCommentsEvent>(_getCommentsEvent);
    on<AddCommentEvent>(_addCommentEvent);
    on<UpdateTaskEvent>(_updateTaskEvent);
    on<DeleteTaskEvent>(_deleteTaskEvent);
    on<TaskCompleteEvent>(_taskCompleteEvent);
    on<UndoCompleteEvent>(_undoCompleteEvent);
    on<GetHistoryEvent>(_getHistoryEvent);
    on<GetTaskInfoEvent>(_getTaskInfoEvent);
    on<HistoryEvent>((event, emit) => emit(
        HistorySuccess(historyTasks: event.historyTasks, tasks: state.tasks)));
  }

  void _createTaskEvent(
      CreateTaskEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading(tasks: state.tasks));
    try {
      await _taskRepository
          .createTask(name: event.name, projectId: event.projectId)
          .then((response) {
        state.tasks?.add(response);
        response.state = TaskBoard.todo.stringValue;
        emit(ProjectSuccess(tasks: state.tasks));
      });
    } catch (exception) {
      emit(ProjectFailure(message: exception.toString(), tasks: state.tasks));
    }
  }

  void _getTasksEvent(GetTasksEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading(tasks: state.tasks));
    try {
      await _taskRepository
          .getAllTasks(projectId: event.projectId)
          .then((dbResponse) {
        state.tasks?.clear();
        state.tasks?.addAll(dbResponse);
        emit(ProjectSuccess(tasks: state.tasks));
      });
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.couldNotLoadData, tasks: state.tasks));
    }
  }

  void _deleteTaskEvent(
      DeleteTaskEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading(tasks: state.tasks));
    try {
      await _taskRepository
          .deleteTask(taskId: event.task.id ?? "")
          .then((response) {
        state.tasks?.remove(event.task);
        emit(ProjectSuccess(tasks: state.tasks));
      });
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.somethingWentWrong, tasks: state.tasks));
    }
  }

  void _getCommentsEvent(
      GetCommentsEvent event, Emitter<ProjectState> emit) async {
    try {
      await _taskRepository.getComments(taskId: event.taskId).then((comments) {
        final updatedTasks = state.tasks?.map((task) {
          if (task.id == event.taskId) {
            task.comments = comments;
            return task;
          }
          return task;
        }).toList();
        emit(ProjectSuccess(tasks: updatedTasks));
      });
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.couldNotLoadData, tasks: state.tasks));
    }
  }

  void _addCommentEvent(
      AddCommentEvent event, Emitter<ProjectState> emit) async {
    try {
      await _taskRepository.addComment(comment: event.comment);
      emit(ProjectSuccess(tasks: state.tasks));
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.couldNotLoadData, tasks: state.tasks));
    }
  }

  void _updateTaskEvent(
      UpdateTaskEvent event, Emitter<ProjectState> emit) async {
    try {
      await _taskRepository.updateTask(task: event.task);
      emit(ProjectSuccess(tasks: state.tasks));
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.somethingWentWrong, tasks: state.tasks));
    }
  }

  void _taskCompleteEvent(
      TaskCompleteEvent event, Emitter<ProjectState> emit) async {
    try {
      await _taskRepository.addTaskToHistory(task: event.task);
      emit(ProjectSuccess(tasks: state.tasks));
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.somethingWentWrong, tasks: state.tasks));
    }
  }

  void _undoCompleteEvent(UndoCompleteEvent event, Emitter<ProjectState> emit) {
    try {
      _taskRepository.deleteFromHistory(
          projectId: event.task.projectId ?? "", taskId: event.task.id ?? "");
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.historyErrorMessage, tasks: state.tasks));
    }
  }

  void _getHistoryEvent(
      GetHistoryEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading(tasks: state.tasks));
    try {
      await _taskRepository.getHistory(projectId: event.projectId).then(
          (response) =>
              emit(HistorySuccess(historyTasks: response, tasks: state.tasks)));
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.somethingWentWrong, tasks: state.tasks));
    }
  }

  void _getTaskInfoEvent(
      GetTaskInfoEvent event, Emitter<ProjectState> emit) async {
    try {
      await _taskRepository
          .getTask(projectId: event.projectId, taskId: event.taskId)
          .then((task) => emit(HistorySuccess(
              historyTasks: event.historyTasks,
              selectedTask: task,
              tasks: state.tasks)));
    } catch (exception) {
      emit(ProjectFailure(
          message: StringConstants.couldNotLoadData, tasks: state.tasks));
    }
  }
}
