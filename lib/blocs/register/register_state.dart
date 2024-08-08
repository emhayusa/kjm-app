import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterInProgress extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String phone;
  final String message;

  const RegisterSuccess({required this.phone, required this.message});
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({required this.error});
}
