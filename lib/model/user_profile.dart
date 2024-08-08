class UserProfile {
  final String uuid;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? address;
  final String email;
  final String? createdBy;
  final String? updatedBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Role> roles;

  UserProfile({
    required this.uuid,
    required this.username,
    this.firstname,
    this.lastname,
    this.phone,
    this.address,
    required this.email,
    this.createdBy,
    this.updatedBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uuid: json['uuid'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      roles: (json['roles'] as List<dynamic>)
          .map((roleJson) => Role.fromJson(roleJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'address': address,
      'email': email,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'is_active': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }
}

class Role {
  final String name;

  Role({required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
