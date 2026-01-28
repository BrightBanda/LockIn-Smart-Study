import 'package:flutter/material.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';

class OverviewDetailsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  const OverviewDetailsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Card(
      elevation: 1,
      color: appColors.card,
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: appColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: appColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(detail, style: TextStyle(color: appColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
