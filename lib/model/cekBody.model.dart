import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';

class CekBodyModel {
  String uuid;
  String description;
  String? temuan;
  DateTime createdAt;
  Lokasi lokasi;
  Reporter user;

  CekBodyModel({
    required this.uuid,
    required this.description,
    required this.temuan,
    required this.createdAt,
    required this.lokasi,
    required this.user,
  });

  factory CekBodyModel.fromJson(Map<String, dynamic> json) => CekBodyModel(
        uuid: json["uuid"],
        description: json["description"],
        temuan: json["temuan"],
        createdAt: DateTime.parse(json["createdAt"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "description": description,
        "temuan": temuan,
        "createdAt": createdAt.toIso8601String(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
