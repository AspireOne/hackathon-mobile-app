import 'package:hackathon_app/responses/action_response.dart';

class AddProductToWarehouseResponse extends ActionResponse {
  AddProductToWarehouseResponse({required String message, required int statusCode, required Map<String, dynamic> originalJson})
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static AddProductToWarehouseResponse fromJson(Map<String, dynamic> json) {
    return AddProductToWarehouseResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}