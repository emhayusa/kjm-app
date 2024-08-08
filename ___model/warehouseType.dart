class WarehouseType {
  int? id;
  String uuid;
  String name;

  WarehouseType({
    this.id,
    required this.uuid,
    required this.name,
  });

  factory WarehouseType.fromJson(Map<String, dynamic> json) => WarehouseType(
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
