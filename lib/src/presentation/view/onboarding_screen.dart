import 'package:flutter/material.dart';
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
    OnboardingSlide(
      title: 'Welcome to TaskMaster',
      description: 'Your ultimate task management solution',
      image: Icons.rocket_launch,
      color: Colors.blue,
      backgroundColor: Color(0xFF6B8DD6),
    ),
    OnboardingSlide(
      title: 'Organize Your Tasks',
      description: 'Create, manage, and organize your daily tasks efficiently',
      image: Icons.task_alt,
      color: Colors.orange,
      backgroundColor: Color(0xFFFF8C42),
    ),
    OnboardingSlide(
      title: 'Set Reminders',
      description: 'Never miss important deadlines with smart reminders',
      image: Icons.notifications_active,
      color: Colors.green,
      backgroundColor: Color(0xFF4CAF50),
    ),
    OnboardingSlide(
      title: 'Track Progress',
      description: 'Monitor your productivity with detailed analytics',
      image: Icons.analytics,
      color: Colors.purple,
      backgroundColor: Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for slides
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

          // Skip button (visible on all pages except last)
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

          // Bottom section with indicators and buttons
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicators
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

                // Navigation buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      // Back button (hidden on first page)
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

                      // Next/Get Started button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == slides.length - 1) {
                              // Navigate to home screen
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
    // Navigate to your home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );

    // You can also save that onboarding is completed
    // SharedPreferences or similar
  }
}

// Individual slide widget
class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlide slide;
  final bool isLastPage;

  const OnboardingSlideWidget({
    Key? key,
    required this.slide,
    required this.isLastPage,
  }) : super(key: key);

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
              // Animated icon with scale effect
              TweenAnimationBuilder(
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
                        slide.image,
                        size: 100 * value,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 60),

              // Title with fade animation
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Text(
                        slide.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Description with fade animation
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Text(
                        slide.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              // Optional: Show a special message on last page
              if (isLastPage)
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: TweenAnimationBuilder(
                    duration: Duration(milliseconds: 1200),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Ready to boost your productivity?',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model class for onboarding slides
class OnboardingSlide {
  final String title;
  final String description;
  final IconData image;
  final Color color;
  final Color backgroundColor;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    required this.backgroundColor,
  });
}
