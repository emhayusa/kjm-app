class PresensiRequestModel {
  final String email;
  final String password;

  PresensiRequestModel({
    required this.email,
    required this.password,
  });

  PresensiRequestModel copyWith({
    String? email,
    String? password,
  }) =>
      PresensiRequestModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory PresensiRequestModel.fromJson(Map<String, dynamic> json) =>
      PresensiRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
