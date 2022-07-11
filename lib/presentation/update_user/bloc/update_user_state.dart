
import 'package:equatable/equatable.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();
}

class UpdateUserStateInitial extends UpdateUserState {
  @override
  List<Object> get props => [];
}