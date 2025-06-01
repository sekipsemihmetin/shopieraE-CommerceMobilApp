import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/add_cart.dart';
import '../../../data/models/delete_cart.dart';
import '../../../data/models/cart_product.dart';
import '../../../data/repository/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartInitial());

  Future<void> fetchCartItems() async {
    emit(CartLoading());
    try {
      final result = await repository.fetchCartProducts();
      emit(CartLoaded(cartItems: result.cartProducts));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> addToCart(AddCart item) async {
    try {
      await repository.addToCart(item);
      fetchCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> deleteFromCart(DeleteCart item) async {
    try {
      await repository.deleteFromCart(item);
      fetchCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }


  Future<void> removeProductCompletely(dynamic cartItem) async {
    try {

      final currentState = state;
      if (currentState is! CartLoaded) return;


      emit(CartLoading());

      print(" Silme işlemi başlatılıyor: ${cartItem.name}");
      print(" Silinecek ürün bilgileri:");
      print("   - ID: ${cartItem.cardId}");
      print("   - Ad: ${cartItem.name}");
      print("   - Marka: ${cartItem.brand}");
      print("   - Fiyat: ${cartItem.price}");
      print("   - Miktar: ${cartItem.quantity}");
      print("   - Kullanıcı: ${cartItem.username}");


      for (int i = 0; i < cartItem.quantity; i++) {
        final deleteItem = DeleteCart(
          cardId: cartItem.cardId,
          username: cartItem.username,
        );

        print(" Silme ${i + 1}/${cartItem.quantity} işlemi başlatılıyor...");
        final response = await repository.deleteFromCart(deleteItem);
        print(" Silme ${i + 1}/${cartItem.quantity} tamamlandı - Success: ${response.success}");

        if (response.success != 1) {
          print(" Silme işlemi başarısız: ${response.message}");
          emit(CartError(message: "Ürün silinemedi: ${response.message}"));
          return;
        }
      }

      print(" Tüm silme işlemleri tamamlandı, sepet yenileniyor...");


      await fetchCartItems();

    } catch (e) {
      print(" CartCubit silme hatası: $e");


      try {
        print("🔄 Alternatif silme yöntemi deneniyor...");
        await repository.deleteAllProductFromCartAlternative(cartItem);
        await fetchCartItems();
        print(" Alternatif yöntemle silme başarılı");
      } catch (alternativeError) {
        print(" Alternatif yöntem de başarısız: $alternativeError");
        emit(CartError(message: "Ürün silinemedi: $alternativeError"));
      }
    }
  }

  Future<void> increaseQuantity(CartProduct product) async {
    try {
      final addCartItem = AddCart(
        name: product.name,
        image: product.image,
        category: product.category,
        price: product.price,
        brand: product.brand,
        username: product.username,
        quantity: 1,
      );
      await repository.addToCart(addCartItem);
      fetchCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> decreaseQuantity(CartProduct product) async {
    try {
      if (product.quantity > 1) {
        final deleteCartItem = DeleteCart(
          cardId: product.cardId,
          username: product.username,
        );
        await repository.deleteFromCart(deleteCartItem);
        fetchCartItems();
      } else {
        await removeProductCompletely(product);
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  void deleteFromCartById(int cardId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      final item = currentState.cartItems.firstWhere((e) => e.cardId == cardId);
      deleteFromCart(DeleteCart(cardId: item.cardId, username: item.username));
    }
  }
}