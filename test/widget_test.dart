import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sap/main.dart';

void main() {
  testWidgets('App launches and shows the Hazıredim screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SapPpApp()));
    await tester.pumpAndSettle();

    expect(
      find.text('Hazıredim — Malzeme İhtiyaç Kontrolü'),
      findsOneWidget,
    );
  });
}
