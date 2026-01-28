import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;

  const AppColors({
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
  });

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

/* LIGHT COLORS */
const lightAppColors = AppColors(
  background: Color(0xFFF5F6FA),
  surface: Colors.white,
  card: Colors.white,
  textPrimary: Colors.black87,
  textSecondary: Colors.black54,
  accent: Color(0xFF6C63FF),
);

/* DARK COLORS */
const darkAppColors = AppColors(
  background: Color(0xFF121212),
  surface: Color(0xFF1E1E1E),
  card: Color(0xFF1E1E1E),
  textPrimary: Colors.white,
  textSecondary: Colors.white70,
  accent: Color(0xFF9A94FF),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,

  scaffoldBackgroundColor: lightAppColors.background,

  appBarTheme: AppBarTheme(
    backgroundColor: lightAppColors.surface,
    foregroundColor: lightAppColors.textPrimary,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),

  extensions: const [lightAppColors],
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,

  scaffoldBackgroundColor: darkAppColors.background,

  appBarTheme: AppBarTheme(
    backgroundColor: darkAppColors.surface,
    foregroundColor: darkAppColors.textPrimary,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),

  extensions: const [darkAppColors],
);
