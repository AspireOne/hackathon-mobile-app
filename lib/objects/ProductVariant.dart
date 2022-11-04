class ProductVariant {
  String name;
  int price;
  int count;

  ProductVariant({required this.name, required this.price, required this.count});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "count": count
    };
  }
}