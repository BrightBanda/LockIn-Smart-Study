import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(children: [Icon(icon), SizedBox(width: 2), Text(title)]),
        Column(children: [Text(detail)]),
      ],
    );
  }
}
