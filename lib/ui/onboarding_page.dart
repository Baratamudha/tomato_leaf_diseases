import 'package:material_ui/material_ui.dart';
import 'package:tomato_leaf_diseases/ui/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = <OnboardingContent>[
    OnboardingContent(
      title: 'Detect. Understand.\nProtect.',
      description: 'Diagnose tomato leaf diseases in seconds and get the right solution.',
      imagePath: 'assets/image/nomer7-removebg-preview.png',
    ),
    OnboardingContent(
      title: 'Scan your\ntomato leaves.',
      description: 'Take a clear photo of a leaf to identify possible signs of disease.',
      imagePath: 'assets/image/17-removebg-preview.png',
    ),
    OnboardingContent(
      title: 'Grow healthier\ntomatoes.',
      description: 'Get practical treatment tips and protect your plants with confidence.',
      imagePath: 'assets/image/28-removebg-preview.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _goHome();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _goHome() => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(34, media.padding.top > 0 ? 8 : 28, 34, 28),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _currentPage = value),
                  itemBuilder: (context, index) => _OnboardingSlide(content: _pages[index]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: index == _currentPage ? 10 : 8,
                    height: index == _currentPage ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFB7D6B7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  TextButton(
                    onPressed: _goHome,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF39713B),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Skip'),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Getting Started' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.content});

  final OnboardingContent content;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            content.title,
            style: const TextStyle(
              color: Color(0xFF1D1D1D),
              fontSize: 25,
              height: 1.14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content.description,
            style: const TextStyle(
              color: Color(0xFF313131),
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                content.imagePath,
                width: 285,
                fit: BoxFit.contain,
                semanticLabel: 'Tomato leaf illustration',
              ),
            ),
          ),
        ],
      );
}

class OnboardingContent {
  const OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}
