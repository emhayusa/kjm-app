import 'package:flutter/material.dart';
import 'package:kjm_security/screens/login_screen.dart';
import 'home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
//import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Capture AuthBloc and its state before the async operation
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final authState = authBloc.state;

    await Future.delayed(const Duration(seconds: 4));

    // Use a callback to access context after async operation
    if (mounted) {
      _navigateBasedOnAuthState(authState);
    }
  }

  void _navigateBasedOnAuthState(AuthState authState) {
    if (authState is AuthSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.7,
          height: screenWidth * 0.7,
          child: Image.asset("assets/images/logo_kjm_small.png"),
        ),
      ),
    );
  }
}
