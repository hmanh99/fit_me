import 'package:flutter/material.dart';

/// Tab Workouts — placeholder có thể mở rộng theo feature module.
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: const Center(
        child: Text(
          'Danh sách buổi tập',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
