final class CardResponse {
  final int success;
  final String message;

  const CardResponse({required this.success, required this.message});

  factory CardResponse.fromJson(Map<String, dynamic> json) => CardResponse(
    success: json['success'] as int,
    message: json['message'] as String,
  );

  @override
  List<Object> get props => [success, message];
}
