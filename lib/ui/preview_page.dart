import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomato_leaf_diseases/ui/analysis_page.dart';

/// Lets the user review a camera or gallery image before disease analysis.
class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key, required this.image, this.onAnalyze});

  final XFile image;
  final FutureOr<void> Function(XFile image)? onAnalyze;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final Map<String, bool> _checks = {
    'Leaf is clear': true,
    'Good lighting': true,
    'Leaf is in focus': true,
  };

  void _analyze() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AnalysisPage(
        image: widget.image,
        onAnalyze: widget.onAnalyze,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFFEF9),
    appBar: AppBar(
      backgroundColor: const Color(0xFFFFFEF9),
      foregroundColor: const Color(0xFF212121),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          tooltip: 'Remove image',
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 6),
      ],
    ),
    body: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(
                      File(widget.image.path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: Color(0xFFE8EEE5),
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Color(0xFF4D754B),
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            const Text(
              'Is the image good?',
              style: TextStyle(
                color: Color(0xFF494949),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._checks.entries.map(
              (entry) => CheckboxListTile(
                value: entry.value,
                onChanged: (value) => setState(
                  () => _checks[entry.key] = value ?? false,
                ),
                title: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                activeColor: const Color(0xFF368C36),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 51,
              child: ElevatedButton(
                onPressed: _checks.values.every((isChecked) => isChecked)
                    ? _analyze
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF398F35),
                  disabledBackgroundColor: const Color(0xFFB8CCB6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Analyze Disease',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
