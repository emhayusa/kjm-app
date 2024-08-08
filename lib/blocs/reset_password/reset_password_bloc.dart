import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/repositories/auth_repository.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordBloc({required this.authRepository})
      : super(ResetPasswordInitial()) {
    on<ResetPasswordButtonPressed>(_onResetPasswordButtonPressed);
  }
  void _onResetPasswordButtonPressed(ResetPasswordButtonPressed event,
      Emitter<ResetPasswordState> emit) async {
    emit(ResetPasswordInProgress());
    try {
      final result = await authRepository.resetPassword(
          password: event.password, otp: event.otp, phone: event.phone);
      if (result['status'] == 'success') {
        emit(ResetPasswordSuccess(message: result['message']));
      } else {
        emit(ResetPasswordFailure(error: result['message']));
      }
    } catch (e) {
      emit(ResetPasswordFailure(error: e.toString()));
    }
  }
}
