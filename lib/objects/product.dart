import 'package:hackathon_app/objects/ProductVariant.dart';

class Product {
  String name;
  String description;
  List<ProductVariant> variants;

  Product({required this.name, required this.description, required this.variants});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "variants": variants.map((e) => e.toJson()).toList()
    };
  }
}