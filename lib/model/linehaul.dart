class LinehaulModel {
  String uuid;
  String namaSopir;
  String noPolisi;
  String namaVendor;
  String jenisKendaraan;
  String asal;
  String noSuratJalan;
  String nomorSeal;
  String waktuStartAsal;
  String waktuTiba;
  String tujuan;
  String waktuTujuan;
  dynamic waktuBerangkat;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  User user;

  LinehaulModel({
    required this.uuid,
    required this.namaSopir,
    required this.noPolisi,
    required this.namaVendor,
    required this.jenisKendaraan,
    required this.asal,
    required this.noSuratJalan,
    required this.nomorSeal,
    required this.waktuStartAsal,
    required this.waktuTiba,
    required this.tujuan,
    required this.waktuTujuan,
    required this.waktuBerangkat,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory LinehaulModel.fromJson(Map<String, dynamic> json) => LinehaulModel(
        uuid: json["uuid"],
        namaSopir: json["nama_sopir"],
        noPolisi: json["no_polisi"],
        namaVendor: json["nama_vendor"],
        jenisKendaraan: json["jenis_kendaraan"],
        asal: json["asal"],
        noSuratJalan: json["no_surat_jalan"],
        nomorSeal: json["nomor_seal"],
        waktuStartAsal: json["waktu_start_asal"],
        waktuTiba: json["waktu_tiba"],
        tujuan: json["tujuan"],
        waktuTujuan: json["waktu_tujuan"],
        waktuBerangkat: json["waktu_berangkat"],
        createdAt: DateTime.parse(json["createdAt"]),
        warehouseType: WarehouseType.fromJson(json["warehouseType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "nama_sopir": namaSopir,
        "no_polisi": noPolisi,
        "nama_vendor": namaVendor,
        "jenis_kendaraan": jenisKendaraan,
        "asal": asal,
        "no_surat_jalan": noSuratJalan,
        "nomor_seal": nomorSeal,
        "waktu_start_asal": waktuStartAsal,
        "waktu_tiba": waktuTiba,
        "tujuan": tujuan,
        "waktu_tujuan": waktuTujuan,
        "waktu_berangkat": waktuBerangkat,
        "createdAt": createdAt.toIso8601String(),
        "warehouseType": warehouseType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}

class Lokasi {
  String uuid;
  String lokasiName;

  Lokasi({
    required this.uuid,
    required this.lokasiName,
  });

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        uuid: json["uuid"],
        lokasiName: json["lokasiName"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "lokasiName": lokasiName,
      };
}

class User {
  String uuid;
  String username;

  User({
    required this.uuid,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uuid: json["uuid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
      };
}

class WarehouseType {
  String uuid;
  String name;

  WarehouseType({
    required this.uuid,
    required this.name,
  });

  factory WarehouseType.fromJson(Map<String, dynamic> json) => WarehouseType(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}
