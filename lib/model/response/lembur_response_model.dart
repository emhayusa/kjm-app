class LemburResponseModel {
  final String email;
  final String password;

  LemburResponseModel({
    required this.email,
    required this.password,
  });

  LemburResponseModel copyWith({
    String? email,
    String? password,
  }) =>
      LemburResponseModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory LemburResponseModel.fromJson(Map<String, dynamic> json) =>
      LemburResponseModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
