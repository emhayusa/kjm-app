import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess({required this.message});
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});
}
