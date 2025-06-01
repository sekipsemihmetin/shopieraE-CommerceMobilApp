import 'package:equatable/equatable.dart';
import '../../../data/models/cart_product.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartProduct> cartItems;

  const CartLoaded({required this.cartItems});

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
