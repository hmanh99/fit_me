import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorConstants.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: ColorConstants.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.appBarBackgroundColor,
        foregroundColor: ColorConstants.appBarForegroundColor,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(
        color: ColorConstants.iconColor,
        size: 20,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        displayMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        displaySmall: TextStyle(color: ColorConstants.textPrimaryColor),
        headlineLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        headlineMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        headlineSmall: TextStyle(color: ColorConstants.textPrimaryColor),
        titleLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        titleMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        titleSmall: TextStyle(color: ColorConstants.textPrimaryColor),
        bodyLarge: TextStyle(
          color: ColorConstants.textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        bodySmall: TextStyle(color: ColorConstants.textPrimaryColor),
        labelLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        labelMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        labelSmall: TextStyle(color: ColorConstants.textPrimaryColor),
      ),
      cardTheme: const CardThemeData(color: ColorConstants.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.buttonColor,
          foregroundColor: ColorConstants.buttonTextColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.bottomNavBackgroundColor,
        selectedItemColor: ColorConstants.bottomNavSelectedColor,
        unselectedItemColor: ColorConstants.bottomNavUnselectedColor,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: ColorConstants.snackBarBackgroundColor,
        contentTextStyle: TextStyle(
          color: ColorConstants.snackBarTextColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        actionTextColor: ColorConstants.snackBarActionColor,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: ColorConstants.dialogBackgroundColor,
      ),
    );
  }
}


