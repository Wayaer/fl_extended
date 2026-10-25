import 'package:example/src/module/universal_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hero flight shuttle text uses an explicit style', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: FlExtended().navigatorKey,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const UniversalPage(),
      ),
    );
    await tester.pumpAndSettle();

    final Finder open = find.text('打开 Hero 目标页');
    await tester.scrollUntilVisible(open, 400, scrollable: find.byType(Scrollable).first, maxScrolls: 100);
    await tester.pumpAndSettle();
    await tester.tap(open);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final Finder flying = find.text('Flying');
    expect(flying, findsOneWidget);
    final Text text = tester.widget<Text>(flying);
    expect(text.style?.fontSize, 16);
    expect(text.style?.color, Colors.black);

    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
