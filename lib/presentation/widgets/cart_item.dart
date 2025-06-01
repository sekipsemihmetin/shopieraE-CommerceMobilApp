import 'package:flutter/material.dart';
import '../../data/models/cart_product.dart';
import '../../logic/cubit/cart/cart_cubit.dart';
import '../../data/models/delete_cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/base_constants.dart';

class CartItem extends StatelessWidget {
  final CartProduct cartProduct;

  const CartItem({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "${BaseInfo.imageUrl}/${cartProduct.image}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => const Icon(Icons.image),
        ),
        title: Text(cartProduct.name),
        subtitle: Text("Adet: ${cartProduct.quantity} • ₺${cartProduct.price}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context.read<CartCubit>().deleteFromCart(
              DeleteCart(
                cardId: cartProduct.cardId,
                username: cartProduct.username,
              ),
            );
          },
        ),
      ),
    );

  }
}
