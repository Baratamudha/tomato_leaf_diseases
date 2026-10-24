import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

/// The outcome returned by the leaf classifier.
///
/// Pass the classifier's label and confidence to [ResultsPage] after an image
/// has been analysed. Confidence is expressed as a percentage (0-100).
class AnalysisResult {
  const AnalysisResult({
    required this.diseaseName,
    required this.confidence,
    this.description,
  });

  final String diseaseName;
  final double confidence;
  final String? description;

  bool get isHighConfidence => confidence >= 80;
}

/// Shows the captured/uploaded leaf image alongside its classification result.
class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
    required this.image,
    required this.result,
    this.onBackToHome,
  });

  final XFile image;
  final AnalysisResult result;
  final ValueChanged<AnalysisResult>? onBackToHome;

  String get _description =>
      result.description ??
      '${result.diseaseName} was detected on this tomato leaf. Check the leaf regularly and isolate affected plants when appropriate.';

  @override
  Widget build(BuildContext context) {
    final confidenceColor = result.isHighConfidence
        ? const Color(0xFF27883A)
        : const Color(0xFFD77A16);
    final confidenceBackground = result.isHighConfidence
        ? const Color(0xFFE4F3E4)
        : const Color(0xFFFFEFD8);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFEFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Back to home',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _returnHome(context),
        ),
        centerTitle: true,
        title: const Text(
          'Result',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEEEEEE)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      File(image.path),
                      width: 112,
                      height: 128,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox(
                        width: 112,
                        height: 128,
                        child: ColoredBox(
                          color: Color(0xFFE6EFE1),
                          child: Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.diseaseName,
                          style: const TextStyle(
                            fontSize: 19,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Confidence',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A6A6A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${result.confidence.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: confidenceColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: confidenceBackground,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            result.isHighConfidence
                                ? 'High Confidence'
                                : 'Low Confidence',
                            style: TextStyle(
                              color: confidenceColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              _description,
              style: const TextStyle(
                color: Color(0xFF3F3F3F),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'View Details',
                    icon: Icons.article_outlined,
                    onTap: () => _showComingSoon(context, 'Disease details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    label: 'Save Result',
                    icon: Icons.bookmark_border_rounded,
                    onTap: () => _showComingSoon(context, 'Result saved'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ActionButton(
              label: 'Share Result',
              icon: Icons.share_outlined,
              wide: true,
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                  text:
                      '${result.diseaseName} detected with ${result.confidence.toStringAsFixed(1)}% confidence.',
                ));
                if (context.mounted) _showComingSoon(context, 'Result copied');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _returnHome(BuildContext context) {
    onBackToHome?.call(result);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.wide = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, wide ? 49 : 48),
          foregroundColor: const Color(0xFF2C2C2C),
          side: const BorderSide(color: Color(0xFFE5E5E5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      );
}
