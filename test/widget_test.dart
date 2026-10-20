import 'package:flutter_test/flutter_test.dart';
import 'package:tomato_leaf_diseases/main.dart';

void main() {
  testWidgets('onboarding opens with the first message', (tester) async {
    await tester.pumpWidget(const TomatoCareApp());

    expect(find.text('Detect. Understand.\nProtect.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });
}
