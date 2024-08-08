import 'package:equatable/equatable.dart';

abstract class ActivationEvent extends Equatable {
  const ActivationEvent();

  @override
  List<Object> get props => [];
}

class ActivationButtonPressed extends ActivationEvent {
  final String phone;

  const ActivationButtonPressed({required this.phone});

  @override
  List<Object> get props => [phone];
}
