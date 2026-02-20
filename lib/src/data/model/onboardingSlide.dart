import 'package:flutter/widgets.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData? icon; // optional now
  final String? imagePath; // new
  final Color? color;
  final Color backgroundColor;

  OnboardingSlide({
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
    this.color,
    required this.backgroundColor,
  });
}
