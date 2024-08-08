class LemburRequestModel {
  final String email;
  final String password;

  LemburRequestModel({
    required this.email,
    required this.password,
  });

  LemburRequestModel copyWith({
    String? email,
    String? password,
  }) =>
      LemburRequestModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory LemburRequestModel.fromJson(Map<String, dynamic> json) =>
      LemburRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
