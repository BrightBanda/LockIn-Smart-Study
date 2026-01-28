import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color card;
  final Color cardBorder;
  final Color shadow;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;

  const AppColors({
    required this.card,
    required this.cardBorder,
    required this.shadow,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
  });

  @override
  AppColors copyWith({
    Color? card,
    Color? cardBorder,
    Color? shadow,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
  }) {
    return AppColors(
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      shadow: shadow ?? this.shadow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

final lightTheme = ThemeData(
  useMaterial3: true,
  extensions: [
    AppColors(
      card: Colors.white,
      cardBorder: Colors.grey.shade200,
      shadow: Colors.black26,
      textPrimary: Colors.black87,
      textSecondary: Colors.black54,
      accent: const Color(0xFF6C63FF),
    ),
  ],
);

final darkTheme = ThemeData(
  useMaterial3: true,
  extensions: [
    AppColors(
      card: const Color(0xFF1E1E1E),
      cardBorder: Colors.grey.shade800,
      shadow: Colors.black,
      textPrimary: Colors.white,
      textSecondary: Colors.white70,
      accent: const Color(0xFF9A94FF),
    ),
  ],
);
