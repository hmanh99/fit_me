import 'package:flutter/material.dart';

class WorkoutItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;

  const WorkoutItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isActive = false,
  });
}

class WorkoutCategory {
  final String title;
  final String exercises;
  final String duration;
  final Color avatarBg;

  const WorkoutCategory({
    required this.title,
    required this.exercises,
    required this.duration,
    required this.avatarBg,
  });
}

// ─── Main Screen ───────────────────────────────────────────────────────────────

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<double> _chartData = [0.3, 0.55, 0.4, 0.7, 0.5, 0.85, 0.6];
  final int _selectedDay = 5; // Friday

  final List<WorkoutCategory> _categories = const [
    WorkoutCategory(
      title: 'Fullbody Workout',
      exercises: '11 Exercises',
      duration: '32mins',
      avatarBg: Color(0xFFE8F4FD),
    ),
    WorkoutCategory(
      title: 'Lowebody Workout',
      exercises: '12 Exercises',
      duration: '40mins',
      avatarBg: Color(0xFFFDE8F0),
    ),
    WorkoutCategory(
      title: 'AB Workout',
      exercises: '14 Exercises',
      duration: '20mins',
      avatarBg: Color(0xFFE8FDF0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Workout Tracker',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          _buildScheduleCard(),
          const SizedBox(height: 24),
          _buildTodaySection(),
          const SizedBox(height: 24),
          _buildTrainSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B8EFF).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Daily Workout Schedule',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B8EFF), Color(0xFF9B6BFF)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Check',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Today Workout',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildWorkoutTile(
          icon: Icons.sports_gymnastics_rounded,
          title: 'Fullbody Workout',
          subtitle: 'Today, 03:00pm',
          iconBg: const Color.fromRGBO(146, 163, 253, 0.2),
          iconColor: const Color(0xFF92A3FD),
        ),
        const SizedBox(height: 15),
        _buildWorkoutTile(
          icon: Icons.fitness_center_rounded,
          title: 'Upperbody Workout',
          subtitle: 'June 05, 02:00pm',
          iconBg: const Color.fromRGBO(197, 139, 242, 0.2),
          iconColor: const Color(0xFFC58BF2),
        ),
      ],
    );
  }

  Widget _buildWorkoutTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    const titleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1D1617),
      height: 1.2,
    );
    const subtitleStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF7B6F72),
      height: 1.2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: subtitleStyle),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFFADA4A5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More Workout',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 14),
        ..._categories.asMap().entries.map((entry) {
          final i = entry.key;
          final cat = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCategoryCard(cat, i),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryCard(WorkoutCategory cat, int index) {
    final List<Color> gradients = [
      const Color(0xFFEEF2FF),
      const Color(0xFFFFF0F5),
      const Color(0xFFF0FFF4),
    ];

    final List<IconData> icons = [
      Icons.directions_run,
      Icons.sports_gymnastics,
      Icons.self_improvement,
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: gradients[index % gradients.length],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cat.exercises} | ${cat.duration}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 14),
                _viewMoreButton(),
              ],
            ),
          ),
          _buildWorkoutIllustration(icons[index % icons.length], index),
        ],
      ),
    );
  }

  Widget _viewMoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'View more',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B8EFF),
        ),
      ),
    );
  }

  Widget _buildWorkoutIllustration(IconData icon, int index) {
    final List<Color> colors = [
      const Color(0xFF6B8EFF),
      const Color(0xFFFF6BAE),
      const Color(0xFF6BFFB8),
    ];
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: colors[index % colors.length].withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 48,
        color: colors[index % colors.length],
      ),
    );
  }
}

// ─── Chart Painter ─────────────────────────────────────────────────────────────

class ChartPainter extends CustomPainter {
  final List<double> data;
  final int selectedIndex;

  const ChartPainter({required this.data, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final n = data.length;

    // Dot positions
    final pts = List.generate(n, (i) {
      final x = (i / (n - 1)) * (w - 80) + 20;
      final y = h - data[i] * (h * 0.75) - h * 0.05;
      return Offset(x, y);
    });

    // Filled gradient area
    final fillPath = Path();
    fillPath.moveTo(pts[0].dx, h);
    fillPath.lineTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    fillPath.lineTo(pts.last.dx, h);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Curve line
    final linePath = Path();
    linePath.moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Vertical line for selected day
    final selPt = pts[selectedIndex];
    canvas.drawLine(
      Offset(selPt.dx, 0),
      Offset(selPt.dx, h),
      Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // Dots
    for (int i = 0; i < pts.length; i++) {
      final isSelected = i == selectedIndex;
      canvas.drawCircle(
        pts[i],
        isSelected ? 7 : 4,
        Paint()..color = Colors.white.withOpacity(isSelected ? 1.0 : 0.6),
      );
      if (isSelected) {
        canvas.drawCircle(
          pts[i],
          4,
          Paint()..color = const Color(0xFF6B8EFF),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter old) =>
      old.data != data || old.selectedIndex != selectedIndex;
}