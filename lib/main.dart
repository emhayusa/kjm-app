import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/app.dart';
import 'package:kjm_security/blocs/activation/activation_bloc.dart';
import 'package:kjm_security/blocs/otp_activation/otp_activation_bloc.dart';
import 'package:kjm_security/blocs/otp_password/otp_password_bloc.dart';
import 'package:kjm_security/blocs/profile/profile_bloc.dart';
import 'package:kjm_security/blocs/register/register_bloc.dart';
import 'package:kjm_security/blocs/reset_password/reset_password_bloc.dart';
import 'package:kjm_security/repositories/profile_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<ActivationBloc>(
          create: (context) => ActivationBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<OtpActivationBloc>(
          create: (context) =>
              OtpActivationBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) =>
              ResetPasswordBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<OtpPasswordBloc>(
          create: (context) =>
              OtpPasswordBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(profileRepository: ProfileRepository()),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
