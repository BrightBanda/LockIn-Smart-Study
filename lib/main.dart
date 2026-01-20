import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/firebase_options.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';
import 'package:smart_study/src/data/services/background_service_initializer.dart';
import 'package:smart_study/src/presentation/view/auth_gate.dart';
import 'package:smart_study/src/presentation/view/login_page.dart';
import 'package:smart_study/src/presentation/view/profile_page.dart';
import 'package:smart_study/src/presentation/view/stats_page.dart';
import 'package:smart_study/src/presentation/view/subjects_page.dart';
import 'package:smart_study/src/presentation/viewmodel/themeManagerViewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(StudysessionAdapter());
  Hive.registerAdapter(StudyScheduleAdapter());
  Hive.registerAdapter(WeekDayAdapter());

  await Hive.deleteBoxFromDisk('schedules');
  await Hive.deleteBoxFromDisk('sessions');

  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<Studysession>('sessions');
  await Hive.openBox<StudySchedule>('schedules');

  await initializeStudyService();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier,

      home: const AuthGate(),

      initialRoute: '/',
      routes: {
        '/subjects': (context) => const SubjectsPage(),
        '/profile': (context) => const ProfilePage(),
        '/loginPage': (context) => const LoginPage(),
        '/statsPage': (context) => const StatsPage(),
      },
    );
  }
}
