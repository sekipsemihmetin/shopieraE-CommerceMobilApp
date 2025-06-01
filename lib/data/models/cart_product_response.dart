import 'package:shopiera/data/models/cart_product.dart';

final class CartProductResponse {
  final int success;
  final List<CartProduct> cartProducts;

  const CartProductResponse({
    required this.success,
    required this.cartProducts,
  });

  factory CartProductResponse.fromJson(Map<String, dynamic> json) =>
      CartProductResponse(
        success: int.parse(json['success'].toString()),
        cartProducts: (json['urunler_sepeti'] as List)
            .map((e) => CartProduct.fromJson(e))
            .toList(),
      );
}
