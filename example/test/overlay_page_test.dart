import 'package:example/src/module/overlay_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('custom overlay uses the MaterialApp text theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: FlExtended().navigatorKey,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const OverlayPage(),
      ),
    );

    final Finder showButton = find.text('显示自定义 Overlay');
    await tester.scrollUntilVisible(showButton, 300, scrollable: find.byType(Scrollable).first, maxScrolls: 100);
    await tester.pumpAndSettle();
    await tester.tap(showButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final BuildContext context = tester.element(find.text('Custom Overlay'));
    final TextStyle defaultStyle = DefaultTextStyle.of(context).style;
    expect(defaultStyle.fontSize, isNot(48));
    expect(defaultStyle.color, Theme.of(context).colorScheme.onSurface);

    hideAllOverlay();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
