import 'package:flutter/material.dart';
import 'package:smart_study/src/utils/profile/overview_details_card.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              OverviewDetailsCard(
                icon: Icons.calendar_month_outlined,
                title: 'Member since',
                detail: 'January 2024',
              ),
              OverviewDetailsCard(
                icon: Icons.timer_outlined,
                title: 'Total Study Hours',
                detail: '234 hrs',
              ),
              OverviewDetailsCard(
                icon: Icons.calendar_month_outlined,
                title: 'Total schedules',
                detail: '89',
              ),
              OverviewDetailsCard(
                icon: Icons.book_outlined,
                title: 'Total Subjects',
                detail: '15',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
