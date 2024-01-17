class UserModel {
  final String email;
  final String username;
  final String password;

  const UserModel({
    required this.email,
    required this.username,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) =>
      UserModel(email: json["email"], username: json["username"], password: json["password"]);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'password': password,
    };
  }
}