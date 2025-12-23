import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final String subjectName;
  final void Function()? onPressed;
  const SubjectTile({
    super.key,
    required this.subjectName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 201, 197, 197)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Text(subjectName, style: TextStyle(fontSize: 19)),
          trailing: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.delete_outline),
          ),
        ),
      ),
    );
  }
}
