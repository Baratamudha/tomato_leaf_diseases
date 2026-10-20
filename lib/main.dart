import 'package:flutter/material.dart';
import 'package:tomato_leaf_diseases/ui/onboarding_page.dart';

void main() => runApp(const TomatoCareApp());

class TomatoCareApp extends StatelessWidget {
  const TomatoCareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tomato Care',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
          scaffoldBackgroundColor: const Color(0xFFFFFEF8),
          useMaterial3: true,
        ),
        home: const OnboardingPage(),
      );
}
