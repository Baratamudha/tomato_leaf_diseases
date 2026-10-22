import 'package:material_ui/material_ui.dart';
import 'package:tomato_leaf_diseases/components/navbar_page.dart';
import 'package:tomato_leaf_diseases/ui/history_page.dart';
import 'package:tomato_leaf_diseases/ui/home_page.dart';
import 'package:tomato_leaf_diseases/ui/profile_page.dart';

class DiseasesPage extends StatelessWidget {
  const DiseasesPage({super.key});

  void _onNavigationTap(BuildContext context, int index) {
    final page = switch (index) {
      0 => const HomePage(),
      1 => const HistoryPage(),
      3 => const ProfilePage(),
      _ => null,
    };
    if (page != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Diseases')),
    body: const Center(child: Text('Tomato disease information will appear here.')),
    bottomNavigationBar: NavBarPage(
      selectedIndex: 2,
      onTap: (index) => _onNavigationTap(context, index),
    ),
  );
}
