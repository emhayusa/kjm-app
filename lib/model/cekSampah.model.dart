import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';

class CekSampahModel {
  String uuid;
  String deskripsi;
  String nama_petugas;
  String nama_vendor;
  String? temuan;
  DateTime createdAt;
  Lokasi lokasi;
  Reporter user;

  CekSampahModel({
    required this.uuid,
    required this.deskripsi,
    required this.nama_petugas,
    required this.nama_vendor,
    required this.temuan,
    required this.createdAt,
    required this.lokasi,
    required this.user,
  });

  factory CekSampahModel.fromJson(Map<String, dynamic> json) => CekSampahModel(
        uuid: json["uuid"],
        deskripsi: json["deskripsi"],
        nama_petugas: json["nama_petugas"],
        nama_vendor: json["nama_vendor"],
        temuan: json["temuan"],
        createdAt: DateTime.parse(json["createdAt"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "deskripsi": deskripsi,
        "nama_petugas": nama_petugas,
        "nama_vendor": nama_vendor,
        "temuan": temuan,
        "createdAt": createdAt.toIso8601String(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
