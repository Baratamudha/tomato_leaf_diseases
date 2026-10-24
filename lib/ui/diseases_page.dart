import 'package:material_ui/material_ui.dart';
import 'package:tomato_leaf_diseases/components/navbar_page.dart';
import 'package:tomato_leaf_diseases/ui/history_page.dart';
import 'package:tomato_leaf_diseases/ui/home_page.dart';
import 'package:tomato_leaf_diseases/ui/profile_page.dart';

const _green = Color(0xFF18733D);

class DiseasesPage extends StatefulWidget {
  const DiseasesPage({super.key});
  @override
  State<DiseasesPage> createState() => _DiseasesPageState();
}

class _DiseasesPageState extends State<DiseasesPage> {
  String _query = '';
  void _navigate(int index) {
    final page = switch (index) { 0 => const HomePage(), 1 => const HistoryPage(), 3 => const ProfilePage(), _ => null };
    if (page != null) Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => page));
  }
  @override
  Widget build(BuildContext context) {
    final items = tomatoDiseases.where((d) => d.name.toLowerCase().contains(_query.toLowerCase()) || d.summary.toLowerCase().contains(_query.toLowerCase())).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFA),
      bottomNavigationBar: NavBarPage(selectedIndex: 2, onTap: _navigate),
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('Tomato Leaf\nDiseases', style: TextStyle(fontSize: 26, height: 1.12, fontWeight: FontWeight.w800, color: Color(0xFF17251C)))),
              Container(width: 42, height: 42, decoration: const BoxDecoration(color: Color(0xFFE9F7EA), shape: BoxShape.circle), child: const Icon(Icons.menu_book_rounded, color: _green)),
            ]),
            const SizedBox(height: 8),
            const Text('Learn about common tomato leaf conditions and how to manage them.', style: TextStyle(color: Color(0xFF64706A), height: 1.35)),
            const SizedBox(height: 17),
            TextField(onChanged: (value) => setState(() => _query = value), decoration: InputDecoration(hintText: 'Search diseases...', prefixIcon: const Icon(Icons.search_rounded), filled: true, fillColor: const Color(0xFFF1F4F1), contentPadding: const EdgeInsets.symmetric(vertical: 0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
          ]),
        ),
        Expanded(child: items.isEmpty ? const Center(child: Text('No diseases match your search.')) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 24), itemCount: items.length, separatorBuilder: (_, _) => const SizedBox(height: 11),
          itemBuilder: (context, i) => _DiseaseCard(disease: items[i], onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DiseaseDetailPage(disease: items[i])))),
        )),
      ])),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  const _DiseaseCard({required this.disease, required this.onTap});
  final TomatoDisease disease; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(16), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(
    padding: const EdgeInsets.all(9), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEDF0ED)), boxShadow: const [BoxShadow(color: Color(0x0A142116), blurRadius: 10, offset: Offset(0, 3))]),
    child: Row(children: [_DiseaseImage(disease: disease, width: 72, height: 72), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(disease.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(height: 4), Text(disease.summary, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.25, color: Color(0xFF657069)))])), const Icon(Icons.chevron_right_rounded, color: Color(0xFF718078))]),
  )));
}

class DiseaseDetailPage extends StatefulWidget {
  const DiseaseDetailPage({super.key, required this.disease});
  final TomatoDisease disease;
  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}
class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  static const tabs = ['Overview', 'Symptoms', 'Causes', 'Management']; int selected = 0;
  @override
  Widget build(BuildContext context) {
    final d = widget.disease; final tab = tabs[selected];
    final content = switch (tab) {'Overview' => d.description, 'Symptoms' => d.symptoms, 'Causes' => d.causes, _ => d.management};
    return Scaffold(backgroundColor: const Color(0xFFFFFEFA), body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(12, 10, 16, 0), child: Row(children: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)), const Spacer(), IconButton(onPressed: () {}, tooltip: 'Save disease', icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFFE34E57)))])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_DiseaseImage(disease: d, width: double.infinity, height: 178), const SizedBox(height: 13), Text(d.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(d.scientificName, style: const TextStyle(color: Color(0xFF6B766E), fontStyle: FontStyle.italic))])),
      const SizedBox(height: 12),
      SizedBox(height: 42, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: tabs.length, separatorBuilder: (_, _) => const SizedBox(width: 7), itemBuilder: (_, i) => ChoiceChip(label: Text(tabs[i]), selected: selected == i, onSelected: (_) => setState(() => selected = i), selectedColor: const Color(0xFFDFF3E2), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)), labelStyle: TextStyle(color: selected == i ? _green : const Color(0xFF617067), fontSize: 12, fontWeight: FontWeight.w700)))),
      const Divider(height: 18, color: Color(0xFFEAEDEA)),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 2, 20, 28), children: [Text(tab == 'Overview' ? 'Description' : tab == 'Management' ? 'How to manage it' : tab, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 10), Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Text(content, style: const TextStyle(color: Color(0xFF546159), height: 1.52, fontSize: 14))), if (tab == 'Overview') ...[const SizedBox(height: 15), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFEAF7EC), borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.info_rounded, color: _green), const SizedBox(width: 10), Expanded(child: Text('Scientific name: ${d.scientificName}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF385340))))]))]])),
    ])));
  }
}

