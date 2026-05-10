import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to your Fitness Tracker!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.workoutDetail,
                  pathParameters: const {'workoutId': 'demo-1'},
                  extra: 'extra-from-dashboard',
                );
              },
              child: const Text('Mở chi tiết workout (nested + extra)'),
            ),
          ],
        ),
      ),
    );
  }
}
