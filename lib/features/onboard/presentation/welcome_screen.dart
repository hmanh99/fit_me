import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/onboard_screen1.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(child: Stack(
        children: [
          //
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Fit',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'nesS',
                        style: TextStyle(
                          color: ColorConstants.headingTextColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Everybody Can Train',
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.buttonColor,
                  foregroundColor: ColorConstants.buttonTextColor,
                  minimumSize: const Size(360, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OnboardScreen1()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
