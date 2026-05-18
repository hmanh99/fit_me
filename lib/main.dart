import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/app_router.dart';
import 'package:personal_fitness_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/shared/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ;

  await Supabase.initialize(
    url: 'https://rrwpymefmyqnxeeithst.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJyd3B5bWVmbXlxbnhlZWl0aHN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkwMjk1NzIsImV4cCI6MjA5NDYwNTU3Mn0.H4rOaxxo-IEgj0jiL_VcUd_jNUqVUX_6w1Ql8nmq-IQ',
  );

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
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: widget.authBloc)],
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
              if (state is AuthUnknownState) return const SplashScreen();
              return child ?? const SplashScreen();
            },
          );
        },
      ),
    );
  }
}
