class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? address;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.address,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "avatar": avatar,
      "phone": phone,
      "address": address,
      "role": role,
    };
  }
}
