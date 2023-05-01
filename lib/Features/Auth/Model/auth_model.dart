import '../../../../core/Utils/Constants/auth_constants.dart';

class AuthModel {
  final String? userName;
  final String email;
  final String? password;
  final String? phone;

  const AuthModel(
      {this.userName, required this.email, this.password, this.phone});

  factory AuthModel.fromJson(Map<String, dynamic> map) {
    return AuthModel(
      email: map[AuthConstants.kEmail],
      password: map[AuthConstants.kPassword] ?? '',
      userName: map[AuthConstants.kUserName] ?? '',
      phone: map[AuthConstants.kPhone] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AuthConstants.kEmail: email,
      AuthConstants.kUserName: userName,
      AuthConstants.kPassword: password,
      AuthConstants.kPhone: phone
    };
  }
}
