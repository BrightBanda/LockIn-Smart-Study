import 'package:flutter_background_service/flutter_background_service.dart';
import 'background_study_service.dart';

Future<void> initializeStudyService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: studyServiceStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'study_channel',
      initialNotificationTitle: 'Study Session',
      initialNotificationContent: 'Ready',
      foregroundServiceNotificationId: 999,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: studyServiceStart,
      onBackground: (_) async => false,
    ),
  );
}
