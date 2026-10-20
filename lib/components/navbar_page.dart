import 'package:flutter/material.dart';

/// A reusable Material navigation bar for the app's main sections.
///
/// Keep [selectedIndex] in the parent page and update it through [onTap].
class NavBarPage extends StatelessWidget {
  const NavBarPage({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  }) : assert(selectedIndex >= 0 && selectedIndex < 4);

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: onTap,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'History',
      ),
      NavigationDestination(
        icon: Icon(Icons.local_florist_outlined),
        selectedIcon: Icon(Icons.local_florist),
        label: 'Diseases',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  );
}
