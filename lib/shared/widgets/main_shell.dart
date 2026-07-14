import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell cho [StatefulShellRoute] — mỗi tab có navigator stack riêng.
class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_rounded),
            selectedIcon: Icon(Icons.restaurant_rounded),
            label: 'Meal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: navigationShell.goBranch,
      ),
    );
  }
}
