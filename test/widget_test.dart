import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sap/main.dart';

void main() {
  testWidgets('App launches and shows the FAZ 1 placeholder screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SapPpApp()));
    await tester.pumpAndSettle();

    expect(find.text('SAP PP - Tekstil Üretim Planlama (FAZ 1)'), findsOneWidget);
    expect(find.text('Classic SAP GUI'), findsOneWidget);
    expect(find.text('Modern ERP'), findsOneWidget);
  });
}
