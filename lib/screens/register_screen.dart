import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/widgets/custom_snackbar.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/register/register_event.dart';
import '../blocs/register/register_state.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Error",
                content: state.error,
                color: Colors.red,
              ),
            );
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                title: "Sukses",
                content: state.message,
                color: Colors.green,
              ),
            );
            //Navigator.pop(context);
            Navigator.pushNamed(context, '/otp-activation',
                arguments: state.phone);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
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
                    "Buat Akun",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: TextField(
                          cursorColor: Colors.black87,
                          autocorrect: false,
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            //suffixIcon: isUsernameAvailable
                            //    ? Icon(Icons.check, size: 25)
                            //    : Icon(Icons.abc),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          cursorColor: Colors.black87,
                          autocorrect: false,
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            //suffixIcon: isEmailAvailable
                            //    ? Icon(
                            //        Icons.check,
                            //        size: 25,
                            //      )
                            //   : null
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          cursorColor: Colors.black87,
                          autocorrect: false,
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "No Whatsapp",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: 'Register',
                    onPressed: _onRegisterButtonPressed,
                  ),
                ),
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterInProgress) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegisterButtonPressed() {
    final username = _usernameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          title: 'Warning',
          content: 'All fields are required',
          color: Colors.black,
        ),
      );
      return;
    }

    BlocProvider.of<RegisterBloc>(context).add(
      RegisterButtonPressed(
        username: username,
        email: email,
        phone: phone,
        password: password,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
