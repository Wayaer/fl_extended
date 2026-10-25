import 'package:example/src/module/progress_indicator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('refresh indicator in page stays square', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: ProgressIndicatorPage()));
    await tester.scrollUntilVisible(find.text('refresh'), 400, scrollable: find.byType(Scrollable).first);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 1600));
    final Finder refresh = find.byType(RefreshProgressIndicator);
    final Size size = tester.getSize(refresh);
    expect(size.width, size.height);
    expect(size.width, lessThanOrEqualTo(80));
    expect(tester.takeException(), isNull);
  });
}
