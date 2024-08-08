import 'lokasi.dart';
import 'reporter.dart';

class CekSampahModel {
  String uuid;
  String description;
  DateTime createdAt;
  Lokasi lokasi;
  Reporter user;

  CekSampahModel({
    required this.uuid,
    required this.description,
    required this.createdAt,
    required this.lokasi,
    required this.user,
  });

  factory CekSampahModel.fromJson(Map<String, dynamic> json) => CekSampahModel(
        uuid: json["uuid"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
