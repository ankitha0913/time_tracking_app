part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

final class GetTasksEvent extends ProjectEvent {
  final String projectId;
  GetTasksEvent({required this.projectId});

}

final class CreateTaskEvent extends ProjectEvent {
  final String projectId;
  final String name;

  CreateTaskEvent({required this.projectId,required this.name});
}

final class UpdateTaskEvent extends ProjectEvent {
  final TaskRes task;

  UpdateTaskEvent({required this.task});
}

final class GetCommentsEvent extends ProjectEvent {
  final String taskId;
  GetCommentsEvent({required this.taskId});
}

final class AddCommentEvent extends ProjectEvent {
  final CommentRes comment;

  AddCommentEvent({required this.comment});
}

final class DeleteTaskEvent extends ProjectEvent {
  final TaskRes task;
  DeleteTaskEvent({required this.task});
}

final class TaskCompleteEvent extends ProjectEvent {
  final CompletedTaskRes task;
  TaskCompleteEvent({required this.task});
}

final class UndoCompleteEvent extends ProjectEvent {
  final TaskRes task;
  UndoCompleteEvent({required this.task});
}

final class GetHistoryEvent extends ProjectEvent {
  final String projectId;
  GetHistoryEvent({required this.projectId});
}

final class GetTaskInfoEvent extends ProjectEvent {
  final String projectId;
  final String taskId;
  final List<CompletedTaskRes> historyTasks;

  GetTaskInfoEvent(this.historyTasks, {required this.projectId,required this.taskId});

}


final class HistoryEvent extends ProjectEvent {
  final List<CompletedTaskRes> historyTasks;

  HistoryEvent(this.historyTasks,);

}
