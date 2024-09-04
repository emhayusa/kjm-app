import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/widgets/custom_button.dart';
import 'package:kjm_security/widgets/custom_snackbar.dart';
import '../blocs/activation/activation_bloc.dart';
import '../blocs/activation/activation_event.dart';
import '../blocs/activation/activation_state.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  ActivationScreenState createState() => ActivationScreenState();
}

class ActivationScreenState extends State<ActivationScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust background color as needed
      body: BlocListener<ActivationBloc, ActivationState>(
        listener: (context, state) {
          if (state is ActivationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Error",
                content: state.error,
                color: Colors.red,
              ),
            );
          } else if (state is ActivationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Sukses",
                content: state.message,
                color: Colors.green,
              ),
            );
            Navigator.pushNamed(context, '/otp-activation',
                arguments: state.phone);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  'assets/images/LogoNgupahan.png', // Replace with your logo path
                  width: 230, // Adjust width as needed
                  height: 230, // Adjust height as needed
                ),
              ),
              const Center(
                child: Text(
                  "Kirim OTP Aktivasi Akun",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      title: TextField(
                        cursorColor: Colors.black87,
                        autocorrect: false,
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "No Whatsapp",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          // suffixIcon: isPhoneAvailable
                          //? Icon(
                          //    Icons.check,
                          //    size: 25,
                          //  )
                          //: null
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  onPressed: _onActivationButtonPressed,
                  text: "Kirim OTP",
                ),
              ),
              BlocBuilder<ActivationBloc, ActivationState>(
                builder: (context, state) {
                  if (state is ActivationInProgress) {
                    return const CircularProgressIndicator();
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      ),
    );
  }

  void _onActivationButtonPressed() {
    final phone = _phoneController.text;

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          title: 'Warning',
          content: 'Phone is required',
          color: Colors.black,
        ),
      );
      return;
    }

    BlocProvider.of<ActivationBloc>(context).add(
      ActivationButtonPressed(
        phone: phone,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
