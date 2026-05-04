import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/signup/presentation/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Hey there,',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must enter your email";
                        }

                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'At least 8 characters';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "At least one uppercase letter";
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'At least one lowercase letter';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'At least one number';
                        }
                        if (!RegExp(
                          r'[!@#\/$%^&*(),.?":{}|<>]',
                        ).hasMatch(value)) {
                          return 'At least one special character';
                        }
                        return null;
                      },
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        //navigate to forgot password screen
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          height: 1.50,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: ColorConstants.buttonColor,
                        foregroundColor: ColorConstants.buttonTextColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //navigate to dashboard

                          _email.clear();
                          _password.clear();
                        }
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Or',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 12),
              _buildSocialButton(assetPath: "assets/images/auth/google.png"),

              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorConstants.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: "Don't have an account yet? "),
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(color: ColorConstants.highlightText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required String assetPath}) {
    return GestureDetector(
      onTap: () async {
        //handle social sign in
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: ColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}
