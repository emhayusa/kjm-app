import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
  }
  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final result = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      if (result['status'] == 'success') {
        emit(AuthSuccess(message: result['message']));
      } else {
        emit(AuthFailure(error: result['message']));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthInitial());
  }
  /*
  //@override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthStarted) {
      yield* _mapAuthStartedToState();
    } else if (event is AuthLoggedIn) {
      yield* _mapAuthLoggedInToState(event);
    } else if (event is AuthLoggedOut) {
      yield* _mapAuthLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAuthStartedToState() async* {
    // Add your authentication logic here
  }

  Stream<AuthState> _mapAuthLoggedInToState(AuthLoggedIn event) async* {
    yield AuthInProgress();
    try {
      final isSuccess =
          await authRepository.login(event.username, event.password);
      if (isSuccess) {
        yield AuthSuccess();
      } else {
        yield AuthFailure();
      }
    } catch (_) {
      yield AuthFailure();
    }
  }

  Stream<AuthState> _mapAuthLoggedOutToState() async* {
    await authRepository.logout();
    yield AuthInitial();
  }
  */
}
