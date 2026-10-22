import 'package:material_ui/material_ui.dart';
import 'package:tomato_leaf_diseases/components/navbar_page.dart';
import 'package:tomato_leaf_diseases/ui/diseases_page.dart';
import 'package:tomato_leaf_diseases/ui/history_page.dart';
import 'package:tomato_leaf_diseases/ui/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onNavigationTap(BuildContext context, int index) {
    final page = switch (index) {
      0 => const HomePage(),
      1 => const HistoryPage(),
      2 => const DiseasesPage(),
      _ => null,
    };
    if (page != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }
  }

  void _showUnavailable(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label settings will be available soon.')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFFEFA),
        bottomNavigationBar: NavBarPage(
          selectedIndex: 3,
          onTap: (index) => _onNavigationTap(context, index),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFFFE4AE),
                  child: Icon(
                    Icons.agriculture_rounded,
                    size: 47,
                    color: Color(0xFF5A7835),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Farmer',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'Better crops, better life 🌱',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5D5D5D)),
                ),
              ),
              const SizedBox(height: 22),
              _SettingsGroup(
                children: [
                  _SettingTile(
                    icon: Icons.person_outline_rounded,
                    label: 'My Profile',
                    onTap: () => _showUnavailable(context, 'Profile'),
                  ),
                  _SettingTile(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () => _showUnavailable(context, 'App'),
                  ),
                  _SettingTile(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    value: 'English',
                    onTap: () => _showUnavailable(context, 'Language'),
                  ),
                  _SettingTile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Theme',
                    value: 'System',
                    onTap: () => _showUnavailable(context, 'Theme'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SettingsGroup(
                children: [
                  _SettingTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About App',
                    onTap: () => _showUnavailable(context, 'About'),
                  ),
                  _SettingTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => _showUnavailable(context, 'Help and support'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE7E7E4)),
        ),
        child: Column(children: children),
      );
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF363636)),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF646464)),
                ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: Color(0xFF555555),
              ),
            ],
          ),
        ),
      );
}
