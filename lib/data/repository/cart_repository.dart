import '../provider/cart_provider.dart';
import '../models/cart_product_response.dart';
import '../models/add_cart.dart';
import '../models/delete_cart.dart';
import '../models/cart_response.dart';
import '../models/cart_product.dart';
import '../../core/constants/base_constants.dart';

class CartRepository {
  final CartProvider _provider = CartProvider();

  Future<CartProductResponse> fetchCartProducts() {
    return _provider.fetchCartProducts(BaseInfo.username);
  }

  Future<CartResponse> addToCart(AddCart item) {
    return _provider.addToCart(item);
  }

  Future<CartResponse> deleteFromCart(DeleteCart item) {
    return _provider.deleteFromCart(item);
  }

  Future<CartResponse> deleteAllProductFromCart(CartProduct product) {
    return _provider.deleteAllProductFromCart(product);
  }
  Future<CartResponse> deleteAllProductFromCartAlternative(CartProduct product) {

    return _provider.deleteAllProductFromCartAlternative(product);
  }

}
