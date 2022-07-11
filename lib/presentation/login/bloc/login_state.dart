import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginStateIntial extends LoginState {


  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState {
  final String error;

  const LoginError(this.error);

  @override
  List<Object?> get props => [error];
}

class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess({required this.token});
  @override
  List<Object?> get props => [token];
}

class LoginPasswordSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginPasswordError extends LoginState {
  @override
  List<Object?> get props => [];
}
