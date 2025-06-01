import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/product_response.dart';
import 'package:shopiera/core/constants/base_constants.dart'; // Mutlak import

const String path = "urunler";

class ProductProvider {
  Future<ProductResponse> fetchProducts() async {
    final response = await Dio().get(
      "${BaseInfo.apiUrl}/$path/tumUrunleriGetir.php",
    );

    if (response.statusCode == 200) {
      final body = response.data;
      final productResponse = ProductResponse.fromJson(json.decode(body));
      return productResponse;
    }

    throw Exception('Error fetching products...');
  }

  Future<Uint8List?> getImage(String imageUrl) async {
    try {
      final response = await Dio().get(
        "${BaseInfo.apiUrl}/$path/resimler/$imageUrl",
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception('Error fetching image...');
    } catch (e) {
      return null;
    }
  }
}
