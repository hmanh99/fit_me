import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onNotificationPressed;

  const DashboardHeader({super.key, this.onNotificationPressed});

  @override
  Widget build(BuildContext context) {
    final user = AuthServices();
    final username = user.user?.userMetadata?['username'] ?? "Fitness Partner";
    return SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $username",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "It's time to break your limit",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Notification
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, size: 24),
                  onPressed:
                      onNotificationPressed ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notifications — soon',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
