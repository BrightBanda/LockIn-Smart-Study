import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SubjectTile extends StatelessWidget {
  final String subjectName;
  final void Function(BuildContext)? onPressed;
  const SubjectTile({
    super.key,
    required this.subjectName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onPressed,
              backgroundColor: Colors.deepOrangeAccent,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 201, 197, 197)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Text(subjectName, style: TextStyle(fontSize: 19)),
          ),
        ),
      ),
    );
  }
}
