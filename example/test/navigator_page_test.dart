import 'package:example/src/module/navigator_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('material and cupertino routes open different pages', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: FlExtended().navigatorKey,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const NavigatorPage(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('push Material'));
    await tester.pumpAndSettle();
    expect(find.text('Material 风格页面'), findsOneWidget);
    await tester.tap(find.text('pop 返回结果'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('push Cupertino'));
    await tester.pumpAndSettle();
    expect(find.text('Cupertino 风格页面'), findsOneWidget);
    final BuildContext cupertinoContext = tester.element(find.text('Cupertino 风格页面'));
    final TextStyle defaultStyle = DefaultTextStyle.of(cupertinoContext).style;
    expect(defaultStyle.decoration, isNot(TextDecoration.underline));
    expect(defaultStyle.fontSize, isNot(48));
    await tester.tap(find.text('pop 返回结果'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
