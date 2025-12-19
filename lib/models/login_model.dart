class User {
  final int id;
  final String name;
  final String email;
  final String role; // thêm role

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'], // parse role
    );
  }
}

class LoginResponse {
  final String message; // thay success thành message
  final String token;
  final User user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}
