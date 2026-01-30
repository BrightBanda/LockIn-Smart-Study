import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void studyServiceStart(ServiceInstance service) async {
  final notification = FlutterLocalNotificationsPlugin();

  int remainingSeconds = 0;
  bool isRunning = false;
  Timer? timer;

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  await notification.initialize(
    const InitializationSettings(android: androidInit),
    onDidReceiveBackgroundNotificationResponse: (response) {
      if (response.actionId == 'pause') {
        service.invoke('pause');
      } else if (response.actionId == 'reset') {
        service.invoke('reset');
      }
    },
  );

  // ✅ CREATE CHANNEL
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'study_channel',
    'Study Session',
    description: 'Study timer running in the background',
    importance: Importance.high,
  );

  await notification
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // 🔴 VERY IMPORTANT: SHOW NOTIFICATION IMMEDIATELY
  await notification.show(
    999,
    'Study Session',
    'Preparing session…',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'study_channel',
        'Study Session',
        channelDescription: 'Study timer running',
        ongoing: true,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );

  // ✅ helper to update notification later
  void showNotification() async {
    await notification.show(
      999,
      'Study Session',
      'Remaining: ${remainingSeconds ~/ 60} min ${remainingSeconds % 60}s',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'study_channel',
          'Study Session',
          channelDescription: 'Study timer running',
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          actions: const [
            AndroidNotificationAction('pause', 'Pause'),
            AndroidNotificationAction('reset', 'Reset'),
          ],
        ),
      ),
    );
  }

  // ▶️ START
  service.on('start').listen((event) {
    remainingSeconds = event?['seconds'] ?? 0;
    isRunning = true;

    showNotification();

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      remainingSeconds--;
      showNotification();

      service.invoke('tick', {'remainingSeconds': remainingSeconds});

      if (remainingSeconds <= 0) {
        timer?.cancel();
        isRunning = false;
      }
    });
  });

  // ⏸ PAUSE
  service.on('pause').listen((_) {
    isRunning = false;
  });

  // 🔁 RESET
  service.on('reset').listen((_) {
    timer?.cancel();
    isRunning = false;
    remainingSeconds = 0;
    showNotification();
  });
}
