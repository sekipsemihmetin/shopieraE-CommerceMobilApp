final class DeleteCart {
  final int cardId;
  final String username;

  const DeleteCart({required this.cardId, required this.username});

  Map<String, dynamic> toJson() => {
    'sepetId': cardId,
    'kullaniciAdi': username,
  };
}
