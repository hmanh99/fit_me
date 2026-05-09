import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signup_screen.dart';

class OnboardScreen2 extends StatefulWidget {
  const OnboardScreen2({super.key});

  @override
  State<OnboardScreen2> createState() => _OnboardScreen2State();
}

class _OnboardScreen2State extends State<OnboardScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 180,
                  backgroundImage: AssetImage('assets/images/onboard/meal.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Eat Well',
                    style: TextStyle(
                      color: ColorConstants.primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Let's start a healthy lifestyle with us,"
                    " we can determine your diet every day. healthy eating is fun",
                    style: TextStyle(
                      color: ColorConstants.secondaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.buttonColor,
          foregroundColor: ColorConstants.buttonTextColor,
          minimumSize: Size(60, 60),
          shape: CircleBorder(),
      ),
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          context.read<AuthBloc>().add(const AuthSignUpNeededEvent());
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
