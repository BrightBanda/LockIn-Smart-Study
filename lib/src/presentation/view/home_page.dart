import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/selectedDayViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/themeManagerViewmodel.dart';
import 'package:smart_study/src/utils/SubjectCard.dart';
import 'package:smart_study/src/utils/addScheduleDialog.dart';
import 'package:smart_study/src/utils/dayofWeekButton.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    final schedules = ref.watch(studyScheduleProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final subjects = ref.watch(subjectViewModelProvider);
    final scheduleProvider = ref.read(studyScheduleProvider.notifier);

    final todaySchedule = schedules.where((s) => s.day == selectedDay).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Study 🧠",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
            icon: Icon(
              themeNotifier == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).drawerTheme.backgroundColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.table_chart_outlined),
              title: Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('Subjects'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/subjects');
              },
            ),
            ListTile(
              leading: Icon(Icons.line_axis_outlined),
              title: Text('Stats'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context); // close the drawer first
                try {
                  await ref.read(googleAuthServiceProvider).signOut();
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
                }
              },
            ),
            //ClearDataDialog(),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 6),
                    Dayofweekbutton(day: "Mon"),
                    Dayofweekbutton(day: "Tue"),
                    Dayofweekbutton(day: "Wed"),
                    Dayofweekbutton(day: "Thu"),
                    Dayofweekbutton(day: "Fri"),
                    Dayofweekbutton(day: "Sat"),
                    Dayofweekbutton(day: "Sun"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: todaySchedule.isEmpty
                  ? Center(
                      child: Text(
                        'No schedules for this day 📭',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: todaySchedule.length,
                      itemBuilder: (context, index) {
                        final schedule = todaySchedule[index];
                        final subject = subjects.cast<Subject?>().firstWhere(
                          (s) => s?.id == schedule.subjectId,
                          orElse: () => null,
                        );

                        if (subject == null) {
                          return const ListTile(
                            title: Text('Subject not found'),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Subjectcard(
                            schedule: schedule,
                            subject: subject,
                            onPressed: (context) =>
                                scheduleProvider.removeSchedule(schedule.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSubject = await showDialog<StudySchedule>(
            context: context,
            builder: (context) {
              return AddScheduleDialog();
            },
          );
          if (newSubject != null) {
            scheduleProvider.addSchedule(newSubject);
          }
        },
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
