import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/studySessionViewmodel.dart';
import 'package:smart_study/src/utils/myButton.dart';

class Subjectcard extends ConsumerWidget {
  final StudySchedule schedule;
  final Subject subject;
  final void Function(BuildContext)? onPressed;

  const Subjectcard({
    super.key,
    required this.schedule,
    required this.subject,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(studySessionProvider);
    final session = sessions[schedule.id];
    final notifier = ref.read(studySessionProvider.notifier);

    final totalSeconds = schedule.minutes * 60;
    final remainingSeconds = session?.remainingSeconds ?? totalSeconds;

    final isRunning = session?.isRunning ?? false;
    final isCompleted = schedule.isCompleted;

    final progress = 1 - (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onPressed,
            icon: Icons.delete,
            label: "Remove",
            backgroundColor: Colors.deepOrangeAccent,
          ),
        ],
      ),
      child: Card(
        color: isCompleted
            ? Colors.lightGreenAccent[100]
            : isRunning
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).cardTheme.color,
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _formatTime(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(6),
                color: Colors.blueAccent[100],
              ),

              const SizedBox(height: 6),
              Text(
                "${(progress * 100).round()}%",
                style: const TextStyle(color: Colors.black87),
              ),

              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Mybutton(
                    onPressed: () {
                      if (isRunning) {
                        notifier.stopSession(schedule.id);
                      } else {
                        notifier.startSession(schedule);
                      }
                    },
                    child: Text(isRunning ? "Stop" : "Start"),
                  ),
                  const SizedBox(width: 8),
                  Mybutton(
                    onPressed: () {
                      notifier.resetSession(schedule);
                    },
                    child: const Text("Reset"),
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
