import 'package:hackathon_app/responses/action_response.dart';

class CreateProductResponse extends ActionResponse {
  CreateProductResponse({required String message, required int statusCode, required Map<String, dynamic> originalJson})
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static Future<CreateProductResponse> fromJson(Map<String, dynamic> json) async {
    return CreateProductResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}