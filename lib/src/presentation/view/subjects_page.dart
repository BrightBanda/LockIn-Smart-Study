import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/utils/add_subject_Dialog.dart';
import 'package:smart_study/src/utils/subject_tile.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectViewModelProvider);
    final subjectProv = ref.read(subjectViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subjects",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: subjects.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No subjects added yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    "       press the '+' button to add a subject",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (BuildContext context, int index) {
                  final subject = subjects[index];
                  return SubjectTile(
                    subjectName: subject.name,
                    onPressed: (context) =>
                        subjectProv.removeSubject(subject.id),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSubject = await showDialog<Subject>(
            context: context,
            builder: (context) {
              return AddSubjectDialog();
            },
          );
          if (newSubject != null) {
            subjectProv.addSubject(newSubject);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
