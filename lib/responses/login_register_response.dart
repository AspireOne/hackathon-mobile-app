import '../objects/user.dart';

class LoginRegisterResponse {
  final Map<String, dynamic> originalJson;
  final String message;
  final int statusCode;
  final Data? data;

  LoginRegisterResponse({required this.message, required this.statusCode, required this.originalJson, this.data});

  static LoginRegisterResponse fromJson(Map<String, dynamic> json) {
    return LoginRegisterResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'] == Null || json['data'] == null ? null : Data.fromJson(json['data']),
    );
  }
}

class Data {
  String token;
  User? user;

  Data({required this.token, required this.user});

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
      user: User.fromJson(json['employee']),
    );
  }
}