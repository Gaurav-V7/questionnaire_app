class User {
  final String id;
  final String name;
  final String phone;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'avatar': avatar};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "",
      phone: json['phone'],
      avatar: (json.containsKey('avatar')) ? json['avatar'] : null,
    );
  }
}
