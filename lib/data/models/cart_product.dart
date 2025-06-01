import 'package:meta/meta.dart';
import 'add_cart.dart';

@immutable
final class CartProduct {
  final int cardId;
  final String name;
  final String image;
  final String category;
  final int price;
  final String brand;
  final int quantity;
  final String username;

  const CartProduct({
    required this.cardId,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.brand,
    required this.quantity,
    required this.username,
  });


  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
    cardId: json['sepetId'] as int,
    name: json['ad'] as String,
    image: json['resim'] as String,
    category: json['kategori'] as String,
    price: json['fiyat'] as int,
    brand: json['marka'] as String,
    quantity: json['siparisAdeti'] as int,
    username: json['kullaniciAdi'] as String,
  );


  CartProduct copyWith({
    int? cardId,
    String? name,
    String? image,
    String? category,
    int? price,
    String? brand,
    int? quantity,
    String? username,
  }) {
    return CartProduct(
      cardId: cardId ?? this.cardId,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      username: username ?? this.username,
    );
  }


  AddCart toAddCart() {
    return AddCart(
      name: name,
      image: image,
      category: category,
      price: price,
      brand: brand,
      quantity: quantity,
      username: username,
    );
  }


  Map<String, dynamic> toJson() => {
    'sepetId': cardId,
    'ad': name,
    'resim': image,
    'kategori': category,
    'fiyat': price,
    'marka': brand,
    'siparisAdeti': quantity,
    'kullaniciAdi': username,
  };


  List<Object?> get props => [
    cardId,
    name,
    image,
    category,
    price,
    brand,
    quantity,
    username,
  ];
}
