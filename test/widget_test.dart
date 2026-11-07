import 'package:flutter_test/flutter_test.dart';
import 'package:uts_2415051040_kynan/main.dart';

void main() {
  testWidgets('MotoRent App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
