import 'package:hackathon_app/responses/action_response.dart';

class ChangeVariantCountResponse extends ActionResponse {

  // Create a constructor that passes arguments to super class.
  ChangeVariantCountResponse(int statusCode, String message, Map<String, dynamic> originalJson)
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static ChangeVariantCountResponse fromJson(Map<String, dynamic> json) {
    return ChangeVariantCountResponse(json['statusCode'], json['message'], json);
  }
}