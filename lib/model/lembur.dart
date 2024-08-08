class Lembur {
  String uuid;
  DateTime tanggal;
  String longDatang;
  String latDatang;
  DateTime waktuDatang;
  dynamic longPulang;
  dynamic latPulang;
  DateTime? waktuPulang;
  String namaBackup;
  String lokasi;
  DateTime createdAt;
  User user;

  Lembur({
    required this.uuid,
    required this.tanggal,
    required this.longDatang,
    required this.latDatang,
    required this.waktuDatang,
    required this.longPulang,
    required this.latPulang,
    this.waktuPulang,
    required this.namaBackup,
    required this.lokasi,
    required this.createdAt,
    required this.user,
  });

  factory Lembur.fromJson(Map<String, dynamic> json) => Lembur(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        longDatang: json["longDatang"],
        latDatang: json["latDatang"],
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        longPulang: json["longPulang"],
        latPulang: json["latPulang"],
        waktuPulang: json["waktuPulang"] == null
            ? null
            : DateTime.parse(json["waktuPulang"]),
        namaBackup: json["namaBackup"],
        lokasi: json["lokasi"],
        createdAt: DateTime.parse(json["createdAt"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "longDatang": longDatang,
        "latDatang": latDatang,
        "waktuDatang": waktuDatang.toIso8601String(),
        "longPulang": longPulang,
        "latPulang": latPulang,
        "waktuPulang": waktuPulang?.toIso8601String(),
        "namaBackup": namaBackup,
        "lokasi": lokasi,
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  int id;
  String uuid;
  String username;

  User({
    required this.id,
    required this.uuid,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        uuid: json["uuid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "username": username,
      };
}
