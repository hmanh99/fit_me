import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_paths.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_event.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  final String returnTo;

  const SignUpScreen({super.key, this.returnTo = "app/home"});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(context.locale);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpState) {
          context.go(AppRoutePaths.appHome);

          _username.clear();
          _email.clear();
          _password.clear();
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text(state.message),
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
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'hey_there'.tr(),
                    style: const TextStyle(fontSize: 16, color: ColorConstants.textSecondaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'create_an_account'.tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'username_required'.tr();
                            }
                            return null;
                          },
                          controller: _username,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText: 'username_hint'.tr(),
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 20),
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

                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password_required'.tr();
                            }
                            if (value.length < 8) {
                              return 'password_min_length'.tr();
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'password_uppercase'.tr();
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'password_lowercase'.tr();
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'password_number'.tr();
                            }
                            if (!RegExp(
                              r'[!@#\/$%^&*(),.?":{}|<>]',
                            ).hasMatch(value)) {
                              return 'password_special_char'.tr();
                            }
                            return null;
                          },
                          controller: _password,
                          enabled: !isLoading,
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
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 16),
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
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ColorConstants.textSecondaryColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'terms_prefix'.tr(),
                                    ),
                                    TextSpan(
                                      text: 'terms_privacy_policy'.tr(),
                                      style: const TextStyle(color: ColorConstants.textHighlightColor),
                                    ),
                                    TextSpan(text: 'terms_and'.tr()),
                                    TextSpan(
                                      text: 'terms_of_use'.tr(),
                                      style: const TextStyle(color: ColorConstants.textHighlightColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

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
                                  SnackBar(
                                    content: Text(
                                      'terms_not_accepted'.tr(),
                                    ),
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
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: ColorConstants.buttonColor,
                            ),
                          )
                              : Text('sign_up_button'.tr()),
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
                        : () => context.go(AppRoutePaths.login),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: ColorConstants.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: 'have_account_prompt'.tr()),
                          TextSpan(
                            text: 'login_button'.tr(),
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