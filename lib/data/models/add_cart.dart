final class AddCart {
  final String name;
  final String image;
  final String category;
  final int price;
  final String brand;
  final int quantity;
  final String username;

  const AddCart({
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.brand,
    required this.quantity,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    'ad': name,
    'resim': image,
    'kategori': category,
    'fiyat': price,
    'marka': brand,
    'siparisAdeti': quantity,
    'kullaniciAdi': username,
  };
}
