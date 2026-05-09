import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutEvent());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to your Fitness Tracker!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
