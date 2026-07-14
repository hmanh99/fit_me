import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialEmail;
    if (initial != null && initial.isNotEmpty) {
      _email.text = initial;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _onSendPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthForgotPasswordEvent(email: _email.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccessState) {
          _email.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Password reset email sent! Please check your inbox.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Future<void>.delayed(const Duration(seconds: 10), () {
            if (!context.mounted) return;
            context.go(AppRoutePaths.signIn);
          });
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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
          appBar: AppBar(
            backgroundColor: ColorConstants.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.primaryTextColor,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutePaths.signIn);
                      }
                    },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: ColorConstants.labelColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      size: 40,
                      color: ColorConstants.icon,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    r"Don't worry! Enter your email and"
                    "\n we'll send you a reset link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorConstants.secondaryTextColor,
                      height: 1.5,
                    ),
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

                        const SizedBox(height: 32),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: ColorConstants.buttonColor,
                            foregroundColor: ColorConstants.buttonTextColor,
                          ),
                          onPressed: isLoading ? null : _onSendPressed,
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: ColorConstants.buttonTextColor,
                                  ),
                                )
                              : const Text("Send Reset Link"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
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
                          TextSpan(text: "Remember your password? "),
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
}
