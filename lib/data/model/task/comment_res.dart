class CommentRes {
  String? id;
  String? taskId;
  String? content;

  CommentRes({
    this.id,
    this.taskId,
    this.content,
  });

  factory CommentRes.fromJson(Map<String, dynamic> json) {
    return CommentRes(
      id: json['id'],
      taskId: json['task_id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId':taskId,
      'content': content,
    };
  }

}
