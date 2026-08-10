class AuthResponse {
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final String? email;
  final String? role;

  AuthResponse({
    this.message,
    required this.accessToken,
    required this.refreshToken,
    this.userId,
    this.email,
    this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}
