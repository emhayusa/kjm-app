class PresensiResponseModel {
  final String email;
  final String password;

  PresensiResponseModel({
    required this.email,
    required this.password,
  });

  PresensiResponseModel copyWith({
    String? email,
    String? password,
  }) =>
      PresensiResponseModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory PresensiResponseModel.fromJson(Map<String, dynamic> json) =>
      PresensiResponseModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
