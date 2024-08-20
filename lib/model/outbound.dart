class OutboundModel {
  String uuid;
  String namaSopir;
  String noPolisi;
  String namaVendor;
  String jenisKendaraan;
  String asal;
  String waktuTiba;
  dynamic waktuBerangkat;
  dynamic waktuMuat;
  dynamic waktuSelesai;
  dynamic jumlahTo;
  dynamic jumlahPaket;
  dynamic jumlahBarhal;
  dynamic jumlahMissRute;
  dynamic waktuReturn;
  dynamic waktu2;
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

  OutboundModel({
    required this.uuid,
    required this.namaSopir,
    required this.noPolisi,
    required this.namaVendor,
    required this.jenisKendaraan,
    required this.asal,
    required this.waktuTiba,
    required this.waktuBerangkat,
    required this.waktuMuat,
    required this.waktuSelesai,
    required this.jumlahTo,
    required this.jumlahPaket,
    required this.jumlahBarhal,
    required this.jumlahMissRute,
    required this.waktuReturn,
    required this.waktu2,
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

  factory OutboundModel.fromJson(Map<String, dynamic> json) => OutboundModel(
        uuid: json["uuid"],
        namaSopir: json["nama_sopir"],
        noPolisi: json["no_polisi"],
        namaVendor: json["nama_vendor"],
        jenisKendaraan: json["jenis_kendaraan"],
        asal: json["asal"],
        waktuTiba: json["waktu_tiba"],
        waktuBerangkat: json["waktu_berangkat"],
        waktuMuat: json["waktu_muat"],
        waktuSelesai: json["waktu_selesai"],
        jumlahTo: json["jumlah_to"],
        jumlahPaket: json["jumlah_paket"],
        jumlahBarhal: json["jumlah_barhal"],
        jumlahMissRute: json["jumlah_miss_rute"],
        waktuReturn: json["waktu_return"],
        waktu2: json["waktu2"],
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
        "waktu_tiba": waktuTiba,
        "waktu_berangkat": waktuBerangkat,
        "waktu_muat": waktuMuat,
        "waktu_selesai": waktuSelesai,
        "jumlah_to": jumlahTo,
        "jumlah_paket": jumlahPaket,
        "jumlah_barhal": jumlahBarhal,
        "jumlah_miss_rute": jumlahMissRute,
        "waktu_return": waktuReturn,
        "waktu2": waktu2,
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
