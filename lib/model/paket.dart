import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';

class Paketan {
  String uuid;
  String namaPenerima;
  String namaPengirim;
  String keterangan;
  String alamat;
  String hp;
  DateTime tanggal;
  DateTime waktuDatang;
  dynamic waktuAmbil;
  DateTime createdAt;
  Reporter user;
  Lokasi lokasi;
  Reporter? reporter;

  Paketan({
    required this.uuid,
    required this.namaPenerima,
    required this.namaPengirim,
    required this.keterangan,
    required this.alamat,
    required this.hp,
    required this.tanggal,
    required this.waktuDatang,
    required this.waktuAmbil,
    required this.createdAt,
    required this.user,
    required this.lokasi,
    required this.reporter,
  });

  factory Paketan.fromJson(Map<String, dynamic> json) => Paketan(
        uuid: json["uuid"],
        namaPenerima: json["namaPenerima"],
        namaPengirim: json["namaPengirim"],
        keterangan: json["keterangan"],
        alamat: json["alamat"],
        hp: json["hp"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        waktuAmbil: json["waktuAmbil"] == null
            ? null
            : DateTime.parse(json["waktuAmbil"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: Reporter.fromJson(json["user"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        reporter: json["reporter"] == null
            ? null
            : Reporter.fromJson(json["reporter"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "namaPenerima": namaPenerima,
        "namaPengirim": namaPengirim,
        "keterangan": keterangan,
        "alamat": alamat,
        "hp": hp,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuDatang": waktuDatang.toIso8601String(),
        "waktuAmbil": waktuAmbil,
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
        "lokasi": lokasi.toJson(),
        "reporter": reporter?.toJson(),
      };
}
