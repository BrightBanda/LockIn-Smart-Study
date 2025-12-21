import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/utils/SubjectCard.dart';
import 'package:smart_study/src/utils/addSubjectDialog.dart';
import 'package:smart_study/src/utils/dayofWeekButton.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectViewModelProvider);
    final subjectProvider = ref.read(subjectViewModelProvider.notifier);
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
              leading: Icon(Icons.home_outlined),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart_outlined),
              title: Text('TimeTable'),
              onTap: () {
                Navigator.pop(context);
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
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Subjectcard(
                      subjectId: subject.id,
                      subjectName: subject.name,
                      hours: subject.time,
                      subject: subject,
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
          final newSubject = await showDialog<Subject>(
            context: context,
            builder: (context) {
              return Addsubjectdialog();
            },
          );
          if (newSubject != null) {
            subjectProvider.addSubject(newSubject);
          }
        },
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
