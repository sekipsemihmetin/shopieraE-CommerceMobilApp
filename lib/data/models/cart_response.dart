final class CartResponse {
  final int success;
  final String message;

  const CartResponse({required this.success, required this.message});

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    success: int.parse(json['success'].toString()),
    message: json['message'],
  );
}
