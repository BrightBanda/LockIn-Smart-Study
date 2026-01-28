import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/viewmodel/statsViewmodel.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';
import 'package:smart_study/src/utils/profile/overview_details_card.dart';

class ProfileOverview extends ConsumerWidget {
  const ProfileOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsViewmodelProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (stats) {
        return Container(
          height: 350,
          child: Card(
            color: appColors.card,
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
                children: [
                  OverviewDetailsCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Member since',
                    detail: stats.memberSince.toString().split(' ')[0],
                  ),
                  OverviewDetailsCard(
                    icon: Icons.timer_outlined,
                    title: 'Total Study Hours',
                    detail: stats.totalStudyHours.floor().toString(),
                  ),
                  OverviewDetailsCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Total schedules',
                    detail: stats.totalSchedules.toString(),
                  ),
                  OverviewDetailsCard(
                    icon: Icons.book_outlined,
                    title: 'Total Subjects',
                    detail: stats.totalSubjects.toString(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
