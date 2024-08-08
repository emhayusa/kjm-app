import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordButtonPressed extends ResetPasswordEvent {
  final String password;
  final String otp;
  final String phone;

  const ResetPasswordButtonPressed(
      {required this.password, required this.otp, required this.phone});

  @override
  List<Object> get props => [password, otp];
}
