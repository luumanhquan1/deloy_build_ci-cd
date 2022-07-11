import 'package:ccvc_mobile/domain/model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PersonalState extends Equatable {
  const PersonalState();
}

class PersonalStateInitial extends PersonalState {
  @override
  List<Object> get props => [];
}
