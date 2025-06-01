import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/constants/base_constants.dart';
import '../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "${BaseInfo.imageUrl}/${product.image}";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported),
          ),
          title: Text(product.name),
          subtitle: Text("${product.brand} • ${product.category}"),
          trailing: Text("₺${product.price}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
