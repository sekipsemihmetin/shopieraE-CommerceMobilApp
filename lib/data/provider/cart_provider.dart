import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/base_constants.dart';
import '../../core/utils/dio_client.dart';
import '../models/cart_product_response.dart';
import '../models/add_cart.dart';
import '../models/delete_cart.dart';
import '../models/cart_response.dart';
import '../models/cart_product.dart';

class CartProvider {
  final Dio _dio = DioClient.dio;

  Future<CartProductResponse> fetchCartProducts(String username) async {
    final response = await _dio.post(
      '/urunler/sepettekiUrunleriGetir.php',
      data: FormData.fromMap({'kullaniciAdi': username}),
    );

    print("🔍 Sepet API yanıtı: ${response.data}");

    if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
      try {
        final parsedJson = json.decode(response.data);
        final originalResponse = CartProductResponse.fromJson(parsedJson);

        final groupedProducts = _groupCartProducts(originalResponse.cartProducts);

        return CartProductResponse(
          cartProducts: groupedProducts,
          success: originalResponse.success,
        );
      } catch (e) {
        throw Exception("JSON parse hatası: $e");
      }
    }

    throw Exception("Sepet alınamadı veya boş cevap döndü.");
  }

  List<CartProduct> _groupCartProducts(List<CartProduct> products) {
    final Map<String, CartProduct> groupedMap = {};

    for (final product in products) {
      final key = '${product.name}_${product.brand}_${product.price}';

      if (groupedMap.containsKey(key)) {
        final existing = groupedMap[key]!;
        groupedMap[key] = existing.copyWith(
          quantity: existing.quantity + product.quantity,
        );
      } else {
        groupedMap[key] = product;
      }
    }

    return groupedMap.values.toList();
  }

  Future<CartResponse> addToCart(AddCart item) async {
    final response = await _dio.post(
      '/urunler/sepeteUrunEkle.php',
      data: FormData.fromMap(item.toJson()),
    );

    if (response.statusCode == 200) {
      return CartResponse.fromJson(json.decode(response.data));
    }

    throw Exception("Ürün sepete eklenemedi");
  }

  Future<CartResponse> deleteFromCart(DeleteCart item) async {
    print("️ Single delete işlemi - ID: ${item.cardId}, User: ${item.username}");

    final response = await _dio.post(
      '/urunler/sepettenUrunSil.php',
      data: FormData.fromMap(item.toJson()),
    );

    print(" Single delete API yanıtı: ${response.data}");

    if (response.statusCode == 200) {
      final result = CartResponse.fromJson(json.decode(response.data));
      print(" Single delete sonucu - Success: ${result.success}, Message: ${result.message}");
      return result;
    }

    throw Exception("Ürün silinemedi");
  }


  Future<CartResponse> deleteAllProductFromCart(dynamic cartItem) async {
    print("️ Toplu silme işlemi başlatılıyor: ${cartItem.name}");
    print(" Ürün bilgileri:");
    print("   - CardId: ${cartItem.cardId}");
    print("   - Name: ${cartItem.name}");
    print("   - Brand: ${cartItem.brand}");
    print("   - Price: ${cartItem.price}");
    print("   - Quantity: ${cartItem.quantity}");
    print("   - Username: ${cartItem.username}");

    try {

      final username = cartItem.username ?? '';
      if (username.isEmpty) {
        throw Exception("Kullanıcı adı bulunamadı");
      }

      print(" Mevcut sepet çekiliyor...");
      final response = await _dio.post(
        '/urunler/sepettekiUrunleriGetir.php',
        data: FormData.fromMap({'kullaniciAdi': username}),
      );

      if (response.statusCode != 200) {
        throw Exception("Sepet bilgileri alınamadı");
      }

      final parsedJson = json.decode(response.data);
      final cartResponse = CartProductResponse.fromJson(parsedJson);

      print(" Mevcut sepette ${cartResponse.cartProducts.length} ürün var");


      final matchingItems = cartResponse.cartProducts.where((item) {
        final nameMatch = item.name.trim().toLowerCase() == cartItem.name.trim().toLowerCase();
        final brandMatch = (item.brand ?? '').trim().toLowerCase() == (cartItem.brand ?? '').trim().toLowerCase();
        final priceMatch = item.price == cartItem.price;

        print(" Karşılaştırma - ${item.name}:");
        print("   Name: '$nameMatch' (${item.name} vs ${cartItem.name})");
        print("   Brand: '$brandMatch' (${item.brand} vs ${cartItem.brand})");
        print("   Price: '$priceMatch' (${item.price} vs ${cartItem.price})");

        return nameMatch && brandMatch && priceMatch;
      }).toList();

      print(" Eşleşen kayıt sayısı: ${matchingItems.length}");

      if (matchingItems.isEmpty) {
        print("⚠ Silinecek ürün bulunamadı");
        return CartResponse(success: 0, message: "Silinecek ürün bulunamadı");
      }


      CartResponse? lastResponse;
      int deletedCount = 0;

      for (final item in matchingItems) {
        print("🗑️ Siliniyor: ID ${item.cardId}, Quantity: ${item.quantity}");


        for (int i = 0; i < item.quantity; i++) {
          final deleteItem = DeleteCart(
            cardId: item.cardId,
            username: item.username,
          );

          try {
            lastResponse = await deleteFromCart(deleteItem);
            deletedCount++;
            print(" Silme ${deletedCount} tamamlandı - Success: ${lastResponse.success}");

            if (lastResponse.success != 1) {
              print("⚠ Silme işlemi başarısız: ${lastResponse.message}");
              break;
            }
          } catch (e) {
            print(" Tek silme işlemi hatası: $e");
            throw e;
          }
        }
      }

      final finalResponse = lastResponse ?? CartResponse(success: 1, message: "Ürün tamamen silindi");
      print(" Toplu silme tamamlandı - Toplam ${deletedCount} adet silindi");

      return finalResponse;

    } catch (e) {
      print("Toplu silme işlemi hatası: $e");
      throw Exception("Ürün tamamen silinemedi: $e");
    }
  }


  Future<CartResponse> deleteAllProductFromCartAlternative(dynamic cartItem) async {
    print(" Alternatif silme yöntemi başlatılıyor: ${cartItem.name}");

    try {

      final deleteData = {
        'kullaniciAdi': cartItem.username ?? '',
        'ad': cartItem.name,
        'marka': cartItem.brand ?? '',
        'fiyat': cartItem.price.toString(),
        'tamamenSil': '1',
      };

      print(" Alternatif API'ye gönderilen veri: $deleteData");

      final response = await _dio.post(
        '/urunler/sepettenUrunSil.php',
        data: FormData.fromMap(deleteData),
      );

      print(" Alternatif API yanıtı: ${response.data}");

      if (response.statusCode == 200) {
        final result = CartResponse.fromJson(json.decode(response.data));
        print(" Alternatif silme sonucu - Success: ${result.success}");
        return result;
      }

      throw Exception("HTTP ${response.statusCode}: Alternatif silme başarısız");

    } catch (e) {
      print(" Alternatif silme işlemi hatası: $e");
      throw Exception("Alternatif silme yöntemi başarısız: $e");
    }
  }
}