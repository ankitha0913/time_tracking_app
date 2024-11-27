class CreateProjectReq {

  String? name;

  CreateProjectReq({
    this.name
  });

  CreateProjectReq.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
