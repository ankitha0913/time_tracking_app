class CompletedTaskRes {
  String? projectId;
  String? taskId;
  String? name;
  String? dateCompleted;

  CompletedTaskRes({
    this.projectId,
    this.taskId,
    this.name,
    this.dateCompleted,
  });

  factory CompletedTaskRes.fromJson(Map<String, dynamic> json) {
    return CompletedTaskRes(
      projectId: json['projectId'],
      taskId: json['taskId'],
      name: json['name'],
      dateCompleted: json['dateCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId':projectId,
      'taskId':taskId,
      'name':name,
      'dateCompleted': dateCompleted,
    };
  }

}
