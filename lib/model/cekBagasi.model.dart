import 'package:kjm_app/model/lokasi.dart';
import 'package:kjm_app/model/reporter.dart';

class CekBagasiModel {
  String uuid;
  String deskripsi;
  String nama_perwakilan;
  String nama_supervisor;
  String temuan;
  String waktu_mulai;
  String waktu_selesai;
  DateTime createdAt;
  Lokasi lokasi;
  Reporter user;

  CekBagasiModel({
    required this.uuid,
    required this.deskripsi,
    required this.nama_perwakilan,
    required this.nama_supervisor,
    required this.temuan,
    required this.waktu_mulai,
    required this.waktu_selesai,
    required this.createdAt,
    required this.lokasi,
    required this.user,
  });

  factory CekBagasiModel.fromJson(Map<String, dynamic> json) => CekBagasiModel(
        uuid: json["uuid"],
        deskripsi: json["deskripsi"],
        nama_perwakilan: json["nama_perwakilan"],
        nama_supervisor: json["nama_supervisor"],
        temuan: json["temuan"],
        waktu_mulai: json["waktu_mulai"],
        waktu_selesai: json["waktu_selesai"],
        createdAt: DateTime.parse(json["createdAt"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "deskripsi": deskripsi,
        "nama_perwakilan": nama_perwakilan,
        "nama_supervisor": nama_supervisor,
        "temuan": temuan,
        "waktu_mulai": waktu_mulai,
        "waktu_selesai": waktu_selesai,
        "createdAt": createdAt.toIso8601String(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
