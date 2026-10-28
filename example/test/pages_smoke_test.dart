import 'package:example/src/home.dart';
import 'package:example/src/module/animation_page.dart';
import 'package:example/src/module/auto_size_text_page.dart';
import 'package:example/src/module/builder_page.dart';
import 'package:example/src/module/button_page.dart';
import 'package:example/src/module/context_page.dart';
import 'package:example/src/module/controller_page.dart';
import 'package:example/src/module/date_time_page.dart';
import 'package:example/src/module/function_page.dart';
import 'package:example/src/module/iterable_page.dart';
import 'package:example/src/module/list_map_page.dart';
import 'package:example/src/module/logcat_page.dart';
import 'package:example/src/module/navigator_page.dart';
import 'package:example/src/module/num_page.dart';
import 'package:example/src/module/object_page.dart';
import 'package:example/src/module/overlay_page.dart';
import 'package:example/src/module/popup_page.dart';
import 'package:example/src/module/progress_indicator_page.dart';
import 'package:example/src/module/regexp_page.dart';
import 'package:example/src/module/state_components_page.dart';
import 'package:example/src/module/string_page.dart';
import 'package:example/src/module/text_page.dart';
import 'package:example/src/module/universal_page.dart';
import 'package:example/src/module/widget_extension_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Map<String, Widget> pages = <String, Widget>{
    'HomePage': const HomePage(),
    'TextPage': const TextPage(),
    'AutoSizeTextPage': const AutoSizeTextPage(),
    'ButtonPage': const ButtonPage(),
    'UniversalPage': const UniversalPage(),
    'AnimationPage': const AnimationPage(),
    'ProgressIndicatorPage': const ProgressIndicatorPage(),
    'RegExpPage': const RegExpPage(),
    'BuilderPage': const BuilderPage(),
    'StateComponentsPage': const StateComponentsPage(),
    'OverlayPage': const OverlayPage(),
    'PopupPage': const PopupPage(),
    'NavigatorPage': const NavigatorPage(),
    'StringPage': const StringPage(),
    'NumberPage': const NumberPage(),
    'IterablePage': const IterablePage(),
    'ListMapPage': const ListMapPage(),
    'DateTimePage': const DateTimePage(),
    'ObjectPage': const ObjectPage(),
    'ContextPage': const ContextPage(),
    'WidgetExtensionPage': const WidgetExtensionPage(),
    'ControllerPage': const ControllerPage(),
    'FunctionPage': const FunctionPage(),
    'LogcatPage': const LogcatPage(),
  };

  final List<(Size, double)> layouts = <(Size, double)>[
    (const Size(1170, 2532), 3), // 390 x 844 phone
    (const Size(2048, 1536), 2), // 1024 x 768 tablet
  ];

  for (final (Size physicalSize, double pixelRatio) in layouts) {
    for (final MapEntry<String, Widget> entry in pages.entries) {
      testWidgets('${entry.key} renders at ${physicalSize.width ~/ pixelRatio}x${physicalSize.height ~/ pixelRatio}', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = physicalSize;
        tester.view.devicePixelRatio = pixelRatio;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: FlExtended().navigatorKey,
            scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
            home: entry.value,
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull, reason: '${entry.key} 首次渲染异常');

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 3));
        expect(tester.takeException(), isNull, reason: '${entry.key} 销毁时异常');
      });
    }
  }

  testWidgets('UniversalPage renders every section in a tall viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 24000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: FlExtended().navigatorKey,
        scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4E6BFF)),
        home: const UniversalPage(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull, reason: 'UniversalPage 全部示例渲染异常');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull, reason: 'UniversalPage 全部示例销毁异常');
  });
}
