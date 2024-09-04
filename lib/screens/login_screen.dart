import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kjm_security/widgets/custom_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  String _appVersion = '';
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
    _fetchAppVersion();
    _checkForUpdate();
  }

  Future<void> _fetchAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      _showSnackBar("Error fetching app version: $e");
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = updateInfo;
      });

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        _showUpdateModal();
      }
    } catch (e) {
      _showSnackBar("Error checking for update: $e");
    }
  }

  void _showUpdateModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'A new version of the app is available. Please update to the latest version.',
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Update',
                onPressed: () async {
                  Navigator.pop(context);
                  if (_updateInfo?.updateAvailability ==
                      UpdateAvailability.updateAvailable) {
                    try {
                      await InAppUpdate.performImmediateUpdate();
                    } catch (e) {
                      _showSnackBar("Error performing update: $e");
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _usernameController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', _rememberMe);
    if (_rememberMe) {
      prefs.setString('username', _usernameController.text);
      prefs.setString('password', _passwordController.text);
    } else {
      prefs.remove('username');
      prefs.remove('password');
    }
  }

  void _toggleRememberMe() {
    setState(() {
      _rememberMe = !_rememberMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Error",
                content: state.error,
                color: Colors.red,
              ),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Sukses",
                content: state.message,
                color: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (Route<dynamic> route) => false,
            );
          }
        },
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: 150,
                ),
                Container(
                  height: 140,
                  child: Image.asset(
                    "assets/images/logo_kjm_small.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            ListTile(
                              title: TextField(
                                cursorColor: Colors.black87,
                                autocorrect: false,
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                autocorrect: false,
                                obscureText: !_isPasswordVisible,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleRememberMe,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value!;
                                          });
                                        },
                                      ),
                                      const Text('Remember Me'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            /*InkWell(
                              child: const Text(
                                "Lupa Kata Sandi?",
                                style: TextStyle(
                                  color: Color(0xFF84BD93),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/forgot-password');
                              },
                            ),*/
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          onPressed: _onLoginButtonPressed,
                          text: "Masuk",
                        ),
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthInProgress) {
                            return const CircularProgressIndicator();
                          }
                          return Container();
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Version: $_appVersion',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      /*
                      InkWell(
                        child: const Text(
                          "Belum Aktivasi Akun?",
                          style: TextStyle(
                            color: Color(0xFF84BD93),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/activation');
                        },
                      ),
                      */
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onLoginButtonPressed() {
    String username = _usernameController.text.replaceAll(' ', '');
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          title: 'Warning',
          content: 'All fields are required',
          color: Colors.black,
        ),
      );
      return;
    } else {
      _saveRememberMe();
      context.read<AuthBloc>().add(
            AuthLoggedIn(
              username: username,
              password: password,
            ),
          );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
