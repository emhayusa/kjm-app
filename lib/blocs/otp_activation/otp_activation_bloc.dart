import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/repositories/auth_repository.dart';
import 'otp_activation_event.dart';
import 'otp_activation_state.dart';

class OtpActivationBloc extends Bloc<OtpActivationEvent, OtpActivationState> {
  final AuthRepository authRepository;

  OtpActivationBloc({required this.authRepository})
      : super(OtpActivationInitial()) {
    on<OtpActivationButtonPressed>(_onOtpActivationButtonPressed);
  }
  void _onOtpActivationButtonPressed(OtpActivationButtonPressed event,
      Emitter<OtpActivationState> emit) async {
    emit(OtpActivationInProgress());
    try {
      final result = await authRepository.otpActivate(
        phone: event.phone,
        otp: event.otp,
      );
      if (result['status'] == 'success') {
        emit(OtpActivationSuccess(message: result['message']));
      } else {
        emit(OtpActivationFailure(error: result['message']));
      }
    } catch (e) {
      emit(OtpActivationFailure(error: e.toString()));
    }
  }
}
