class PaymentRequest {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvv;
  final int amount;

  const PaymentRequest({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvv,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'card_holder': cardHolderName,
      'cvv': cvv,
      'amount': amount,
    };
  }
}
