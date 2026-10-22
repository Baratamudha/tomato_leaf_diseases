import 'package:material_ui/material_ui.dart';
import 'package:tomato_leaf_diseases/components/navbar_page.dart';
import 'package:tomato_leaf_diseases/ui/diseases_page.dart';
import 'package:tomato_leaf_diseases/ui/home_page.dart';
import 'package:tomato_leaf_diseases/ui/profile_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'All';

  static const _detections = [
    _HistoryDetection('Early Blight', 'May 14, 2024  •  10:30 AM', 94.2,
        'assets/image/17-removebg-preview.png'),
    _HistoryDetection('Healthy', 'May 12, 2024  •  02:15 PM', 98.6,
        'assets/image/nomer7-removebg-preview.png'),
    _HistoryDetection('Late Blight', 'May 10, 2024  •  09:20 AM', 62.1,
        'assets/image/28-removebg-preview.png'),
    _HistoryDetection('Bacterial Spot', 'May 9, 2024  •  04:45 PM', 71.3,
        'assets/image/17-removebg-preview.png'),
    _HistoryDetection('Leaf Mold', 'May 8, 2024  •  11:05 AM', 60.4,
        'assets/image/28-removebg-preview.png'),
  ];

  List<_HistoryDetection> get _visibleDetections => _detections.where((item) {
        if (_selectedFilter == 'Diseased') return item.title != 'Healthy';
        if (_selectedFilter == 'Healthy') return item.title == 'Healthy';
        return true;
      }).toList();

  void _onNavigationTap(int index) {
    final page = switch (index) {
      0 => const HomePage(),
      2 => const DiseasesPage(),
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
        backgroundColor: const Color(0xFFFFFEFA),
        bottomNavigationBar: NavBarPage(
          selectedIndex: 1,
          onTap: _onNavigationTap,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 18),
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: ['All', 'Diseased', 'Healthy']
                      .map(
                        (filter) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _FilterChip(
                            label: filter,
                            isSelected: filter == _selectedFilter,
                            onTap: () => setState(() => _selectedFilter = filter),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: _visibleDetections.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, index) =>
                      _HistoryCard(detection: _visibleDetections[index]),
                ),
              ),
            ],
          ),
        ),
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: isSelected ? const Color(0xFF398E3B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF398E3B)
                    : const Color(0xFFE7E7E7),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF3B3B3B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.detection});

  final _HistoryDetection detection;

  @override
  Widget build(BuildContext context) {
    final isHealthy = detection.title == 'Healthy';
    final isLowConfidence = detection.confidence < 80;
    final badgeColor = isLowConfidence
        ? const Color(0xFFFFF0D9)
        : const Color(0xFFE8F5E7);
    final confidenceColor = isLowConfidence
        ? const Color(0xFFF08C20)
        : const Color(0xFF398E3B);

    return Container(
      height: 78,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDEDEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isHealthy ? const Color(0xFFE5F3E3) : const Color(0xFFF4E8C9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(detection.imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detection.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  detection.dateTime,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF5F5F5F)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${detection.confidence.toStringAsFixed(1)}%',
              style: TextStyle(
                color: confidenceColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryDetection {
  const _HistoryDetection(
    this.title,
    this.dateTime,
    this.confidence,
    this.imagePath,
  );

  final String title;
  final String dateTime;
  final double confidence;
  final String imagePath;
}
