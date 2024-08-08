import 'package:equatable/equatable.dart';

abstract class ActivationState extends Equatable {
  const ActivationState();

  @override
  List<Object> get props => [];
}

class ActivationInitial extends ActivationState {}

class ActivationInProgress extends ActivationState {}

class ActivationSuccess extends ActivationState {
  final String phone;
  final String message;
  const ActivationSuccess({required this.phone, required this.message});
}

class ActivationFailure extends ActivationState {
  final String error;

  const ActivationFailure({required this.error});
}
