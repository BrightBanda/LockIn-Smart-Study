import 'package:flutter/material.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;

  const StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Card(
      color: appColors.card,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer, size: 20, color: appColors.accent),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: appColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 33),
            Text(
              value,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: appColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
