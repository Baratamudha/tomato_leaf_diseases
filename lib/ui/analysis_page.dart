import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomato_leaf_diseases/ui/results_page.dart';

/// A progress screen displayed while a leaf image is being classified.
///
/// [onAnalyze] may be connected to a real model or API. The progress ring keeps
/// moving while that work is running and only reaches 100% when it finishes.
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    super.key,
    required this.image,
    this.onAnalyze,
    this.onResult,
  });

  final XFile image;
  final FutureOr<void> Function(XFile image)? onAnalyze;
  final ValueChanged<AnalysisResult>? onResult;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  bool _complete = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..animateTo(.90, duration: const Duration(seconds: 12));
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    try {
      // Keeping the screen visible briefly avoids a jarring flash for very
      // fast on-device models, while longer model work controls the real pace.
      await Future.wait<void>([
        Future<void>.sync(() => widget.onAnalyze?.call(widget.image)),
        Future<void>.delayed(const Duration(milliseconds: 2200)),
      ]);
      if (!mounted) return;
      await _progressController.animateTo(
        1,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      if (!mounted) return;
      setState(() => _complete = true);
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultsPage(
            image: widget.image,
            // Replace this temporary value with the label/confidence returned
            // by the connected TFLite classifier.
            result: const AnalysisResult(
              diseaseName: 'Bercak Daun',
              confidence: 94.2,
              description:
                  'Bercak daun is a fungal disease that causes spots on tomato leaves. Remove severely affected leaves and avoid wetting foliage when watering.',
            ),
            onBackToHome: widget.onResult,
          ),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFFEFA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0x18000000),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Back',
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Text(
                  _failed
                      ? 'Analisis Gagal'
                      : _complete
                          ? 'Analisis Selesai!'
                          : 'Sedang Menganalisis...',
                  style: const TextStyle(
                    color: Color(0xFF102C26),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _failed
                      ? 'Terjadi kendala saat menganalisis gambar.\nSilakan coba lagi.'
                      : _complete
                          ? 'Gambar daun tomat telah berhasil dianalisis.'
                          : 'Model AI sedang menganalisis gambar\ndaun tomat Anda. Mohon tunggu beberapa saat.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF66707B),
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 33),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, _) => _AnalysisIndicator(
                    progress: _progressController.value,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, _) => Text(
                    '${(_progressController.value * 100).round()}%',
                    style: const TextStyle(
                      color: Color(0xFF087B50),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _complete
                      ? 'Analisis siap ditampilkan'
                      : 'Mengklasifikasi penyakit daun...',
                  style: const TextStyle(
                    color: Color(0xFF66707B),
                    fontSize: 13,
                  ),
                ),
                const Spacer(flex: 2),
                const _InfoCard(
                  icon: Icons.psychology_outlined,
                  title: 'Menggunakan model\nXception (TFLite)',
                  subtitle: '5 kelas penyakit daun tomat',
                  tint: Color(0xFFE1F6E9),
                  iconColor: Color(0xFF178758),
                ),
                const SizedBox(height: 15),
                const _InfoCard(
                  icon: Icons.info_outline_rounded,
                  title: 'Mohon jangan menutup aplikasi\nselama proses analisis berlangsung.',
                  tint: Color(0xFFEAF6FD),
                  iconColor: Color(0xFF2C99C7),
                ),
              ],
            ),
          ),
        ),
      );
}

class _AnalysisIndicator extends StatelessWidget {
  const _AnalysisIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 190,
        height: 190,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 172,
              height: 172,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1749C88A)),
              ),
            ),
            SizedBox(
              width: 145,
              height: 145,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: const Color(0xFFE3F6EB),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF39BD79)),
              ),
            ),
            Container(
              width: 105,
              height: 105,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F9EF),
              ),
            ),
            const Icon(Icons.eco_rounded, color: Color(0xFF0B945D), size: 57),
          ],
        ),
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.tint,
    required this.iconColor,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tint.withValues(alpha: .62),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!, style: const TextStyle(fontSize: 10, color: Color(0xFF66707B))),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}
