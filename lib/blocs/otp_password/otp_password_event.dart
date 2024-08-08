import 'package:equatable/equatable.dart';

abstract class OtpPasswordEvent extends Equatable {
  const OtpPasswordEvent();

  @override
  List<Object> get props => [];
}

class OtpPasswordButtonPressed extends OtpPasswordEvent {
  final String phone;

  const OtpPasswordButtonPressed({required this.phone});

  @override
  List<Object> get props => [phone];
}
