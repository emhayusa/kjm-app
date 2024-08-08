import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/repositories/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }
  void _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    emit(RegisterInProgress());
    try {
      final result = await authRepository.register(
        username: event.username,
        password: event.password,
        email: event.email,
        phone: event.phone,
      );
      if (result['status'] == 'success') {
        emit(RegisterSuccess(phone: event.phone, message: result['message']));
      } else {
        emit(RegisterFailure(error: result['message']));
      }
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
