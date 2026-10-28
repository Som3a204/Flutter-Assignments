import 'package:e_commerce/core/network/api_exceptions.dart';
import 'package:e_commerce/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commerce/features/auth/presentation/views/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState>{

  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginInitial());

  Future<void> login({
    required String username,
    required String password
}) async {
    if(state is LoginLoading) return;

    emit(const LoginLoading());

    try{
      final user = await _authRepository.login(
          username: username,
          password: password
      );
      if (isClosed) return;
      emit(LoginSuccess(user));
    }
    on ApiException catch (error) {
      if (isClosed) return;
      emit(LoginError(error.message));
    }
    catch(_){
      if (isClosed) return;
      emit(const LoginError("Something went wrong, Please try again"));
    }
  }
}