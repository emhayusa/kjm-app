class InboundModel {
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
  dynamic waktuBerangkat;
  dynamic waktu3;
  dynamic waktu4;
  dynamic waktu5;
  dynamic waktu6;
  dynamic waktu7;
  dynamic waktu8;
  dynamic waktu9;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  User user;

  InboundModel({
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
    required this.waktuBerangkat,
    required this.waktu3,
    required this.waktu4,
    required this.waktu5,
    required this.waktu6,
    required this.waktu7,
    required this.waktu8,
    required this.waktu9,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory InboundModel.fromJson(Map<String, dynamic> json) => InboundModel(
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
        waktuBerangkat: json["waktu_berangkat"],
        waktu3: json["waktu3"],
        waktu4: json["waktu4"],
        waktu5: json["waktu5"],
        waktu6: json["waktu6"],
        waktu7: json["waktu7"],
        waktu8: json["waktu8"],
        waktu9: json["waktu9"],
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
        "waktu_berangkat": waktuBerangkat,
        "waktu3": waktu3,
        "waktu4": waktu4,
        "waktu5": waktu5,
        "waktu6": waktu6,
        "waktu7": waktu7,
        "waktu8": waktu8,
        "waktu9": waktu9,
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
