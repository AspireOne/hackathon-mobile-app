abstract class ActionResponse {
  final Map<String, dynamic> originalJson;
  final String message;
  final int statusCode;

  ActionResponse({required this.message, required this.statusCode, required this.originalJson});
}