import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/repositories/auth_repository.dart';
import 'otp_password_event.dart';
import 'otp_password_state.dart';

class OtpPasswordBloc extends Bloc<OtpPasswordEvent, OtpPasswordState> {
  final AuthRepository authRepository;

  OtpPasswordBloc({required this.authRepository})
      : super(OtpPasswordInitial()) {
    on<OtpPasswordButtonPressed>(_onOtpPasswordButtonPressed);
  }
  void _onOtpPasswordButtonPressed(
      OtpPasswordButtonPressed event, Emitter<OtpPasswordState> emit) async {
    emit(OtpPasswordInProgress());
    try {
      final result = await authRepository.otpPassword(
        phone: event.phone,
      );
      if (result['status'] == 'success') {
        emit(
            OtpPasswordSuccess(phone: event.phone, message: result['message']));
      } else {
        emit(OtpPasswordFailure(error: result['message']));
      }
    } catch (e) {
      emit(OtpPasswordFailure(error: e.toString()));
    }
  }
}
