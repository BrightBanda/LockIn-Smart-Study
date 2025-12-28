import 'package:flutter/material.dart';
import 'package:smart_study/src/data/model/Subject.dart';

class AddSubjectDialog extends StatelessWidget {
  String name = '';
  AddSubjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(" Add A New Subject", style: TextStyle(fontSize: 15)),
      content: TextField(
        decoration: InputDecoration(labelText: 'Subject Name'),
        onChanged: (value) {
          name = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            final subject = Subject(
              id: DateTime.now().toString(),
              name: name,
              //time: 60,
              //isCompleted: false,
            );
            Navigator.of(context).pop(subject);
          },
          child: Text('ADD'),
        ),
      ],
    );
  }
}
