import 'package:flutter/material.dart';
import 'package:smart_study/src/data/model/onboardingSlide.dart';
import 'package:smart_study/src/presentation/view/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of onboarding slides
  final List<OnboardingSlide> slides = [
    // ===== INTRO SLIDES =====
    OnboardingSlide(
      title: 'Welcome to LockIN',
      description:
          'A focused study system built to help you stay consistent and organized.',
      icon: Icons.lock,
      color: Colors.white,
      backgroundColor: Color(0xFF1E1E2E),
    ),
    OnboardingSlide(
      title: 'Create Your Subjects',
      description: 'Add custom subjects and organize everything your way.',
      icon: Icons.menu_book,
      color: Colors.white,
      backgroundColor: Color(0xFF2D2D44),
    ),
    OnboardingSlide(
      title: 'Plan Schedules & Sessions',
      description:
          'Set study schedules and start focused sessions for each subject.',
      icon: Icons.schedule,
      color: Colors.white,
      backgroundColor: Color(0xFF3A3A5E),
    ),
    OnboardingSlide(
      title: 'Track Streaks & Progress',
      description:
          'Stay consistent with streaks and monitor your performance with detailed stats.',
      icon: Icons.analytics,
      color: Colors.white,
      backgroundColor: Color(0xFF4B4B73),
    ),

    // ===== INSTRUCTION SLIDES (SCREENSHOTS) =====
    /*
    OnboardingSlide(
      title: 'Add Your Subjects',
      description: 'Tap the + button to create a new subject.',
      imagePath: 'lib/assets/subjects.png',
      backgroundColor: Color(0xFF2D2D44),
    ),
    OnboardingSlide(
      title: 'Swipe to Manage',
      description: 'Swipe left or right on a subject to edit or delete it.',
      imagePath: 'lib/assets/swipe.png',
      backgroundColor: Color(0xFF3A3A5E),
    ),
    */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingSlideWidget(
                slide: slides[index],
                isLastPage: index == slides.length - 1,
              );
            },
          ),

          // Skip button
          if (_currentPage < slides.length - 1)
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    slides.length - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Bottom Section
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                      if (_currentPage > 0) SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == slides.length - 1) {
                              _navigateToHome();
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                slides[_currentPage].backgroundColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            _currentPage == slides.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }
}

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlide slide;
  final bool isLastPage;

  const OnboardingSlideWidget({
    Key? key,
    required this.slide,
    required this.isLastPage,
  }) : super(key: key);

  Widget _buildVisual() {
    if (slide.imagePath != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              slide.imagePath!,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Icon(Icons.arrow_upward, color: Colors.white, size: 40),
          ),
        ],
      );
    } else {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                slide.icon,
                size: 100 * value,
                color: slide.color ?? Colors.white,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: slide.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildVisual(),
              SizedBox(height: 60),

              Text(
                slide.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Text(
                slide.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              if (isLastPage)
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Ready to LockIN?',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
