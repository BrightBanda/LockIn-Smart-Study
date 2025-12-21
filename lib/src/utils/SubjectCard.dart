import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/presentation/viewmodel/studySessionViewmodel.dart';
import 'package:smart_study/src/utils/myButton.dart';

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
      height: 300,
      padding: EdgeInsets.all(8.0),
      child: Card(
        color: isRunning ? Colors.yellow[100] : Colors.white,
        shadowColor: Colors.black54,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //icon,subject and name row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.book, size: 30, color: Colors.greenAccent),

                  Text(
                    subjectName,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(width: 20),
                  //timer display
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text(
                      _formatTime(remainingTime),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),

              //progress bar and start/stop button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Progress", style: TextStyle(fontSize: 16)),
                  //percentage text
                  Text(
                    "${((1 - (remainingTime / (subject.time * 60)).clamp(0.0, 1.0)) * 100).round()}%",
                  ),
                ],
              ),
              LinearProgressIndicator(
                value:
                    1 - (remainingTime / (subject.time * 60)).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                color: Colors.blueAccent,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              Row(
                children: [
                  Mybutton(
                    onPressed: () {
                      if (isRunning) {
                        studySessionNotifier.stopSession(subjectId);
                      } else {
                        studySessionNotifier.startSession(subject);
                      }
                    },
                    child: Text(isRunning ? 'Stop' : 'Start'),
                  ),
                  SizedBox(width: 7),
                  Mybutton(
                    onPressed: () {
                      studySessionNotifier.resetSession(subject);
                    },
                    child: Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
