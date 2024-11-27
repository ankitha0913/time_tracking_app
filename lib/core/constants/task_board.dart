enum TaskBoard {
  todo,
  inProgress,
  done;
}

extension TaskStateExtension on TaskBoard {
  String get stringValue {
    switch (this) {
      case TaskBoard.todo:
        return 'To Do';
      case TaskBoard.inProgress:
        return 'In Progress';
      case TaskBoard.done:
        return 'Done';
    }
  }

  static TaskBoard fromString(String value) {
    switch (value) {
      case 'Done':
        return TaskBoard.done;
      case 'In Progress':
        return TaskBoard.inProgress;
      case 'TO DO':
      default:
        return TaskBoard.todo;
    }
  }
}
