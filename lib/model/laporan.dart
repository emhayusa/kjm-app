import 'package:kjm_app/model/lokasi.dart';
import 'package:kjm_app/model/reportType.dart';
import 'package:kjm_app/model/reporter.dart';

class Laporan {
  int id;
  String uuid;
  String description;
  DateTime createdAt;
  ReportType reportType;
  Lokasi lokasi;
  Reporter user;

  Laporan({
    required this.id,
    required this.uuid,
    required this.description,
    required this.createdAt,
    required this.reportType,
    required this.lokasi,
    required this.user,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        id: json["id"],
        uuid: json["uuid"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        reportType: ReportType.fromJson(json["reportType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "reportType": reportType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
