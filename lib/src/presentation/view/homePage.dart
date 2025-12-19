import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/utils/SubjectCard.dart';
import 'package:smart_study/src/utils/addSubjectDialog.dart';

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
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Timer'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 25,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Subjectcard(
            subjectName: subject.name,
            hours: subject.time,
            subjectId: subject.id,
            subject: subject,
          );
        },
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
