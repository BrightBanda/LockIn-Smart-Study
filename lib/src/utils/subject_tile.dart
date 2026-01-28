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
              onPressed: (context) async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Subject"),
                      content: const Text(
                        "Deleting this subject will also delete all schedules linked to it. "
                        "Are you sure you want to continue?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete == true) {
                  onPressed?.call(context);
                }
              },
              backgroundColor: Colors.deepOrangeAccent,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            border: Border.all(color: const Color.fromARGB(255, 201, 197, 197)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Text(
              subjectName,
              style: TextStyle(
                fontSize: 19,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
