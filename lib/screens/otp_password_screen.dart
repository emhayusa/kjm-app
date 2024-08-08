import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/blocs/reset_password/reset_password_bloc.dart';
import 'package:kjm_app/blocs/reset_password/reset_password_event.dart';
import 'package:kjm_app/blocs/reset_password/reset_password_state.dart';
import 'package:kjm_app/widgets/custom_button.dart';
import 'package:kjm_app/widgets/custom_snackbar.dart';

class OtpPasswordScreen extends StatefulWidget {
  const OtpPasswordScreen({super.key});

  @override
  State<OtpPasswordScreen> createState() => _OtpPasswordScreenState();
}

class _OtpPasswordScreenState extends State<OtpPasswordScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String phone = ModalRoute.of(context)!.settings.arguments as String;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Error",
                content: state.error,
                color: Colors.red,
              ),
            );
          } else if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Sukses",
                content: state.message,
                color: Colors.green,
              ),
            );
            //Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          }
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/images/Bg_People.png', // Replace with your logo path
              // Adjust height as needed
              width: screenWidth,
              height: screenHeight / 2,
              fit: BoxFit.fill,
            ),
            ListView(
              children: [
                SizedBox(
                  height: screenHeight / 2,
                ),
                Container(
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Reset Password Anda",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                                'Kode OTP dikirim ke nomor $phone, masa berlaku kode tersebut adalah 5 menit'),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: _controllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          FocusScope.of(context).nextFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          autocorrect: false,
                          obscureText: !_isPasswordVisible,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.grey),
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
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          onPressed: () => _onResetPasswordButtonPressed(phone),
                          text: "Reset",
                        ),
                      ),
                      BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                        builder: (context, state) {
                          if (state is ResetPasswordInProgress) {
                            return const CircularProgressIndicator();
                          }
                          return Container();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah jadi member?"),
                            const SizedBox(width: 5),
                            InkWell(
                              child: const Text(
                                "SignIn",
                                style: TextStyle(
                                  color: Color(0xFF84BD93),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                          ]),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum jadi member?"),
                          const SizedBox(width: 5),
                          InkWell(
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Color(0xFF84BD93),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: Center(
                child: Image.asset(
                  'assets/images/NgupahanPutih.png', // Replace with your logo path
                  width: 80, // Adjust width as needed
                  height: 80, // Adjust height as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResetPasswordButtonPressed(String phone) {
    final otp = _controllers.map((controller) => controller.text).join();
    String password = _passwordController.text;

    if (otp.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          title: 'Warning',
          content: 'OTP and password are required',
          color: Colors.black,
        ),
      );
      return;
    }

    BlocProvider.of<ResetPasswordBloc>(context).add(
      ResetPasswordButtonPressed(password: password, otp: otp, phone: phone),
    );
  }

  @override
  void dispose() {
    _controllers.map((controller) => controller.dispose());
    super.dispose();
  }
}
