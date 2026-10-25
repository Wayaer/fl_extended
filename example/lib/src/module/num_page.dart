import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class NumberPage extends StatelessWidget {
  const NumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Number',
      description: 'num / int 扩展：数学函数、判断、时长、存储单位、日期时间戳，以及大量尺寸与边距快捷属性。',
      sections: [
        DemoSection(
          title: '数学与判断',
          children: [
            DemoItem(
              title: '比较与判断',
              code: r"""
1.max(2.5);        // 2.5
2.5.min(1);        // 1
4.isEven;          // true
3.isOdd;           // true
(-1).isNegative;   // true
9.sqrt;            // 3.0
""",
              child: DemoValues([
                DemoValue('1.max(2.5)', '${1.max(2.5)}'),
                DemoValue('2.5.min(1)', '${2.5.min(1)}'),
                DemoValue('4.isEven', '${4.isEven}'),
                DemoValue('3.isOdd', '${3.isOdd}'),
                DemoValue('(-1).isNegative', '${(-1).isNegative}'),
                DemoValue('9.sqrt', '${9.sqrt}'),
                DemoValue('2.ln.toStringAsFixed(4)', 2.ln.toStringAsFixed(4)),
                DemoValue('1.atan2(2).toStringAsFixed(4)', 1.atan2(2).toStringAsFixed(4)),
              ]),
            ),
            DemoItem(
              title: '中文数字',
              code:
                  "3.toChineseNumbers();                  // 三\n"
                  "7.toChineseNumbers(isWeek: true);     // 日\n"
                  "3.toChineseNumbers(isSimplify: false); // 叁",
              child: DemoValues([
                DemoValue('3.toChineseNumbers()', 3.toChineseNumbers()),
                DemoValue('7.toChineseNumbers(isWeek: true)', 7.toChineseNumbers(isWeek: true)),
                DemoValue('3.toChineseNumbers(isSimplify: false)', 3.toChineseNumbers(isSimplify: false)),
                DemoValue('12345.toChineseNumbers()', 12345.toChineseNumbers()),
              ]),
            ),
            DemoItem(
              title: '生成、插入与包含',
              code: r"""
3.generate((index) => 'Item $index'); // [Item 0, Item 1, Item 2]
12345.insert(2, '9');                 // 129345
12345.contains('23');                 // true
12345.length;                         // 5
""",
              child: DemoValues([
                DemoValue("3.generate((i) => 'Item \$i')", '${3.generate((int i) => 'Item $i')}'),
                DemoValue("12345.insert(2, '9')", '${12345.insert(2, '9')}'),
                DemoValue("12345.contains('23')", '${12345.contains('23')}'),
                DemoValue('12345.length', '${12345.length}'),
                DemoValue('10.random', '${10.random}（0 ~ 9）'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '时长',
          description: '数字直接转为 Duration，配合 Duration 扩展做延迟与定时。',
          children: [
            DemoItem(
              title: 'Duration 快捷属性',
              code:
                  "2.seconds;        // Duration(milliseconds: 2000)\n"
                  "1.5.minutes;      // Duration(seconds: 90)\n"
                  "2.hours;          // Duration(minutes: 120)\n"
                  "1.days;           // Duration(hours: 24)",
              child: DemoValues([
                DemoValue('2.seconds', '${2.seconds}'),
                DemoValue('1.5.minutes', '${1.5.minutes}'),
                DemoValue('2.hours', '${2.hours}'),
                DemoValue('1.days', '${1.days}'),
                DemoValue('500.microseconds', '${500.microseconds}'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '存储与时间戳',
          description: 'toFileSize 支持 B ~ PB，toStorageUnit 自动进位。',
          children: [
            DemoItem(
              title: '文件大小',
              code:
                  "1536.toFileSize();                 // 1.5KB\n"
                  "1536.toStorageUnit();              // 1.5 KB\n"
                  "(1024 * 1024 - 1).toStorageUnit(); // 1 MB\n"
                  "1099511627776.toFileSize();        // 1TB",
              child: const DemoValues([
                DemoValue('1536.toFileSize()', '1.5KB'),
                DemoValue('1536.toStorageUnit()', '1.5 KB'),
                DemoValue('(1024 * 1024 - 1).toStorageUnit()', '1 MB'),
                DemoValue('1099511627776.toFileSize()', '1TB'),
              ]),
            ),
            DemoItem(
              title: '时间戳',
              code:
                  "dateTime.millisecondsSinceEpoch.fromMillisecondsSinceEpoch;\n"
                  "dateTime.microsecondsSinceEpoch.fromMicrosecondsSinceEpoch;",
              child: DemoValues([
                DemoValue(
                  'millisecondsSinceEpoch',
                  DateTime(2026, 10, 24).millisecondsSinceEpoch.fromMillisecondsSinceEpoch().toIso8601String(),
                ),
                DemoValue(
                  'microsecondsSinceEpoch',
                  DateTime(2026, 10, 24).microsecondsSinceEpoch.fromMicrosecondsSinceEpoch().toIso8601String(),
                ),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'Widget 快捷属性',
          description: '数字可直接生成 SizedBox、Offset、EdgeInsets 与 BorderRadius。',
          children: [
            DemoItem(
              title: '尺寸与边距',
              code:
                  "8.heightBox;\n"
                  "12.widthBox;\n"
                  "16.squareBox;\n"
                  "12.edgeInsetsAll;\n"
                  "12.edgeInsetsHorizontal;\n"
                  "12.borderRadiusAll;\n"
                  "12.offset;",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 40, height: 40, color: colors.primaryContainer),
                      8.widthBox,
                      Container(width: 40, height: 40, color: colors.secondaryContainer),
                      8.widthBox,
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: colors.tertiaryContainer, borderRadius: 12.borderRadiusAll),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Universal(
                    padding: 12.edgeInsetsAll,
                    decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: 12.borderRadiusAll),
                    child: const FlText('padding: 12.edgeInsetsAll'),
                  ),
                ],
              ),
            ),
            const DemoItem(
              child: DemoValues([
                DemoValue('widthBox / heightBox', 'SizedBox(width / height)'),
                DemoValue('squareBox', 'SizedBox 宽高相同'),
                DemoValue('offsetX / offsetY / offset', 'Offset'),
                DemoValue('edgeInsetsAll / Left / Right / Top / Bottom', 'EdgeInsets'),
                DemoValue('edgeInsetsHorizontal / Vertical / Symmetric', 'EdgeInsets.symmetric'),
                DemoValue('edgeInsetsDirectional*', 'EdgeInsetsDirectional'),
                DemoValue('borderRadiusAll / Top / Bottom / Left / Right', 'BorderRadius'),
                DemoValue('fromL / fromT / fromR / fromB / fromLR / fromTB / …', 'EdgeInsets.fromLTRB'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '复制',
          children: [
            DemoItem(
              title: 'toClipboard',
              code: 'await 42.toClipboard();',
              child: FlButton(
                onPressed: () async {
                  await 42.toClipboard();
                  unawaited(showToast('数字已复制', iconStyle: ToastIconStyle.success));
                },
                child: const Text('复制 42'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
