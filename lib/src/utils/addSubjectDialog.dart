import 'package:flutter/material.dart';
import 'package:smart_study/src/data/model/Subject.dart';

class Addsubjectdialog extends StatelessWidget {
  String name = '';
  String hoursStr = '';
  String minutesStr = '';
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Hours'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    hoursStr = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    minutesStr = value;
                  },
                ),
              ),
            ],
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
            final hours = int.tryParse(hoursStr) ?? 0;
            final minutes = int.tryParse(minutesStr) ?? 0;

            final safeMinutes = minutes.clamp(0, 59);
            final totalTime = (hours * 60) + safeMinutes;
            final subject = Subject(
              id: DateTime.now().toString(),
              name: name,
              time: totalTime,
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
