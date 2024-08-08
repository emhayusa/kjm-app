import 'package:equatable/equatable.dart';

abstract class OtpPasswordState extends Equatable {
  const OtpPasswordState();

  @override
  List<Object> get props => [];
}

class OtpPasswordInitial extends OtpPasswordState {}

class OtpPasswordInProgress extends OtpPasswordState {}

class OtpPasswordSuccess extends OtpPasswordState {
  final String phone;
  final String message;

  const OtpPasswordSuccess({required this.phone, required this.message});
}

class OtpPasswordFailure extends OtpPasswordState {
  final String error;

  const OtpPasswordFailure({required this.error});
}
