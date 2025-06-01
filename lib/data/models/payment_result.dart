class PaymentResult {
  final bool success;
  final String message;

  const PaymentResult({
    required this.success,
    required this.message,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      success: json['success'] == true || json['success'] == 1,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
