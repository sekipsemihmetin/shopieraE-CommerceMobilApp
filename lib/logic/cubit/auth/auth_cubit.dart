import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial()) {
    _repository.userStream.listen((user) {
      emit(user != null ? Authenticated(user) : Unauthenticated());
    });
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await _repository.login(email, password);
      emit(user != null ? Authenticated(user) : AuthError("Login failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await _repository.register(email, password);
      emit(user != null ? Authenticated(user) : AuthError("Register failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(Unauthenticated());
  }
}
