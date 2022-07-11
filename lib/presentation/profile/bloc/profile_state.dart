import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileStateInitial extends ProfileState {
  @override
  List<Object> get props => [];
}
