import 'package:flutter/material.dart';

class ColorConstants {
  ColorConstants._();

  // Basic & Utility Colors
  static const white = Colors.white;
  static const black = Colors.black;
  static const transparent = Colors.transparent;
  static const grey = Colors.grey;
  static const blue = Colors.blue;
  static const green = Colors.green;
  static const red = Colors.red;
  static const yellow = Colors.yellow;

  // Primary & Secondary Brand Colors
  static const primaryColor = Colors.blue;

  // Grey Shades
  static const greyShade50 = Color(0xFFFAFAFA);
  static const greyShade100 = Color(0xFFF5F5F5);
  static const greyShade200 = Color(0xFFEEEEEE);
  static const greyShade300 = Color(0xFFE0E0E0);
  static const greyShade400 = Color(0xFFBDBDBD);
  static const greyShade500 = Color(0xFF939393);
  static const greyShade600 = Color(0xFF757575);
  static const greyShade700 = Color(0xFF616161);
  static const greyShade800 = Color(0xFF424242);
  static const greyShade900 = Color(0xFF212121);

  // White Variations
  static const white24 = Colors.white24;

  // Red & Error Shades
  static const redAccent = Colors.redAccent;
  static const redShade50 = Color(0xFFFFEBEE);
  static const redShade100 = Color(0xFFFFCDD2);
  static const redShade400 = Color(0xFFEF5350);

  // Base 
  static const backgroundColor = Color(0xFFF2F2F2);
  static const textPrimaryColor = Colors.black;
  static const textSecondaryColor = Colors.grey;
  static const textHighlightColor = Colors.blue;
  static const iconColor = Colors.blue;

  // AppBar 
  static const appBarBackgroundColor = Colors.blue;
  static const appBarForegroundColor = Colors.white;

  // Bottom navigation 
  static const bottomNavBackgroundColor = Colors.white;
  static const bottomNavSelectedColor = Colors.blue;
  static const bottomNavUnselectedColor = Colors.grey;

  // SnackBar 
  static const snackBarBackgroundColor = Colors.blue;
  static const snackBarTextColor = Colors.white;
  static const snackBarActionColor = Colors.white;
  static const snackBarSuccessColor = Colors.green;
  static const snackBarFailedColor = Colors.red;

  // Dialog 
  static const dialogBackgroundColor = Colors.white;

  // Buttons & Actions 
  static const buttonColor = Colors.blue;
  static const buttonTextColor = Colors.white;
  static const deleteActionColor = Colors.red;
  static const socialBorderColor = Color(0xFFE0E0E0);

  // Error States 
  static const errorColor = Color(0xFFEF5350);

  // Difficulty Levels 
  static const difficultyBeginnerBgColor = Color(0xFFE8F5E9);
  static const difficultyBeginnerTextColor = Color(0xFF2E7D32);
  static const difficultyIntermediateBgColor = Color(0xFFFFF3E0);
  static const difficultyIntermediateTextColor = Color(0xFFEF6C00);
  static const difficultyAdvancedBgColor = Color(0xFFFFEBEE);
  static const difficultyAdvancedTextColor = Color(0xFFC62828);

  // Schedule Statuses 
  static const scheduleUpcomingColor = Color(0xFF5B8DEF);
  static const scheduleInProgressColor = Color(0xFFFF9B52);
  static const scheduleDoneColor = Color(0xFF4CD964);

  // Meal Types 
  static const mealBreakfastColor = Color(0xFF92A3FD);
  static const mealLunchColor = Color(0xFFC58BF2);
  static const mealDinnerColor = Color(0xFFFF9B70);

  // Muscle Groups
  static const muscleGroupChestColor = Color(0xFF5B8DEF);
  static const muscleGroupBackColor = Color(0xFF4CAF82);
  static const muscleGroupShouldersColor = Color(0xFFFF9B52);
  static const muscleGroupArmsColor = Color(0xFFC58BF2);
  static const muscleGroupLegsColor = Color(0xFFEF5350);
  static const muscleGroupCoreColor = Color(0xFFFFB74D);

  // Calories Badge 
  static const caloriesIconColor = Colors.orangeAccent;
  static const caloriesTextColor = Color(0xFFE65100);

  // Borders, Dividers & Skeletons 
  static const borderLightColor = Color(0xFFF5F5F5);
  static const skeletonColor = Colors.white38;
  static const dividerColor = Colors.grey;

  // Placeholders
  static const placeholderDarkColor = Colors.grey;
  static const recommendationPlaceholderColors = Colors.grey;

  // Gradients & Alignment
  static const bmiGradientColors = <Color>[
    Color(0xFF6FCFED),
    Color(0xFF4CAF82),
    Color(0xFFFF8C42),
    Colors.redAccent,
  ];

  // Heat map colors
  static const List<Color> heatMapColor = [
    Color(0xFFDDFFCF),
    Color(0xFF93F990),
    Color(0xFF21F34B),
    Color(0xFF006813),
  ];

  static const gradientBegin = Alignment.topLeft;
  static const gradientEnd = Alignment.bottomRight;

  static const bmiUnderweightColor = Color(0xFF6FCFED);
  static const bmiNormalColor = Color(0xFF4CAF82);
  static const bmiOverweightColor = Color(0xFFFF8C42);
  static const bmiObeseColor = Colors.redAccent;
}
