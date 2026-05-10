import 'package:flutter/material.dart';

/// Tab Profile — demo query param `?tab=settings|account`.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    this.initialTab,
    super.key,
  });

  final String? initialTab;

  @override
  Widget build(BuildContext context) {
    final tab = initialTab ?? 'overview';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tab query: ${tab.isEmpty ? '(default)' : tab}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thử deep link: /app/profile?tab=settings',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
