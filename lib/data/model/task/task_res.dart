import 'package:time_tracking_app/data/model/task/comment_res.dart';

class TaskRes {
  String? id;
  String? projectId;
  String? name;
  String? description;
  String? state;
  int? timeSpent;
  List<CommentRes>? comments;

  TaskRes(
      {this.id,
      this.projectId,
      this.name,
      this.description,
      this.state,
        this.timeSpent,
      this.comments});

  factory TaskRes.fromJson(Map<String, dynamic> json) {
    return TaskRes(
      id: json['id'],
      projectId: json['project_id'],
      name: json['content'],
      description: json['description'],
      state: json['state'],
      timeSpent: json['timeSpent'],
      comments: (json['comments'] as List<dynamic>?)
          ?.map(
              (comment) => CommentRes.fromJson(comment as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toDbJson() {
    return {
      'id': id,
      'projectId': projectId,
      'content': name,
      'description': description,
      'state': state,
      'timeSpent': timeSpent,
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = toDbJson();
    jsonData['comments'] =
        comments?.map((comment) => comment.toJson()).toList();
    return jsonData;
  }
}
