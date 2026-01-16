import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/viewmodel/statsViewmodel.dart';
import 'package:smart_study/src/utils/stats/statTile.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final statsAsync = ref.watch(statsViewmodelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: statsAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('Error: $err'));
        },
        data: (stats) {
          return ListView(
            children: [
              StatTile(
                label: "Total Hours",
                value: stats.totalStudyHours.floor().toString(),
              ),
              StatTile(
                label: "Subjects",
                value: stats.totalSubjects.toString(),
              ),
              StatTile(
                label: "Schedules",
                value: stats.totalSchedules.toString(),
              ),
              //StatTile(label: "Member Since", value: stats.memberSince),
            ],
          );
        },
      ),
    );
  }
}
