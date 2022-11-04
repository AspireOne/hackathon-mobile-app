import 'package:hackathon_app/responses/action_response.dart';

class GetProductResponse extends ActionResponse {
  final ProductData? data;

  GetProductResponse({required String message, required int statusCode, required Map<String, dynamic> originalJson, this.data})
      : super(message: message, statusCode: statusCode, originalJson: originalJson);

  static Future<GetProductResponse> fromJson(Map<String, dynamic> json) async {
    return GetProductResponse(
      originalJson: json,
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'] == Null || json['data'] == null ? null : await ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  String id;
  String name;
  String description;
  List<Variant> variants;

  ProductData({required this.id, required this.name, required this.description, required this.variants});

  static Future<ProductData> fromJson(Map<String, dynamic> json) async {
    // Convert json array to list of Variants.
    // Convert variants in json to list of Variants.
    List<Variant> variants = [];
    for (var variant in json["product"]['variants']) {
      variants.add(await Variant.fromJson(variant));
    }

    //List<Variant> variants = [];//json["product"]['variants'];

    return ProductData(
      id: json["product"]['_id'],
      name: json["product"]['name'],
      description: json["product"]['description'],
      variants: variants,
    );
  }
}

class Variant {
  String id;
  String name;
  int price;
  int count;

  Variant({required this.id, required this.name, required this.price, required this.count});

  static Future<Variant> fromJson(Map<String, dynamic> json) async {
    return Variant(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      count: json["count"]
    );
  }
}