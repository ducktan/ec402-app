class SignupRequest {
  final String name;
  final String email;
  final String phone;
  final String password;

  SignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }
}

class SignupResponse {
  final String message;
  final int? userId;

  SignupResponse({
    required this.message,
    this.userId,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      userId: json['userId'],
    );
  }
}
