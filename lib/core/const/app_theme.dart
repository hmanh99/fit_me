import 'package:flutter/material.dart';

/// Centralized Material 3 theme for the app.
/// Provides both light and dark variants using a single seed colour.
abstract final class AppTheme {
  AppTheme._();

  // ─── Seed ───────────────────────────────────────────────
  static const Color _seed = Color(0xFF7F77DD);

  // ─── Light Theme ────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme);
  }

  // ─── Dark Theme ─────────────────────────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme);
  }

  // ─── Shared builder ─────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final textTheme = ThemeData(brightness: colorScheme.brightness)
        .textTheme
        .apply(fontFamily: 'Poppins');

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: colorScheme.surface,

      // ─── AppBar ──────────────────────────────────────
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // ─── Cards ───────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: colorScheme.surfaceContainerLow,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // ─── NavigationBar ───────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),

      // ─── Chips ───────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium,
      ),

      // ─── Divider ─────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 0.5,
        space: 0,
      ),

      // ─── Input ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
