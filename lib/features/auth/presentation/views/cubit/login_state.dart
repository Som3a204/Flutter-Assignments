import 'package:e_commerce/features/auth/data/models/user_model.dart';

sealed class LoginState {
  const LoginState();
}

 class LoginInitial extends LoginState{
 const LoginInitial();
}

 class LoginLoading extends LoginState{
 const LoginLoading();
}

 class LoginSuccess extends LoginState{
 final UserModel user;

 const LoginSuccess(this.user);
}

 class LoginError extends LoginState{
  final String message;

const LoginError(this.message);
}