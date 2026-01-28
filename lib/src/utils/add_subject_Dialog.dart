import 'package:flutter/material.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';

class AddSubjectDialog extends StatelessWidget {
  String name = '';
  AddSubjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return AlertDialog(
      backgroundColor: appColors.card,
      title: Text(
        " Add A New Subject",
        style: TextStyle(fontSize: 15, color: appColors.textPrimary),
      ),
      content: TextField(
        style: TextStyle(color: appColors.textPrimary),
        decoration: InputDecoration(labelText: 'Subject Name'),
        onChanged: (value) {
          name = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            final subject = Subject(id: DateTime.now().toString(), name: name);
            Navigator.of(context).pop(subject);
          },
          child: Text('ADD'),
        ),
      ],
    );
  }
}
