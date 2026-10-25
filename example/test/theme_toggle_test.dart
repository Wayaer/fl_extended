import 'package:example/src/demo/demo_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => demoThemeMode.value = ThemeMode.system);

  testWidgets('DemoThemeToggle switches light and dark', (WidgetTester tester) async {
    demoThemeMode.value = ThemeMode.light;
    await tester.pumpWidget(
      ValueListenableBuilder<ThemeMode>(
        valueListenable: demoThemeMode,
        builder: (BuildContext context, ThemeMode mode, Widget? child) {
          return MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: mode,
            home: Scaffold(
              appBar: AppBar(actions: const <Widget>[DemoThemeToggle()]),
              body: const SizedBox(),
            ),
          );
        },
      ),
    );

    BuildContext appContext = tester.element(find.byType(Scaffold));
    expect(Theme.of(appContext).brightness, Brightness.light);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);

    await tester.tap(find.byType(DemoThemeToggle));
    await tester.pumpAndSettle();
    appContext = tester.element(find.byType(Scaffold));
    expect(demoThemeMode.value, ThemeMode.dark);
    expect(Theme.of(appContext).brightness, Brightness.dark);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

    await tester.tap(find.byType(DemoThemeToggle));
    await tester.pumpAndSettle();
    expect(demoThemeMode.value, ThemeMode.light);
  });
}
