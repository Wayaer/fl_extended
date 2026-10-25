import 'dart:async';
import 'dart:convert';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iterable', () {
    test('elementAtOrNull', () {
      expect(<int>[1, 2].elementAtOrNull(1), 2);
      expect(<int>[1, 2].elementAtOrNull(5), isNull);
      expect(<int>[1, 2].elementAtOrNull(-1), isNull);
    });

    test('firstOrNull / lastOrNull', () {
      expect(<int>[1, 2].firstOrNull, 1);
      expect(<int>[].firstOrNull, isNull);
      expect(<int>[1, 2].lastOrNull, 2);
      expect(<int>[].lastOrNull, isNull);
    });

    test('chunked works lazily and pads', () {
      expect(Iterable<int>.generate(5).chunked(2).toList(), [
        [0, 1],
        [2, 3],
        [4],
      ]);
      expect(<int>[1, 2, 3].chunked(2, fill: () => 99).toList(), [
        [1, 2],
        [3, 99],
      ]);
      expect(() => <int>[1].chunked(0), throwsArgumentError);
    });

    test('count / containsAny / none', () {
      expect(<int>[1, 2, 3, 14].count((int n) => n > 9), 1);
      expect(<int>[1, 2, 3].containsAny(<int>[5, 2]), isTrue);
      expect(<int>[1, 2, 3].containsAny(<int>[5, 6]), isFalse);
      expect(<int>[1, 2].none((int n) => n > 3), isTrue);
    });

    test('mapIndexed uses (index, element) order', () {
      expect(<int>[10, 20].mapIndexed((int index, int value) => '$index:$value').toList(), ['0:10', '1:20']);
    });

    test('containsAny is lazy for endless iterables', () {
      Iterable<int> endless() sync* {
        var value = 0;
        while (true) {
          yield value++;
        }
      }

      expect(<int>[2].containsAny(endless()), isTrue);
      expect(<int>[].containsAny(endless()), isFalse);
      expect(<int>[1, 2, 3].containsAny(const <int>[]), isFalse);
    });

    test('pickOne / pickSome handle empty and invalid counts', () {
      expect(<int>[].pickOne(), isNull);
      expect(<int>[7].pickOne(), 7);
      expect(<int>[1, 2, 3].pickSome(0), isEmpty);
      expect(<int>[1, 2, 3].pickSome(-1), isEmpty);
      expect(<int>[].pickSome(2), isEmpty);
      final List<int> picked = <int>[1, 2, 3].pickSome(10);
      expect(picked.toSet(), <int>{1, 2, 3});
      expect(picked.length, 3);
    });

    test('sortedWith / sortedByNum / sortedByString', () {
      expect(<int>[2, 1, 3].sortedWith((int a, int b) => a.compareTo(b)), [1, 2, 3]);
      expect(<int>[2, 1, 3].sortedByNum((int n) => n), [1, 2, 3]);
      expect(<String>['c', 'a', 'b'].sortedByString((String s) => s), ['a', 'b', 'c']);
    });
  });

  group('num', () {
    test('max / min support mixed int and double', () {
      expect(1.max(2.5), 2.5);
      expect(2.5.min(1), 1);
    });

    test('contains forwards startIndex', () {
      expect(12345.contains('1', 2), isFalse);
      expect(12345.contains('3', 2), isTrue);
    });

    test('toBigInt is non-nullable', () {
      expect(1.toBigInt, BigInt.one);
    });

    test('toStorageUnit rounds across unit boundary', () {
      expect(1024.toStorageUnit(), '1 KB');
      expect(1536.toStorageUnit(), '1.5 KB');
      expect((1024 * 1024 - 1).toStorageUnit(), '1 MB');
    });

    test('toFileSize supports larger units', () {
      expect(1024.toFileSize(), '1KB');
      expect(1536.toFileSize(), '1.5KB');
      expect((1024 * 1024 * 1024 * 1024).toFileSize(), '1TB');
    });

    test('timestamps convert without digit-length filtering', () {
      final DateTime date = DateTime(2026, 10, 24, 12, 34, 56);
      expect(date.millisecondsSinceEpoch.fromMillisecondsSinceEpoch(), date);
      expect(date.microsecondsSinceEpoch.fromMicrosecondsSinceEpoch(), date);
      expect(5.fromMillisecondsSinceEpoch(), DateTime.fromMillisecondsSinceEpoch(5));
    });

    test('random handles non-positive values', () {
      expect(0.random, 0);
      expect((-1).random, 0);
      expect(10.random, inInclusiveRange(0, 9));
    });
  });

  group('string', () {
    test('base64 normalize forwards start/end', () {
      expect('Y-Q='.base64Normalize(0, 2), base64.normalize('Y-Q=', 0, 2));
      expect('Y-Q='.base64UrlNormalize(0, 2), base64Url.normalize('Y-Q=', 0, 2));
    });

    test('formatDigitPattern handles multi-char pattern', () {
      expect('12345678'.formatDigitPattern(pattern: '--'), '1234--5678');
      expect('12345678'.formatDigitPatternEnd(pattern: '-'), '1234-5678');
    });

    test('utf8 list round trip keeps non-ascii', () {
      expect('中文'.utf8ToList.toUtf8, '中文');
      expect(utf8.encode('中文').toUtf8, '中文');
    });

    test('isChinaPhone rejects comma', () {
      expect('13800138000'.isChinaPhone, isTrue);
      expect('15,12345678'.isChinaPhone, isFalse);
    });

    test('fromHex supports shorthand', () {
      expect('#abc'.fromHex, const Color(0xFFAABBCC));
      expect('#11223344'.fromHex, const Color(0x11223344));
      expect(() => 'zz'.fromHex, throwsFormatException);
      expect(() => 'aa#bbcc'.fromHex, throwsFormatException);
    });

    test('remove prefix / suffix length clamps out-of-range values', () {
      expect('abc'.removePrefixLength(10), '');
      expect('abc'.removeSuffixLength(10), '');
      expect('abc'.removePrefixLength(-1), 'abc');
      expect('abc'.removeSuffixLength(-1), 'abc');
    });
  });

  group('list', () {
    test('uint8 list packing round trip with byteLength', () {
      final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3]);
      final List<int> packed = bytes.bit32ListFromUInt8List();
      expect(packed.uInt8ListFrom32BitList(bytes.length).toList(), <int>[1, 2, 3]);
      expect(packed.uInt8ListFrom32BitList().length, 4);
    });

    test('uint8 list rejects invalid byteLength', () {
      final List<int> packed = Uint8List.fromList(<int>[1, 2, 3]).bit32ListFromUInt8List();
      expect(() => packed.uInt8ListFrom32BitList(-1), throwsArgumentError);
      expect(() => packed.uInt8ListFrom32BitList(packed.length * 4 + 1), throwsArgumentError);
    });

    test('slice clamps bounds and removeElement works', () {
      expect(<int>[1, 2, 3].slice(1, 99), <int>[2, 3]);
      expect(<int>[1, 2, 3].slice(99), isEmpty);
      final List<int> list = <int>[1, 2, 3, 4];
      list.removeElement((int n) => n.isEven);
      expect(list, <int>[1, 3]);
    });
  });

  group('map', () {
    test('keyToString converts nested dynamic collections', () {
      final Map<dynamic, dynamic> map = <dynamic, dynamic>{
        'list': <dynamic>[
          <int, String>{1: 'a'},
        ],
        'nested': <dynamic, dynamic>{
          'inner': <int, int>{2: 3},
        },
      };
      expect(map.keyToString, <String, dynamic>{
        'list': [
          <String, String>{'1': 'a'},
        ],
        'nested': {
          'inner': <String, int>{'2': 3},
        },
      });
    });

    test('keyToString rejects cyclic structures', () {
      final Map<String, dynamic> map = <String, dynamic>{};
      map['self'] = map;
      expect(() => map.keyToString, throwsArgumentError);
    });

    test('FlListenableBinder rejects a second key', () {
      final Object firstKey = Object();
      final Object secondKey = Object();
      final FlListenableBinder<int> binder = FlListenableBinder<int>();
      addTearDown(() => binder.clearAllChangedListeners((VoidCallback _) {}));
      expect(
        binder.addWeakListener<Object>(
          key: firstKey,
          listener: (int _) {},
          getValue: (Object _) => 0,
          onAddListener: (VoidCallback _) {},
          onRemoveListener: (VoidCallback _) {}
        ),
        isTrue
      );
      expect(
        () => binder.addWeakListener<Object>(
          key: secondKey,
          listener: (int _) {},
          getValue: (Object _) => 1,
          onAddListener: (VoidCallback _) {},
          onRemoveListener: (VoidCallback _) {}
        ),
        throwsArgumentError
      );
    });
  });

  group('dateTime', () {
    test('millisecond format is three digits', () {
      expect(DateTime(2020, 1, 1, 8, 9, 10, 5).format(DateTimeDist.yearMillisecond), '2020-01-01 08:09:10.005');
    });

    test('getDaysForRange is date-only and inclusive', () {
      final List<DateTime> days = DateTime(2020, 1, 1, 12).getDaysForRange(DateTime(2020, 1, 3, 6));
      expect(days, <DateTime>[DateTime(2020), DateTime(2020, 1, 2), DateTime(2020, 1, 3)]);
      expect(DateTime(2020, 1, 2, 12).getDaysForRange(DateTime(2020, 1, 1, 18)), isEmpty);
    });
  });

  group('object', () {
    test('log prints exactly limit-length messages', () {
      final List<String> lines = <String>[];
      final DebugPrintCallback original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) lines.add(message);
      };
      addTearDown(() => debugPrint = original);
      FlExtended().logCrossLine = false;
      ('a' * 800).log();
      expect(lines.join().length, 800);
    });
  });

  group('controller', () {
    test('insert text without selection', () {
      final TextEditingController controller = TextEditingController(text: 'abc');
      addTearDown(controller.dispose);
      expect(controller.selection.isValid, isFalse);
      controller.addTextAfterCursor('X');
      expect(controller.text, 'abcX');
      controller.value = const TextEditingValue(text: 'abc', selection: TextSelection(baseOffset: 1, extentOffset: 1));
      controller.addTextBeforeCursor('Y');
      expect(controller.text, 'aYbc');
    });
  });

  group('function', () {
    testWidgets('FlDebouncer delays and can be disposed', (WidgetTester tester) async {
      var count = 0;
      final FlDebouncer debouncer = FlDebouncer(() => count++, delay: const Duration(milliseconds: 300));
      addTearDown(debouncer.dispose);
      debouncer();
      await tester.pump(const Duration(milliseconds: 100));
      debouncer();
      await tester.pump(const Duration(milliseconds: 200));
      expect(count, 0);
      await tester.pump(const Duration(milliseconds: 150));
      expect(count, 1);
    });

    testWidgets('FlThrottler ignores calls inside delay', (WidgetTester tester) async {
      var count = 0;
      final FlThrottler throttler = FlThrottler(() => count++, delay: const Duration(milliseconds: 300));
      addTearDown(throttler.dispose);
      throttler();
      throttler();
      expect(count, 1);
      await tester.pump(const Duration(milliseconds: 350));
      throttler();
      expect(count, 2);
      throttler.dispose();
    });
  });

  group('logcat', () {
    test('runZone forwards custom print handler and zoneValues', () {
      final Object zoneKey = Object();
      Object? zoneValue;
      var printCalls = 0;
      FlLogcat().runZone(
        () {
          zoneValue = Zone.current[zoneKey];
          // ignore: avoid_print
          print('fl_logcat_test');
        },
        zoneValues: <Object?, Object?>{zoneKey: 'ok'},
        zoneSpecification: ZoneSpecification(
          print: (Zone self, ZoneDelegate parent, Zone zone, String line) => printCalls++,
        ),
      );
      expect(zoneValue, 'ok');
      expect(printCalls, 1);
    });
  });
}
