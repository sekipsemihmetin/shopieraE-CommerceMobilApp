import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final response = await repository.fetchProducts();
      emit(ProductLoaded(products: response.products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
