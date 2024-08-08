import 'package:flutter/material.dart';
import 'package:kjm_app/screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KJM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        //'/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        //'/register': (context) => const RegisterScreen(),
        //'/activation': (context) => const ActivationScreen(),
        //'/forgot-password': (context) => const ForgotScreen(),
        //'/otp-activation': (context) => const OtpActivationScreen(),
        //'/otp-password': (context) => const OtpPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        //'/support': (context) => const SupportScreen(),
        //'/faq': (context) => const FaqScreen(),
        //'/profile': (context) => const ProfileScreen(),
        //'/settings': (context) => const SettingsScreen(),
        //'/piring': (context) => const PiringPage(),
        //'/kompos': (context) => const KomposPage(),
        //'/berdikari': (context) => BerdikariPage(),
        //'/edukasi': (context) => EdukasiPage(),
      },
    );
  }
}
