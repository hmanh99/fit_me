import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  String? returnTo;

  SignUpScreen({super.key, this.returnTo});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpState) {
          final target = widget.returnTo;
          if (target != null && target.isNotEmpty) {
            context.go(target);
          } else {
            context.go(AppRoutePaths.appHome);
          }
          _username.clear();
          _email.clear();
          _password.clear();
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text(state.message),
              backgroundColor: ColorConstants.snackBarColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return Scaffold(
          backgroundColor: ColorConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Hey there,',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Create an Account',
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
                              return "You must enter your username";
                            }
                            return null;
                          },
                          controller: _username,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 24),
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
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email),
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
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock),
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

                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptedTerms,
                              onChanged: isLoading
                                  ? null
                                  : (val) => setState(
                                      () => _acceptedTerms = val ?? false,
                                    ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              activeColor: ColorConstants.buttonColor,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColorConstants.secondaryTextColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'By continuing you accept our ',
                                    ),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: ColorConstants.highlightText,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Term of Use',
                                      style: TextStyle(
                                        color: ColorConstants.highlightText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: ColorConstants.buttonColor,
                            foregroundColor: ColorConstants.buttonTextColor,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!_acceptedTerms) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please accept the Privacy Policy and Terms of Use',
                                            style: TextStyle(
                                              color: ColorConstants
                                                  .primaryTextColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              ColorConstants.snackBarColor,
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<AuthBloc>().add(
                                      AuthSignUpEvent(
                                        username: _username.text.trim(),
                                        email: _email.text.trim(),
                                        password: _password.text,
                                      ),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: ColorConstants.buttonTextColor,
                                  ),
                                )
                              : const Text("Sign up"),
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
                          style: TextStyle(
                            color: ColorConstants.secondaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _buildSocialButton(
                    assetPath: "assets/images/auth/google.png",
                  ),

                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => context.go(AppRoutePaths.signIn),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorConstants.primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: ColorConstants.highlightText,
                            ),
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
      },
    );
  }

  Widget _buildSocialButton({required String assetPath}) {
    return GestureDetector(
      onTap: () {},
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
