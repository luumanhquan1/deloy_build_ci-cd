import 'package:equatable/equatable.dart';

abstract class MainMessageState extends Equatable {
  const MainMessageState();
}

class MainMessageStateIntial extends MainMessageState {


  @override
  List<Object?> get props => [];
}

class MainMessageStateError extends MainMessageState {
  final String error;

  const MainMessageStateError(this.error);

  @override
  List<Object?> get props => [error];
}

class MainMessageSuccess extends MainMessageState {
  final String token;
  MainMessageSuccess({required this.token});
  @override
  List<Object?> get props => [token];
}

class LoginPasswordSuccess extends MainMessageState {
  @override
  List<Object?> get props => [];
}

class LoginPasswordError extends MainMessageState {
  @override
  List<Object?> get props => [];
}
