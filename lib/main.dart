import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/forgot_password_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signin_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signup_screen.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/welcome_screen.dart';
import 'package:personal_fitness_tracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: AuthRepositoryImpl()),
      child: MaterialApp(
        title: 'Personal Fitness Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AuthInitialState) {
          return const WelcomeScreen();
        } else if (state is AuthSignInState || state is AuthSignUpState) {
          return const DashboardScreen();
        } else if (state is AuthSignInNeededState) {
          return const SignInScreen();
        } else if (state is AuthSignUpNeededState) {
          return const SignUpScreen();
        } else if (state is AuthSignOutState) {
          return const SignInScreen();
        } else if (state is AuthErrorState) {
          return const SignInScreen();
        } else if (state is AuthForgotPasswordNeededState) {
          return const ForgotPasswordScreen();
        } else if (state is AuthForgotPasswordSuccessState) {
          return const SignInScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}