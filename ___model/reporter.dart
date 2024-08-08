class Reporter {
  int? id;
  String? uuid;
  String username;

  Reporter({
    this.id,
    this.uuid,
    required this.username,
  });

  factory Reporter.fromJson(Map<String, dynamic> json) => Reporter(
        id: json["id"],
        uuid: json["uuid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "username": username,
      };
}
