part of 'project_bloc.dart';

sealed class ProjectState {
  List<TaskRes>? tasks;
  ProjectState({this.tasks});
}

final class ProjectInitial extends ProjectState {
  ProjectInitial({super.tasks});
}

final class ProjectLoading extends ProjectState {
  ProjectLoading({super.tasks});
}

final class ProjectSuccess extends ProjectState {
  ProjectSuccess({super.tasks});
}

final class ProjectFailure extends ProjectState {
  final String message;
  ProjectFailure({
    required this.message,
    super.tasks,
  });
}

final class HistorySuccess extends ProjectState {
  final List<CompletedTaskRes> historyTasks;
  final TaskRes? selectedTask;

  HistorySuccess({
    required this.historyTasks,
    this.selectedTask,
    super.tasks,
  });
}
