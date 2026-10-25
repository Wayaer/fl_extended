import 'package:example/src/module/state_components_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lifecycle demo logs safely when the child is removed', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: StateComponentsPage()));

    final Finder removeButton = find.text('移除子组件');
    await tester.scrollUntilVisible(removeButton, 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    await tester.tap(removeButton);
    await tester.pump();
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('重新挂载子组件'));
    await tester.pump();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
