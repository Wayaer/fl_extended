import 'dart:async';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(hideAllOverlay);

  test('navigatorState throws when the key is not attached', () {
    expect(() => FlExtended().navigatorState, throwsStateError);
  });

  group('context / widget extensions', () {
    testWidgets('padding and statusBarStyle do not duplicate GlobalKey', (WidgetTester tester) async {
      final GlobalKey paddingKey = GlobalKey();
      final GlobalKey statusKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Text('a', key: paddingKey).padding(EdgeInsets.zero),
              Text('b', key: statusKey).statusBarStyle(const SystemUiOverlayStyle()),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('setPreferredHeight keeps key', (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      expect(const SizedBox().setPreferredHeight(10, key: key).key, same(key));
      expect(const SizedBox().setPreferredSize(const Size(10, 20), key: key).key, same(key));
    });

    testWidgets('maybePop forwards result', (WidgetTester tester) async {
      late Future<Object?> result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) => TextButton(
              onPressed: () {
                result = Navigator.of(context).push<Object?>(
                  MaterialPageRoute<Object?>(
                    builder: (BuildContext context) =>
                        TextButton(onPressed: () => context.maybePop(42), child: const Text('pop')),
                  ),
                );
              },
              child: const Text('push'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('pop'));
      await tester.pumpAndSettle();
      expect(await result, 42);
    });

    testWidgets('requestFocus without node closes keyboard focus', (WidgetTester tester) async {
      final FocusNode focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) => TextField(focusNode: focusNode, autofocus: true)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      final BuildContext context = tester.element(find.byType(TextField));
      context.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('screenshots returns null for non RepaintBoundary', (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(MaterialApp(home: Text('not a boundary', key: key)));
      expect(await key.screenshots(), isNull);
    });
  });

  group('builders', () {
    testWidgets('CustomStreamBuilder completes empty streams', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomStreamBuilder<int>(
            stream: const Stream<int>.empty(),
            onWaiting: (_) => const Text('waiting'),
            onDone: (_, int? value) => Text('done:$value'),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('done:null'), findsOneWidget);
    });

    testWidgets('CustomFutureBuilder reports synchronous throws', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomFutureBuilder<int>(
            future: () => throw StateError('sync'),
            onWaiting: (_) => const Text('waiting'),
            onDone: (_, int value, Function reset) => const Text('done'),
            onError: (_, Object? error, Function reset) => Text('$error'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('sync'), findsOneWidget);
    });

    testWidgets('CustomStreamBuilder resubscribes when stream changes', (WidgetTester tester) async {
      final ValueNotifier<bool> notifier = ValueNotifier<bool>(false);
      addTearDown(notifier.dispose);
      final Stream<int> first = Stream<int>.value(1);
      final Stream<int> second = Stream<int>.value(2);
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (_, bool useSecond, _) =>
                CustomStreamBuilder<int>(stream: useSecond ? second : first, onDone: (_, int? value) => Text('$value')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      notifier.value = true;
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });
  });

  group('overlay / popup options', () {
    testWidgets('ToastOptions.copyWith keeps plain profile', (WidgetTester tester) async {
      const ToastOptions options = ToastOptions(duration: Duration(seconds: 1));
      final ToastOptions copy = options.copyWith();
      expect(copy.padding, isNull);
      expect(copy.color, isNull);
    });

    testWidgets('ToastContent color applies to text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ToastContent(text: 'x', color: Colors.red),
        ),
      );
      final Text text = tester.widget<Text>(find.text('x'));
      expect(text.style?.color, Colors.red);
    });

    testWidgets('Loading absorbs background taps', (WidgetTester tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: FlExtended().navigatorKey,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: TextButton(onPressed: () => tapped++, child: const Text('under')),
            ),
          ),
        ),
      );
      showLoading();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('under'), warnIfMissed: false);
      await tester.pump();
      hideLoading();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tapped, 0);
    });

    testWidgets('fromCenter uses fade transition', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      final Widget built = PopupFromStyle.fromCenter.transitionBuilder(
        tester.element(find.byType(MaterialApp)),
        const AlwaysStoppedAnimation<double>(0.5),
        const AlwaysStoppedAnimation<double>(1),
        const SizedBox(),
      );
      expect(built, isA<FadeTransition>());
    });

    test('ModalBottomSheetOptions merge keeps useSafeArea', () {
      const ModalBottomSheetOptions base = ModalBottomSheetOptions();
      const ModalBottomSheetOptions options = ModalBottomSheetOptions(useSafeArea: false);
      expect(base.merge(options).useSafeArea, isFalse);
    });
  });

  group('overlay lifecycle', () {
    testWidgets('cached overlays stack when no id is given', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      FlOverlay().show(const SizedBox());
      FlOverlay().show(const SizedBox());
      expect(FlOverlay().overlayEntries.length, 2);
    });

    testWidgets('hide closes the topmost overlay', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      unawaited(showToast('top-test', duration: const Duration(seconds: 10)));
      await tester.pump();
      FlOverlay().show(const SizedBox(), id: 'top');
      FlOverlay().hide();
      expect(FlOverlay().overlayEntries.where((FlOverlayEntry entry) => entry.id == 'top'), isEmpty);
      expect(FlOverlay().toast, isNotNull);
      FlOverlay().hide();
      expect(FlOverlay().toast, isNull);
    });

    testWidgets('showToast respects the explicit duration', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      unawaited(showToast('short', duration: const Duration(milliseconds: 100), animationStyle: FlAnimationStyle.fade));
      await tester.pump();
      expect(FlOverlay().toast, isNotNull);
      await tester.pump(const Duration(milliseconds: 150));
      expect(FlOverlay().toast, isNull);
    });

    testWidgets('cached overlay replaces entries with the same id', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      final FlOverlayEntry? first = FlOverlay().show(const SizedBox(), id: 'same');
      final FlOverlayEntry? second = FlOverlay().show(const SizedBox(), id: 'same');
      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(FlOverlay().overlayEntries, <FlOverlayEntry>[second!]);
      expect(FlOverlay().toast, isNull);
    });

    testWidgets('removing a cached overlay before it mounts keeps it hidden', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      final FlOverlayEntry? entry = FlOverlay().show(const Text('pending'), id: 'pending');
      entry!.remove();
      await tester.pump();
      expect(find.text('pending'), findsNothing);
      expect(FlOverlay().overlayEntries, isEmpty);
    });

    testWidgets('detached cached overlays are dropped', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      FlOverlay().show(const SizedBox(), id: 'detached');
      await tester.pump();
      expect(FlOverlay().hasOverlay, isTrue);
      await tester.pumpWidget(const MaterialApp(home: Text('new root')));
      await tester.pump();
      expect(FlOverlay().overlayEntries, isEmpty);
      expect(FlOverlay().hasOverlay, isFalse);
    });

    testWidgets('Loading keeps the circular indicator square under minWidth', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      showLoading(options: const LoadingOptions(constraints: BoxConstraints(minWidth: 120)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.getSize(find.byType(CircularProgressIndicator)), const Size(36, 36));
      hideLoading();
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('custom overlay provides a themed default text style', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      FlOverlay().show(const Text('raw overlay'), id: 'raw-overlay-text');
      await tester.pump();
      final BuildContext context = tester.element(find.text('raw overlay'));
      final TextStyle style = DefaultTextStyle.of(context).style;
      expect(style.color, Theme.of(context).colorScheme.onSurface);
      expect(style.fontSize, isNot(48));
      FlOverlay().hideAll();
      await tester.pump();
    });

    testWidgets('general dialog provides a themed default text style', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      unawaited(const Text('raw general dialog').popupGeneralDialog<String>());
      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('raw general dialog'));
      final TextStyle style = DefaultTextStyle.of(context).style;
      expect(style.color, Theme.of(context).colorScheme.onSurface);
      expect(style.fontSize, isNot(48));
      unawaited(closePopup());
      await tester.pumpAndSettle();
    });

    testWidgets('cupertino modal provides a themed default text style', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      unawaited(const Text('raw cupertino modal').popupCupertinoModal<String>());
      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.text('raw cupertino modal'));
      final TextStyle style = DefaultTextStyle.of(context).style;
      expect(style.color, Theme.of(context).colorScheme.onSurface);
      expect(style.fontSize, isNot(48));
      unawaited(closePopup());
      await tester.pumpAndSettle();
    });

    testWidgets('showToast future completes when hidden manually', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(navigatorKey: FlExtended().navigatorKey, home: const SizedBox()));
      final Future<FlOverlayEntry?> future = showToast('hello', duration: const Duration(seconds: 10));
      await tester.pump();
      expect(FlOverlay().toast, isNotNull);
      hideToast();
      expect(await future, isNotNull);
      await tester.pump(const Duration(milliseconds: 400));
    });
  });

  group('components', () {
    testWidgets('FlAutoSizeTextBuilder renders WidgetSpan without auto sizing', (WidgetTester tester) async {
      late FlAutoSizeTextData captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: FlAutoSizeTextBuilder(
                const TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: 'hello '),
                    WidgetSpan(child: Icon(Icons.star, size: 16)),
                  ],
                ),
                style: const TextStyle(fontSize: 30),
                options: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 30),
                builder: (BuildContext context, FlAutoSizeTextData data) {
                  captured = data;
                  return Text.rich(data.textSpan, style: data.style);
                },
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(captured.style.fontSize, 30);
      expect(captured.textSpan.toPlainText(), contains('\uFFFC'));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('FlAutoSizeTextBuilder shrinks text to fit the available width', (WidgetTester tester) async {
      double? fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 40,
              child: FlAutoSizeTextBuilder(
                const TextSpan(text: 'abcdefghij'),
                style: const TextStyle(fontSize: 30),
                options: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 30),
                layout: const FlAutoSizeTextLayout(maxLines: 1),
                builder: (BuildContext context, FlAutoSizeTextData data) {
                  fontSize = data.style.fontSize;
                  return Text.rich(data.textSpan, style: data.style, maxLines: data.maxLines);
                },
              ),
            ),
          ),
        ),
      );
      expect(fontSize, 10);
    });

    testWidgets('FlAutoSizeTextBuilder picks the largest fitting preset font size', (WidgetTester tester) async {
      double? fontSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 250,
              height: 40,
              child: FlAutoSizeTextBuilder(
                const TextSpan(text: 'abcdefghij'),
                style: const TextStyle(fontSize: 30),
                options: const FlAutoSizeOptions(presetFontSizes: <double>[30, 20, 10]),
                layout: const FlAutoSizeTextLayout(maxLines: 1),
                builder: (BuildContext context, FlAutoSizeTextData data) {
                  fontSize = data.style.fontSize;
                  return Text.rich(data.textSpan, style: data.style, maxLines: data.maxLines);
                },
              ),
            ),
          ),
        ),
      );
      expect(fontSize, 20);
    });

    testWidgets('FlAutoSizeTextBuilder shows overflowReplacement when nothing fits', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 50,
              height: 40,
              child: FlAutoSizeTextBuilder(
                const TextSpan(text: 'abcdefghij'),
                style: const TextStyle(fontSize: 30),
                options: const FlAutoSizeOptions(minFontSize: 20, maxFontSize: 30, overflowReplacement: Text('放不下')),
                layout: const FlAutoSizeTextLayout(maxLines: 1),
                builder: (BuildContext context, FlAutoSizeTextData data) => Text.rich(data.textSpan, style: data.style),
              ),
            ),
          ),
        ),
      );
      expect(find.text('放不下'), findsOneWidget);
    });

    testWidgets('FlAutoSizeTextBuilder syncs font size through FlAutoSizeGroup', (WidgetTester tester) async {
      final FlAutoSizeGroup group = FlAutoSizeGroup();
      double? wideFontSize;
      double? narrowFontSize;
      FlAutoSizeTextBuilder builder({required ValueSetter<FlAutoSizeTextData> onData}) {
        return FlAutoSizeTextBuilder(
          const TextSpan(text: 'abcdefghij'),
          style: const TextStyle(fontSize: 30),
          options: FlAutoSizeOptions(minFontSize: 4, maxFontSize: 30, group: group),
          layout: const FlAutoSizeTextLayout(maxLines: 1),
          builder: (BuildContext context, FlAutoSizeTextData data) {
            onData(data);
            return Text.rich(data.textSpan, style: data.style, maxLines: data.maxLines);
          },
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 40,
                  child: builder(onData: (FlAutoSizeTextData data) => wideFontSize = data.style.fontSize),
                ),
                SizedBox(
                  width: 60,
                  height: 40,
                  child: builder(onData: (FlAutoSizeTextData data) => narrowFontSize = data.style.fontSize),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(wideFontSize, 6);
      expect(narrowFontSize, 6);
    });

    testWidgets('Universal builds disabled button without callbacks', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Universal(buttonCategory: FlButtonCategory.elevated, child: const Text('disabled')),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('FlAnimation cancels a delayed start on dispose', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlAnimation(style: FlAnimationStyle.fade, delayDuration: Duration(seconds: 5), child: SizedBox()),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      expect(tester.takeException(), isNull);
    });

    test('ProgressIndicatorOptions.refresh forwards width/height', () {
      const ProgressIndicatorOptions options = ProgressIndicatorOptions.refresh(width: 80, height: 80);
      expect(options.width, 80);
      expect(options.height, 80);
      expect(options.style, ProgressIndicatorStyle.refresh);
    });

    testWidgets('refresh honors width/height and stays square', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FlProgressIndicator(
                ProgressIndicatorOptions.refresh(
                  width: 80,
                  height: 80,
                  value: 0.5,
                  indicatorMargin: EdgeInsets.all(8),
                  indicatorPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(find.byType(FlProgressIndicator)), const Size(80, 80));
      final Size refreshSize = tester.getSize(find.byType(RefreshProgressIndicator));
      expect(refreshSize, const Size(80, 80));
      expect(tester.takeException(), isNull);
    });

    testWidgets('circular indicator stays square under non-square constraints', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: const FlProgressIndicator(ProgressIndicatorOptions.circular()),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(find.byType(CircularProgressIndicator)), const Size(36, 36));
      expect(tester.takeException(), isNull);
    });

    testWidgets('circular indicator honors explicit square size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: FlProgressIndicator(ProgressIndicatorOptions.circular(width: 80, height: 80))),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(find.byType(CircularProgressIndicator)), const Size(80, 80));
      expect(tester.takeException(), isNull);
    });

    testWidgets('RefreshProgressIndicator stays square under tight width', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: FlProgressIndicator(
                ProgressIndicatorOptions.refresh(
                  width: 80,
                  height: 80,
                  value: 0.5,
                  indicatorMargin: EdgeInsets.all(8),
                  indicatorPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      final Size size = tester.getSize(find.byType(RefreshProgressIndicator));
      expect(size.width, size.height);
      expect(tester.takeException(), isNull);
    });
  });

  group('ActionDialog', () {
    testWidgets('divider and actions keep a finite height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: ActionDialog(
              title: const Text('标题'),
              content: const Text('内容'),
              dividerColor: Colors.grey,
              actions: [
                Expanded(child: const Text('取消')),
                Expanded(child: const Text('确定')),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsOneWidget);
    });
  });
}
