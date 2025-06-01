import '../models/payment_result.dart';
import '../models/payment_request.dart';
import 'package:dio/dio.dart';

class PaymentRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl:  "http://10.0.2.2:7065",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  ));

  Future<PaymentResult> sendToBackendForPayment(PaymentRequest request) async {
    try {
      final response = await _dio.post(
        "/api/payment/post",
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return PaymentResult.fromJson(response.data);
      } else {
        return PaymentResult(success: false, message: "Sunucu hatası");
      }
    } catch (e) {
      print("Hata Ne hatası :" + e.toString());

      return PaymentResult(success: false, message: "İstek başarısız: $e");
    }
  }
}
