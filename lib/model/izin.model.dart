class Izin {
  String uuid;
  DateTime tanggal;
  DateTime createdAt;
  User user;
  JenisPresensi jenisPresensi;

  Izin({
    required this.uuid,
    required this.tanggal,
    required this.createdAt,
    required this.user,
    required this.jenisPresensi,
  });

  factory Izin.fromJson(Map<String, dynamic> json) => Izin(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: User.fromJson(json["user"]),
        jenisPresensi: JenisPresensi.fromJson(json["jenisPresensi"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
        "jenisPresensi": jenisPresensi.toJson(),
      };
}

class JenisPresensi {
  int id;
  String uuid;
  String name;

  JenisPresensi({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory JenisPresensi.fromJson(Map<String, dynamic> json) => JenisPresensi(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
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
