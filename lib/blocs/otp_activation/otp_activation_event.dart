import 'package:equatable/equatable.dart';

abstract class OtpActivationEvent extends Equatable {
  const OtpActivationEvent();

  @override
  List<Object> get props => [];
}

class OtpActivationButtonPressed extends OtpActivationEvent {
  final String phone;
  final String otp;

  const OtpActivationButtonPressed({required this.phone, required this.otp});

  @override
  List<Object> get props => [phone, otp];
}