class _DiseaseImage extends StatelessWidget {
  const _DiseaseImage({required this.disease, required this.width, required this.height});
  final TomatoDisease disease; final double width, height;
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(width: width, height: height, color: disease.placeholderColor, child: Image.asset(disease.imagePath, fit: BoxFit.cover)));
}

class TomatoDisease {
  const TomatoDisease({required this.name, required this.scientificName, required this.summary, required this.description, required this.symptoms, required this.causes, required this.management, required this.imagePath, required this.placeholderColor});
  final String name, scientificName, summary, description, symptoms, causes, management, imagePath; final Color placeholderColor;
}

const tomatoDiseases = [
  TomatoDisease(name: 'Healthy Leaf', scientificName: 'Solanum lycopersicum', summary: 'Evenly green foliage without notable spots or distortion.', description: 'Healthy tomato foliage is generally medium to deep green, with natural leaf shape and no spreading patches, rings, mould, or severe curling.', symptoms: 'Even green colour, intact leaf tissue, and normal new growth.', causes: 'Not a disease. Continue monitoring: nutrient, water, pest, and disease problems can begin with subtle changes.', management: 'Water at the base, provide adequate spacing and nutrition, and inspect plants regularly for early changes.', imagePath: 'assets/image/nomer7-removebg-preview.png', placeholderColor: Color(0xFFE5F3E3)),
  TomatoDisease(name: 'Bacterial Spot', scientificName: 'Xanthomonas spp.', summary: 'Small brown spots, often with yellow halos, on leaves and fruit.', description: 'Bacterial spot affects leaves, stems, and fruit. It is especially troublesome in warm, wet conditions and can make fruit unmarketable.', symptoms: 'Small dark brown circular spots, yellow halos, and sometimes holes where spot centres drop out. Fruit may develop raised, scabby brown spots.', causes: 'Xanthomonas bacteria spread through infected seed or transplants, splashing rain or irrigation, contaminated hands, and tools.', management: 'Use clean seed and transplants, keep foliage dry, water at soil level, improve spacing, remove affected foliage, and sanitize tools. Follow local product labels if treatment is needed.', imagePath: 'assets/image/17-removebg-preview.png', placeholderColor: Color(0xFFF4E8C9)),
  TomatoDisease(name: 'Early Blight', scientificName: 'Alternaria solani', summary: 'Brown target-like spots, usually beginning on older lower leaves.', description: 'Early blight is a common fungal disease that can infect leaves, stems, and fruit. Heavy infection can lead to severe defoliation.', symptoms: 'Round brown lesions with concentric target rings, yellowing around spots, browning lower leaves, and dark leathery fruit lesions near the stem.', causes: 'Alternaria survives in infected debris and soil. It spreads when foliage stays wet from dew, rain, or overhead watering.', management: 'Remove infected leaves, mulch soil to reduce splash, water at the base, stake plants for airflow, sanitize tools, rotate crops, and use labelled fungicides only when appropriate.', imagePath: 'assets/image/28-removebg-preview.png', placeholderColor: Color(0xFFF2E7C4)),
  TomatoDisease(name: 'Septoria Leaf Spot', scientificName: 'Septoria lycopersici', summary: 'Many small circular spots with pale centres on lower leaves.', description: 'Septoria leaf spot is a fungal disease that can rapidly defoliate tomato plants, reducing vigour and exposing fruit to sunscald.', symptoms: 'Numerous small grey or tan spots with dark edges, often beginning on lower leaves; tiny black fruiting bodies may appear in spot centres.', causes: 'The fungus survives on crop debris and spreads by splashing water, wet leaves, and contaminated tools.', management: 'Remove spotted leaves, keep foliage dry, mulch soil, avoid working plants when wet, clean tools, remove debris after harvest, and rotate planting areas.', imagePath: 'assets/image/17-removebg-preview.png', placeholderColor: Color(0xFFF1E2C0)),
  TomatoDisease(name: 'Tomato Mosaic Virus', scientificName: 'Tomato mosaic virus', summary: 'Mottled light and dark green leaves with distorted growth.', description: 'Tomato mosaic virus can reduce plant vigour and fruit quality. Symptoms overlap with other tomato viruses, so laboratory testing is needed for confirmation.', symptoms: 'Light and dark green mosaic patterns, narrowed or curled leaves, distortion, stunting, uneven ripening, and reduced fruit size.', causes: 'The virus spreads mechanically through infected plants, hands, tools, and sometimes contaminated seed or tobacco products.', management: 'There is no cure. Remove suspected infected plants, wash hands, disinfect tools, avoid tobacco contact, control volunteer plants, and choose resistant varieties when available.', imagePath: 'assets/image/nomer7-removebg-preview.png', placeholderColor: Color(0xFFE5F3E3)),
  TomatoDisease(name: 'Yellow Leaf Curl Virus', scientificName: 'Tomato yellow leaf curl virus', summary: 'Upward curled yellow leaves and stunted plant growth.', description: 'Yellow leaf curl virus is a serious viral disease that can greatly reduce yield, especially when plants are infected early.', symptoms: 'Yellowing leaf margins, upward curling and cupping, smaller leaves, shortened growth, and poor fruit set.', causes: 'It is transmitted mainly by whiteflies moving from infected plants to healthy tomato plants.', management: 'There is no cure. Remove infected plants, manage whiteflies, use insect-exclusion measures where practical, remove weed hosts, and plant resistant varieties if available.', imagePath: 'assets/image/nomer7-removebg-preview.png', placeholderColor: Color(0xFFE5F3E3)),
];
