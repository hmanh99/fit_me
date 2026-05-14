import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
