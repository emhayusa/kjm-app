class User {
  String uuid;
  String username;

  User({
    required this.uuid,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uuid: json["uuid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
      };
}
