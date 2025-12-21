import 'package:flutter/material.dart';
import 'package:smart_study/src/data/model/Subject.dart';

class Addsubjectdialog extends StatelessWidget {
  String name = '';
  String hoursStr = '';
  Addsubjectdialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Subject'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Subject Name'),
            onChanged: (value) {
              name = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Time'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              hoursStr = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            final time = int.tryParse(hoursStr) ?? 0;
            final subject = Subject(
              id: DateTime.now().toString(),
              name: name,
              time: time,
              isCompleted: false,
            );
            Navigator.of(context).pop(subject);
          },
          child: Text('ADD'),
        ),
      ],
    );
  }
}
