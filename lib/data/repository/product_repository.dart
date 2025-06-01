import 'dart:typed_data';
import '../models/product_response.dart';
import '../provider/product_provider.dart';

class ProductRepository {
  final ProductProvider _productProvider = ProductProvider();

  Future<ProductResponse> fetchProducts() async {
    return await _productProvider.fetchProducts();
  }

  Future<Uint8List?> getImage(String imageUrl) async {
    return await _productProvider.getImage(imageUrl);
  }
}
