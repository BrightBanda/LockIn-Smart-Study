import 'package:flutter/material.dart';
import 'package:smart_study/src/presentation/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final pages = [
    {
      "title": "Welcome to LockIN",
      "desc": "Stay focused and build powerful study streaks.",
    },
    {
      "title": "Track Progress",
      "desc": "See your daily completion and streak growth.",
    },
    {
      "title": "Stay Consistent",
      "desc": "Small daily wins lead to big results.",
    },
  ];

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pages[index]['title']!,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pages[index]['desc']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _pageIndex == pages.length - 1
                  ? finishOnboarding
                  : () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
              child: Text(
                _pageIndex == pages.length - 1 ? "Get Started" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
