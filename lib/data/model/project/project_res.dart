class ProjectRes {
  String? id;
  String? name;

  ProjectRes({
     this.id,
     this.name,
  });

  factory ProjectRes.fromJson(Map<String, dynamic> json) {
    return ProjectRes(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

}
