import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông báo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationItem {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const NotificationItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Đã đến giờ ăn trưa rồi!',
      time: 'Khoảng 1 phút trước',
      icon: Icons.restaurant_outlined,
      iconColor: Color(0xFFD85A30),
      iconBg: Color(0xFFFFF0E6),
    ),
    NotificationItem(
      title: 'Đừng bỏ lỡ bài tập chân hôm nay',
      time: 'Khoảng 3 giờ trước',
      icon: Icons.directions_run_outlined,
      iconColor: Color(0xFF0F6E56),
      iconBg: Color(0xFFE1F5EE),
    ),
    NotificationItem(
      title: 'Hãy thêm bữa ăn cho ngày của bạn',
      time: 'Khoảng 3 giờ trước',
      icon: Icons.lunch_dining_outlined,
      iconColor: Color(0xFFD85A30),
      iconBg: Color(0xFFFFF0E6),
    ),
    NotificationItem(
      title: 'Chúc mừng, bạn đã hoàn thành bài tập!',
      time: '29 tháng 5',
      icon: Icons.emoji_events_outlined,
      iconColor: Color(0xFF185FA5),
      iconBg: Color(0xFFE6F1FB),
    ),
    NotificationItem(
      title: 'Đã đến giờ ăn trưa rồi!',
      time: '8 tháng 4',
      icon: Icons.access_time_outlined,
      iconColor: Color(0xFF888780),
      iconBg: Color(0xFFF1EFE8),
    ),
    NotificationItem(
      title: 'Bạn đã bỏ lỡ bài tập chân hôm qua',
      time: '3 tháng 4',
      icon: Icons.warning_amber_outlined,
      iconColor: Color(0xFF0F6E56),
      iconBg: Color(0xFFE1F5EE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xFFE5E5E5),
                ),
                itemBuilder: (context, index) {
                  return _buildNotificationItem(notifications[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.chevron_left,
            onTap: () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888780),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.more_vert,
              size: 16,
              color: Color(0xFF888780),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}