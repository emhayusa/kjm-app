import 'package:kjm_app/model/reportType.dart';
import 'package:kjm_app/model/lokasi.dart';
import 'package:kjm_app/model/reporter.dart';

class Reportan {
  String uuid;
  //String? description;
  //String? penanganan;
  String kronologi;
  String tindakan;
  String hasil;
  DateTime createdAt;
  ReportType reportType;
  Lokasi lokasi;
  Reporter user;

  Reportan({
    required this.uuid,
    //this.description,
    //this.penanganan,
    required this.kronologi,
    required this.tindakan,
    required this.hasil,
    required this.createdAt,
    required this.reportType,
    required this.lokasi,
    required this.user,
  });

  factory Reportan.fromJson(Map<String, dynamic> json) => Reportan(
        uuid: json["uuid"],
        //description: json["description"],
        //penanganan: json["penanganan"],
        kronologi: json["kronologi"],
        tindakan: json["tindakan"],
        hasil: json["hasil"],
        createdAt: DateTime.parse(json["createdAt"]),
        reportType: ReportType.fromJson(json["reportType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        //"description": description,
        //"penanganan": penanganan,
        "kronologi": kronologi,
        "tindakan": tindakan,
        "hasil": hasil,
        "createdAt": createdAt.toIso8601String(),
        "reportType": reportType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
