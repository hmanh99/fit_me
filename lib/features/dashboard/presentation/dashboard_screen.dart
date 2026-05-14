import 'dart:math';

import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = _authService.user?.displayName ?? "User";
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(username: username, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),));
              },),
              const SizedBox(height: 24),
              // Latest Workout header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Workout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9B8FD4),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Workout Cards
              WorkoutCard(
                title: 'Full body Workout',
                subtitle: '180 Calories Burn | 20minutes',
                progress: 0.55,
                avatarColor: const Color(0xFFEEE9FF),
                accentColor: const Color(0xFF9B8FD4),
              ),
              const SizedBox(height: 12),
              WorkoutCard(
                title: 'Lower body Workout',
                subtitle: '200 Calories Burn | 30minutes',
                progress: 0.40,
                avatarColor: const Color(0xFFFFE9F2),
                accentColor: const Color(0xFFE48DAB),
              ),
              const SizedBox(height: 12),
              WorkoutCard(
                title: 'Abs Workout',
                subtitle: '100 Calories Burn | 30minutes',
                progress: 0.20,
                avatarColor: const Color(0xFFFFA9F2),
                accentColor: const Color(0xFFEC3A36),
              ),
              const SizedBox(height: 24),
              const ActivityStatusSection(),
            ],
          ),
        ),
      ),
    );
  }
}

//  Header
Widget _buildHeader({required String username, required VoidCallback onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back,',
            style: TextStyle(
              fontSize: 13,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            username.trim(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: ColorConstants.primaryTextColor,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorConstants.backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: ColorConstants.icon,
            size: 20,
          ),
        ),
      ),
    ],
  );
}

//  Workout Card
class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color avatarColor;
  final Color accentColor;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.avatarColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text("")),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Chevron
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: accentColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

//  Activity Status Section
class ActivityStatusSection extends StatelessWidget {
  const ActivityStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: WaterIntakeCard(),),
            SizedBox(width: 12),
            Expanded(child: CaloriesCard()),
          ],
        ),
      ],
    );
  }
}

//  Water Intake Card
class WaterIntakeCard extends StatelessWidget {
  const WaterIntakeCard({super.key});

  static const _slots = [
    _WaterSlot('6am - 8am', '200ml', 0.20),
    _WaterSlot('9am - 11am', '300ml', 0.20),
    _WaterSlot('11am - 2pm', '3000ml', 0.40),
    _WaterSlot('2pm - 4pm', '500ml', 0.28),
    _WaterSlot('4pm - 10pm', '70ml', 0.36),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Intake',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '2 Liters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9B8FD4),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Real time updates',
            style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 10),
          ..._slots.map((slot) => _WaterSlotRow(slot: slot)),
        ],
      ),
    );
  }
}

class _WaterSlot {
  final String time;
  final String amount;
  final double ratio;

  const _WaterSlot(this.time, this.amount, this.ratio);
}

class _WaterSlotRow extends StatelessWidget {
  final _WaterSlot slot;

  const _WaterSlotRow({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + bar
          Column(
            children: [
              const SizedBox(height: 3),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFD0C8F5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 3,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF9B8FD4), Color(0xFFD0C8F5)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slot.time,
                style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 2),
              Text(
                slot.amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9B8FD4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  Sleep Card

//  Calories Card

class CaloriesCard extends StatelessWidget {
  const CaloriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '760 kCal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9B8FD4),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: CustomPaint(
                painter: _CaloriesRingPainter(progress: 0.70),
                child: const Center(
                  child: Text(
                    '230kCal\nleft',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9B8FD4),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaloriesRingPainter extends CustomPainter {
  final double progress;

  const _CaloriesRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 10.0;

    // Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFFF0EDFF)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF9B8FD4), Color(0xFFD0C8F5)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
