import 'package:example/src/module/universal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('each gesture family has its own latest gesture hint', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const UniversalPage(),
      ),
    );
    await tester.pumpAndSettle();

    final Finder tapTile = find.text('Tap / Double Tap / Cancel');
    await tester.scrollUntilVisible(tapTile, 400, scrollable: find.byType(Scrollable).first, maxScrolls: 100);
    await tester.pumpAndSettle();
    expect(find.text('最近手势：暂无手势'), findsNWidgets(8));

    await tester.tap(tapTile);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('最近手势：onTap'), findsOneWidget);
    expect(find.text('最近手势：暂无手势'), findsNWidgets(7));
    expect(tester.takeException(), isNull);
  });
}
