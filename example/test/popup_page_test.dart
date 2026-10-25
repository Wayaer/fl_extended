import 'package:example/src/module/popup_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPopupPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: FlExtended().navigatorKey,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const PopupPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openItem(WidgetTester tester, String buttonText) async {
    final Finder button = find.text(buttonText);
    await tester.scrollUntilVisible(button, 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  void expectThemedText(WidgetTester tester, String text) {
    final BuildContext context = tester.element(find.text(text));
    final TextStyle style = DefaultTextStyle.of(context).style;
    expect(style.fontSize, isNot(48));
    expect(style.color, Theme.of(context).colorScheme.onSurface);
  }

  testWidgets('general dialog title uses the theme text style', (WidgetTester tester) async {
    await pumpPopupPage(tester);
    await openItem(tester, '选择并返回');
    expectThemedText(tester, '选择一个结果');

    final Finder card = find.ancestor(of: find.text('选择一个结果'), matching: find.byType(Universal)).first;
    expect(tester.getSize(card).height, lessThan(200), reason: '弹窗应按内容高度显示，而不是撑满全屏');

    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('cupertino modal title uses the theme text style', (WidgetTester tester) async {
    await pumpPopupPage(tester);
    await openItem(tester, '打开 Cupertino 弹层');
    expectThemedText(tester, 'CupertinoModalPopup');

    final Finder card = find.ancestor(of: find.text('CupertinoModalPopup'), matching: find.byType(Universal)).first;
    expect(tester.getSize(card).height, lessThan(200), reason: '弹层应按内容高度显示，而不是撑满全屏');

    await tester.tap(find.text('关闭'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
