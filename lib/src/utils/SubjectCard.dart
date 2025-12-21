import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/presentation/viewmodel/studySessionViewmodel.dart';

class Subjectcard extends ConsumerWidget {
  final String subjectName;
  final int hours;
  final String subjectId;
  final Subject subject;

  const Subjectcard({
    super.key,
    required this.subjectName,
    required this.hours,
    required this.subjectId,
    required this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(studySessionProvider);
    final session = sessions[subjectId];
    final studySessionNotifier = ref.read(studySessionProvider.notifier);

    final remainingTime = session?.remainingSeconds ?? subject.time * 60;
    final isRunning = session?.isRunning ?? false;
    return Container(
      height: 800,
      child: Card(
        color: isRunning ? Colors.green[100] : Colors.white,
        shadowColor: Colors.black54,
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 20, color: Colors.greenAccent),
            SizedBox(height: 2),
            Text(
              subjectName,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              'Time: $hours',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 2),
            Text(
              _formatTime(remainingTime),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Container(
              height: 40,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.amberAccent[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                onPressed: () {
                  if (isRunning) {
                    studySessionNotifier.stopSession(subjectId);
                  } else {
                    studySessionNotifier.startSession(subject);
                  }
                },
                child: Text(isRunning ? 'Stop' : 'Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
