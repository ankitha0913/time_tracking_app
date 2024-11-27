class CreateTaskReq {
  String? name;
  String? projectId;
  String? description;

  CreateTaskReq({this.name,this.projectId,this.description});

  CreateTaskReq.fromJson(dynamic json) {
    name = json['content'];
    projectId= json['project_id'];
    description= json['description'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = name;
    map['project_id'] = projectId;
    map['description'] = description ?? "";
    return map;
  }
}
