import 'package:flutter_test/flutter_test.dart';
import 'package:complexion_ai/app/app.dart';

void main() {
  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ComplexionAIApp());
    expect(find.text('ComplexionAI'), findsAny);
  });
}
