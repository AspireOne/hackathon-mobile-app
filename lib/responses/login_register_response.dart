import 'package:hackathon_app/objects/SharedPrefs.dart';

import '../objects/user.dart';

class LoginRegisterResponse {
  final Map<String, dynamic> originalJson;
  final String message;
  final int statusCode;
  final Data? data;

  LoginRegisterResponse({required this.message, required this.statusCode, required this.originalJson, this.data});

  static Future<LoginRegisterResponse> fromJson(Map<String, dynamic> json) async {
    return LoginRegisterResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'] == Null || json['data'] == null ? null : await Data.fromJson(json['data']),
    );
  }
}

class Data {
  String token;
  User? user;

  Data({required this.token, required this.user});

  static Future<Data> fromJson(Map<String, dynamic> json) async {
    return Data(
      token: json['token'] ?? await PrefsObject.getToken(),
      user: User.fromJson(json['employee']),
    );
  }
}