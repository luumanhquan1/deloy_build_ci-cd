import 'package:equatable/equatable.dart';

abstract class RelationshipState extends Equatable {
  const RelationshipState();
}

class RelationshipStateStateIntial extends RelationshipState {


  @override
  List<Object?> get props => [];
}

class MainMessageStateError extends RelationshipState {
  final String error;

  const MainMessageStateError(this.error);

  @override
  List<Object?> get props => [error];
}


