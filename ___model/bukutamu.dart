import 'lokasi.dart';
import 'reporter.dart';

class Bukutamu {
  String uuid;
  String namaTamu;
  String asal;
  String tujuan;
  String keperluan;
  DateTime tanggal;
  DateTime waktuDatang;
  DateTime? waktuPulang;
  DateTime createdAt;
  Reporter user;
  Lokasi lokasi;
  Reporter? reporter;

  Bukutamu({
    required this.uuid,
    required this.namaTamu,
    required this.asal,
    required this.tujuan,
    required this.keperluan,
    required this.tanggal,
    required this.waktuDatang,
    this.waktuPulang,
    required this.createdAt,
    required this.user,
    required this.lokasi,
    this.reporter,
  });

  factory Bukutamu.fromJson(Map<String, dynamic> json) => Bukutamu(
        uuid: json["uuid"],
        namaTamu: json["namaTamu"],
        asal: json["asal"],
        tujuan: json["tujuan"],
        keperluan: json["keperluan"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        waktuPulang: json["waktuPulang"] == null
            ? null
            : DateTime.parse(json["waktuPulang"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: Reporter.fromJson(json["user"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        reporter: json["reporter"] == null
            ? null
            : Reporter.fromJson(json["reporter"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "namaTamu": namaTamu,
        "asal": asal,
        "tujuan": tujuan,
        "keperluan": keperluan,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuDatang": waktuDatang.toIso8601String(),
        "waktuPulang": waktuPulang?.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
        "lokasi": lokasi.toJson(),
        "reporter": reporter?.toJson(),
      };
}
