import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/app_router.dart';
import 'package:personal_fitness_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authBloc = AuthBloc(authRepository: AuthRepositoryImpl())
    ..add(const AuthSessionRestoreRequested());

  runApp(MyApp(authBloc: authBloc));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.authBloc, super.key});

  final AuthBloc authBloc;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = createAppRouter(widget.authBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (prev, next) =>
            prev is AuthUnknownState || next is AuthUnknownState,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Personal Fitness Tracker',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            builder: (context, child) {
              if (state is AuthUnknownState) {
                return const ColoredBox(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return child ?? const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
