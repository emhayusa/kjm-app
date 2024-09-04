import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/repositories/auth_repository.dart';
import 'activation_event.dart';
import 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final AuthRepository authRepository;

  ActivationBloc({required this.authRepository}) : super(ActivationInitial()) {
    on<ActivationButtonPressed>(_onActivationButtonPressed);
  }
  void _onActivationButtonPressed(
      ActivationButtonPressed event, Emitter<ActivationState> emit) async {
    emit(ActivationInProgress());
    try {
      final result = await authRepository.activate(
        phone: event.phone,
      );
      if (result['status'] == 'success') {
        emit(ActivationSuccess(phone: event.phone, message: result['message']));
      } else {
        emit(ActivationFailure(error: result['message']));
      }
    } catch (e) {
      emit(ActivationFailure(error: e.toString()));
    }
  }
}
