import 'package:equatable/equatable.dart';

abstract class OtpActivationState extends Equatable {
  const OtpActivationState();

  @override
  List<Object> get props => [];
}

class OtpActivationInitial extends OtpActivationState {}

class OtpActivationInProgress extends OtpActivationState {}

class OtpActivationSuccess extends OtpActivationState {
  final String message;

  const OtpActivationSuccess({required this.message});
}

class OtpActivationFailure extends OtpActivationState {
  final String error;

  const OtpActivationFailure({required this.error});
}
