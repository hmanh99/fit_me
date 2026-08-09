import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.returnTo = 'app/home'});

  /// Deep link / redirect after sign in(query `from` from auth guard).
  final String returnTo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginEvent(email: _email.text.trim(), password: _password.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginState) {
          context.go(AppRoutePaths.appHome);
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorConstants.snackBarFailedColor,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'hey_there'.tr(),
                    style: const TextStyle(fontSize: 16, color: ColorConstants.textSecondaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'welcome_back'.tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email_required'.tr();
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return 'email_invalid'.tr();
                            }
                            return null;
                          },
                          controller: _email,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: 'email_hint'.tr(),
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password_required'.tr();
                            }
                            return null;
                          },
                          controller: _password,
                          enabled: !isLoading,
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'password_hint'.tr(),
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
                        ),

                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => context.pushNamed(
                            AppRouteNames.forgotPassword,
                            queryParameters: {
                              if (_email.text.trim().isNotEmpty)
                                'email': _email.text.trim(),
                            },
                          ),
                          child: Text(
                            'forgot_password_link'.tr(),
                            style: const TextStyle(
                              color: ColorConstants.textSecondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 1.50,
                            ),
                          ),
                        ),

                        const SizedBox(height: 140),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: ColorConstants.buttonColor,
                            foregroundColor: ColorConstants.buttonTextColor,
                          ),
                          onPressed: isLoading ? null : _onLoginPressed,
                          child: isLoading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: ColorConstants.buttonTextColor,
                            ),
                          )
                              : Text('login_button'.tr()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'or_divider'.tr(),
                          style: const TextStyle(color: ColorConstants.textSecondaryColor, fontSize: 13),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => context.go(AppRoutePaths.signUp),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: ColorConstants.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: 'no_account_prompt'.tr()),
                          TextSpan(
                            text: 'sign_up_button'.tr(),
                            style: const TextStyle(color: ColorConstants.textHighlightColor),
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