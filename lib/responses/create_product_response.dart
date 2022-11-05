import 'package:hackathon_app/objects/product.dart';
import 'package:hackathon_app/responses/action_response.dart';

class CreateProductResponse extends ActionResponse {
  Data? data;

  CreateProductResponse({required String message, required int statusCode, required Map<String, dynamic> originalJson, this.data})
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static Future<CreateProductResponse> fromJson(Map<String, dynamic> json) async {
    return CreateProductResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  ResponseProduct product;

  Data({required this.product});

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
      product: ResponseProduct.fromJson(json['product']),
    );
  }
}

class ResponseProduct {
  String name;
  String id;
  String description;

  ResponseProduct({required this.name, required this.id, required this.description});

  static ResponseProduct fromJson(Map<String, dynamic> json) {
    return ResponseProduct(
      name: json['name'],
      id: json['_id'],
      description: json['description'],
    );
  }
}