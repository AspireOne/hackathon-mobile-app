import 'package:hackathon_app/objects/shared_prefs.dart';
import 'package:hackathon_app/responses/action_response.dart';

import '../objects/user.dart';

class LoginRegisterResponse extends ActionResponse {
  final Data? data;

  LoginRegisterResponse({required String message, required int statusCode, required Map<String, dynamic> originalJson, this.data})
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

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