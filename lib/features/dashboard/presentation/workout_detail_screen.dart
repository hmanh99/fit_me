import 'package:flutter/material.dart';

/// Màn nested dưới Home — nhận path param & optional `extra`.
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({
    required this.workoutId,
    this.extra,
    super.key,
  });

  final String workoutId;
  final Object? extra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout $workoutId')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'workoutId (path): $workoutId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'extra: ${extra ?? '—'}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
