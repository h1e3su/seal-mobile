class RegisterRequest {
  final String email;
  final String password;
  final String fullName;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'fullName': fullName,
    };
  }
}
