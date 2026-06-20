import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: ShimmerLoading(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            children: [
              AppSkeleton.circle(size: 40),
              SizedBox(height: 12,),
              const AppSkeleton.line(),
              SizedBox(height: 12,),
              Container(decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12)
              ) ,child: SkeletonListTile(),),
              SizedBox(height: 12,),
              SkeletonListTile()
            ],
          ),
        ),
      ),
    );
  }
}
