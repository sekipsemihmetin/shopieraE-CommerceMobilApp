import '../models/product.dart';
class ProductResponse {
  final int success;
  final List<Product> products;

  const ProductResponse({
    required this.success,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: int.parse(json['success'].toString()),
      products: (json['urunler'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
