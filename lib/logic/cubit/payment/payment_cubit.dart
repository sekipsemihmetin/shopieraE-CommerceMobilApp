import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_state.dart';
import '../../../data/repository/payment_repository.dart';
import '../../../data/models/payment_request.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  PaymentCubit(this._repository) : super(PaymentInitial());

  Future<void> startPayment(PaymentRequest request) async {
    emit(PaymentLoading());
    try {
      final result = await _repository.sendToBackendForPayment(request);
      if (result.success) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentError("Ödeme başarısız: ${result.message}"));
      }
    } catch (e) {
      emit(PaymentError("Bir hata oluştu: ${e.toString()}"));
    }
  }
}
