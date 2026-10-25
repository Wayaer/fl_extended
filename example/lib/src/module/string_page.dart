import 'dart:async';
import 'dart:convert';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class StringPage extends StatelessWidget {
  const StringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'String',
      description: '字符串解析、编解码、校验、编辑与颜色转换。示例中的结果均由左侧表达式实时计算。',
      sections: [
        DemoSection(
          title: '解析',
          description: 'parse 系列失败会抛异常，tryParse 系列失败返回 null。',
          children: [
            DemoItem(
              title: '数字 / 日期 / BigInt / JSON',
              code: r"""
'42'.parseInt;
'3.14'.parseDouble;
'abc'.tryParseNum;
'2026-10-24'.parseDateTime;
'12345678901234567890'.parseBigInt;
'{"a":1}'.isJson;
""",
              child: DemoValues([
                DemoValue("'42'.parseInt", '${'42'.parseInt}'),
                DemoValue("'3.14'.parseDouble", '${'3.14'.parseDouble}'),
                DemoValue("'abc'.tryParseNum", '${'abc'.tryParseNum}'),
                DemoValue("'2026-10-24'.parseDateTime", '2026-10-24'.parseDateTime.toIso8601String()),
                DemoValue("'12345678901234567890'.parseBigInt", '${'12345678901234567890'.parseBigInt}'),
                DemoValue("'{\"a\":1}'.isJson", '${'{"a":1}'.isJson}'),
                DemoValue('jsonDecode(...)[\'a\']', '${'{"a":1}'.jsonDecode()['a']}'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '编解码',
          description: 'Base64 / Base64Url、UTF-8 / ASCII / Latin1、URI、HTML 与十六进制颜色。',
          children: [
            DemoItem(
              title: 'Base64',
              code: r"""
'SGVsbG8='.base64Decode().toUtf8;   // Hello
'Y-Q='.base64Normalize();           // Y+Q=
'Y+Q='.base64UrlNormalize();        // Y-Q=
utf8.encode('Hello').base64Encode();
""",
              child: DemoValues([
                DemoValue("'SGVsbG8='.base64Decode().toUtf8", 'SGVsbG8='.base64Decode().toUtf8),
                DemoValue("'Y-Q='.base64Normalize()", 'Y-Q='.base64Normalize()),
                DemoValue("'Y+Q='.base64UrlNormalize()", 'Y+Q='.base64UrlNormalize()),
                DemoValue("utf8.encode('Hello').base64Encode()", utf8.encode('Hello').base64Encode()),
              ]),
            ),
            DemoItem(
              title: 'URI / HTML / Hex',
              code: r"""
'a b'.uriEncodeComponent();          // a%20b
'a%20b'.uriDecodeComponent();        // a b
'<a&b>'.htmlEscapeConvert();         // &lt;a&amp;b&gt;
'#4E6BFF'.fromHex;                   // Color(0xff4e6bff)
""",
              child: DemoValues([
                DemoValue("'a b'.uriEncodeComponent()", 'a b'.uriEncodeComponent()),
                DemoValue("'a%20b'.uriDecodeComponent()", 'a%20b'.uriDecodeComponent()),
                DemoValue("'<a&b>'.htmlEscapeConvert()", '<a&b>'.htmlEscapeConvert()),
                DemoValue("'#4E6BFF'.fromHex", '#4E6BFF'.fromHex.toString()),
                DemoValue("'#abc'.fromHex", '#abc'.fromHex.toString()),
              ]),
            ),
            DemoItem(
              title: '字节编码',
              code: "import 'dart:convert';\n\n'Hello'.utf8Encode();\n'Hello'.asciiEncode();\n'Hello'.latin1Encode();",
              child: DemoValues([
                DemoValue("'Hello'.utf8Encode().length", '${'Hello'.utf8Encode().length}'),
                DemoValue("'Hello'.asciiEncode()", 'Hello'.asciiEncode().join(', ')),
                DemoValue("'Hello'.latin1Encode()", 'Hello'.latin1Encode().join(', ')),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '校验',
          description: 'isNumber / isLetter 表示“包含”，isDigit 表示“单个数字字符”。',
          children: [
            DemoItem(
              title: '常用格式',
              code: r"""
'demo@example.com'.isEmail;
'13800138000'.isChinaPhone;
'中文abc'.isChinese;
'123abc'.isNumber;
'7'.isDigit;
""",
              child: const DemoValues([
                DemoValue("'demo@example.com'.isEmail", 'true'),
                DemoValue("'13800138000'.isChinaPhone", 'true'),
                DemoValue("'中文abc'.isChinese", 'true'),
                DemoValue("'123abc'.isNumber", 'true'),
                DemoValue("'7'.isDigit", 'true'),
                DemoValue("'123'.isDigit", 'false'),
                DemoValue("'15,12345678'.isChinaPhone", 'false'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '编辑与格式化',
          description: '移除、插入、反转、按位分组，均返回新字符串。',
          children: [
            DemoItem(
              title: '编辑',
              code: r"""
'12345'.removeFirst;          // 2345
'12345'.removeLast;           // 1234
'12345'.insert(2, 'X');       // 12X345
'12345'.reverse;              // 54321
'prefix:value'.removePrefix('prefix:');
'value.csv'.removeSuffix('.csv');
'12345'.removePrefixLength(2);
'12345'.removeSuffixLength(2);
""",
              child: DemoValues([
                DemoValue("'12345'.removeFirst", '12345'.removeFirst),
                DemoValue("'12345'.removeLast", '12345'.removeLast),
                DemoValue("'12345'.insert(2, 'X')", '12345'.insert(2, 'X')),
                DemoValue("'12345'.reverse", '12345'.reverse),
                DemoValue("'prefix:value'.removePrefix('prefix:')", 'prefix:value'.removePrefix('prefix:')),
                DemoValue("'value.csv'.removeSuffix('.csv')", 'value.csv'.removeSuffix('.csv')),
                DemoValue("'12345'.removePrefixLength(2)", '12345'.removePrefixLength(2)),
                DemoValue("'12345'.removeSuffixLength(2)", '12345'.removeSuffixLength(2)),
              ]),
            ),
            DemoItem(
              title: '数字分组',
              code: r"""
'12345678'.formatDigitPattern();              // 1234 5678
'12345678'.formatDigitPattern(digit: 4, pattern: '-');
'12345678'.formatDigitPatternEnd(digit: 2);   // 12 34 56 78
""",
              child: DemoValues([
                DemoValue(
                  "'12345678'.formatDigitPattern(digit: 4, pattern: '-')",
                  '12345678'.formatDigitPattern(pattern: '-'),
                ),
                DemoValue("'12345678'.formatDigitPatternEnd(digit: 2)", '12345678'.formatDigitPatternEnd(digit: 2)),
              ]),
            ),
            DemoItem(
              title: '复制到剪贴板',
              code: "await 'fl_extended'.toClipboard();",
              child: FlButton(
                onPressed: () async {
                  await 'fl_extended'.toClipboard();
                  unawaited(showToast('已复制到剪贴板', iconStyle: ToastIconStyle.success));
                },
                child: const Text('复制“fl_extended”'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
