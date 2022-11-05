import 'package:hackathon_app/objects/ProductVariant.dart';

class Product {
  String name;
  String description;
  /*String? id;*/
  List<ProductVariant> variants;

  Product({required this.name, required this.description, required this.variants/*, this.id*/});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "variants": variants.map((e) => e.toJson()).toList()
    };
  }

/*  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      id: json['_id'],
      variants: json['variants'].map((e) => ProductVariant.fromJson(e)).toList(),
    );
  }*/
}