import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomato_leaf_diseases/components/navbar_page.dart';
import 'package:tomato_leaf_diseases/ui/diseases_page.dart';
import 'package:tomato_leaf_diseases/ui/history_page.dart';
import 'package:tomato_leaf_diseases/ui/profile_page.dart';

/// The first screen shown after onboarding.
///
/// Replace [_detections] with persisted analysis results when the analysis
/// service is connected.  The list is sorted newest-first and this page only
/// renders its first three entries in the "Latest Detections" section.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onImageSelected});

  /// A hook for the future image-analysis flow.
  final ValueChanged<XFile>? onImageSelected;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _imagePicker = ImagePicker();

  final List<Detection> _detections = const [
    Detection(
      title: 'Early Blight',
      date: 'May 12, 2024',
      time: '10:30 AM',
      confidence: 94.2,
      imagePath: 'assets/image/17-removebg-preview.png',
    ),
    Detection(
      title: 'Healthy',
      date: 'May 10, 2024',
      time: '02:15 PM',
      confidence: 98.6,
      imagePath: 'assets/image/nomer7-removebg-preview.png',
    ),
    Detection(
      title: 'Late Blight',
      date: 'May 8, 2024',
      time: '09:20 AM',
      confidence: 62.1,
      imagePath: 'assets/image/28-removebg-preview.png',
    ),
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 88,
      );
      if (!mounted || image == null) return;

      widget.onImageSelected?.call(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${source == ImageSource.camera ? 'Photo taken' : 'Image selected'} — ready for analysis.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the image picker. Please try again.'),
        ),
      );
    }
  }

  void _openAllDetections() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DetectionHistoryPage(detections: _detections),
    ),
  );

  void _openDetection(Detection detection) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DetectionDetailPage(detection: detection),
    ),
  );

  void _onNavigationTap(int index) {
    final page = switch (index) {
      1 => const HistoryPage(),
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
  Widget build(BuildContext context) {
    final latest = _detections.take(3).toList(growable: false);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFA),
      bottomNavigationBar: NavBarPage(
        selectedIndex: 0,
        onTap: _onNavigationTap,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
          children: [
            _DetectionHero(
              onCamera: () => _pickImage(ImageSource.camera),
              onGallery: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                const Text(
                  'Latest Detections',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _openAllDetections,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF368C36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...latest.map(
              (detection) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DetectionCard(
                  detection: detection,
                  onTap: () => _openDetection(detection),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetectionHero extends StatelessWidget {
  const _DetectionHero({required this.onCamera, required this.onGallery});

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(
        colors: [Color(0xFF57A94C), Color(0xFF237C2E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x332B7A31),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detect disease\nof tomato leaves',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            height: 1.12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Take a photo or upload an image of a tomato leaf to detect disease.',
          style: TextStyle(
            color: Color(0xFFF3FFF1),
            fontSize: 14,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _SourceButton(
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                onTap: onCamera,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SourceButton(
                icon: Icons.photo_rounded,
                label: 'Gallery',
                onTap: onGallery,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 116,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3B963D), size: 40),
            const SizedBox(height: 9),
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DetectionCard extends StatelessWidget {
  const _DetectionCard({required this.detection, required this.onTap});

  final Detection detection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLowConfidence = detection.confidence < 80;
    final badgeColor = isLowConfidence
        ? const Color(0xFFFFF0D8)
        : const Color(0xFFEAF7E9);
    final confidenceColor = isLowConfidence
        ? const Color(0xFFF18C1A)
        : const Color(0xFF358B38);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 94,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9E9E9)),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: detection.title == 'Healthy'
                      ? const Color(0xFFE5F3E3)
                      : const Color(0xFFF4E8C9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(detection.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detection.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${detection.date}  •  ${detection.time}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF656565),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${detection.confidence.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: confidenceColor,
                    fontWeight: FontWeight.w800,
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

class DetectionHistoryPage extends StatelessWidget {
  const DetectionHistoryPage({super.key, required this.detections});

  final List<Detection> detections;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('All Detections')),
    body: ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: detections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _DetectionCard(
        detection: detections[index],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetectionDetailPage(detection: detections[index]),
          ),
        ),
      ),
    ),
  );
}

/// Temporary detail destination; it makes the home-card navigation ready for
/// the dedicated analysis-result screen that will replace it next.
class DetectionDetailPage extends StatelessWidget {
  const DetectionDetailPage({super.key, required this.detection});

  final Detection detection;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detection Result')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              detection.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text('${detection.confidence.toStringAsFixed(1)}% confidence'),
            const SizedBox(height: 8),
            Text(
              '${detection.date} • ${detection.time}',
              style: const TextStyle(color: Color(0xFF656565)),
            ),
          ],
        ),
      ),
    ),
  );
}

class Detection {
  const Detection({
    required this.title,
    required this.date,
    required this.time,
    required this.confidence,
    required this.imagePath,
  });

  final String title;
  final String date;
  final String time;
  final double confidence;
  final String imagePath;
}
