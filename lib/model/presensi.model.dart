import 'package:kjm_app/model/jenisPresensi.dart';
import 'package:kjm_app/model/reporter.dart';

class Presensi {
  String uuid;
  DateTime tanggal;
  String longDatang;
  String latDatang;
  String? namaBackup;
  DateTime waktuDatang;
  dynamic longPulang;
  dynamic latPulang;
  DateTime? waktuPulang;
  DateTime createdAt;
  Reporter user;
  JenisPresensi jenisPresensi;

  Presensi({
    required this.uuid,
    required this.tanggal,
    required this.longDatang,
    required this.latDatang,
    this.namaBackup,
    required this.waktuDatang,
    this.longPulang,
    this.latPulang,
    this.waktuPulang,
    required this.createdAt,
    required this.user,
    required this.jenisPresensi,
  });

  factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        longDatang: json["longDatang"],
        latDatang: json["latDatang"],
        namaBackup: json["namaBackup"],
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        longPulang: json["longPulang"],
        latPulang: json["latPulang"],
        waktuPulang: json["waktuPulang"] == null
            ? null
            : DateTime.parse(json["waktuPulang"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: Reporter.fromJson(json["user"]),
        jenisPresensi: JenisPresensi.fromJson(json["jenisPresensi"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "longDatang": longDatang,
        "latDatang": latDatang,
        "namaBackup": namaBackup,
        "waktuDatang": waktuDatang.toIso8601String(),
        "longPulang": longPulang,
        "latPulang": latPulang,
        "waktuPulang": waktuPulang?.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
        "jenisPresensi": jenisPresensi.toJson(),
      };
}
