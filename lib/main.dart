import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/view/home_page.dart';
import 'package:smart_study/src/presentation/view/subjects_page.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homepage(),

      initialRoute: '/',
      routes: {'/subjects': (context) => const SubjectsPage()},
    );
  }
}
