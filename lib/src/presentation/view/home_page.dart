import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/selectedDayViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';
import 'package:smart_study/src/utils/SubjectCard.dart';
import 'package:smart_study/src/utils/addScheduleDialog.dart';
import 'package:smart_study/src/utils/clearDataDialog.dart';
import 'package:smart_study/src/utils/dayofWeekButton.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.black, fontSize: 24),
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
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message_outlined),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ClearDataDialog(),
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
              child: ListView.builder(
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
                      //trailing: IconButton(onPressed:  , icon: Icon(Icons.info)),
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
