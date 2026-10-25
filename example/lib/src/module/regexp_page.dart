import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class RegExpPage extends StatelessWidget {
  const RegExpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String input = 'hello@example.com, demo@flutter.dev';
    final FlRegExp pattern = FlRegExp(r'(?<user>\w+)@(?<host>[^,\s]+)');
    final FlRegExpMatch? first = pattern.firstMatch(input);
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'FlRegExp',
      description: 'FlRegExp 是对 RegExp 的薄封装，构造参数与原生一致，额外返回 FlRegExpMatch 以支持命名分组与链式读取。',
      sections: [
        DemoSection(
          title: '匹配',
          description: 'firstMatch / allMatches / hasMatch / stringMatch。',
          children: [
            DemoItem(
              title: '基础匹配',
              code:
                  "final pattern = FlRegExp(r'(?<user>\\w+)@(?<host>[^,\\s]+)');\n"
                  "pattern.hasMatch(input);\n"
                  "pattern.firstMatch(input)?.namedGroup('user');\n"
                  "pattern.allMatches(input).length;",
              child: DemoValues([
                DemoValue('input', input),
                DemoValue('hasMatch', '${pattern.hasMatch(input)}'),
                DemoValue('stringMatch', '${pattern.stringMatch(input)}'),
                DemoValue("firstMatch?.group(0)", '${first?.group(0)}'),
                DemoValue("firstMatch?.namedGroup('user')", '${first?.namedGroup('user')}'),
                DemoValue("firstMatch?.namedGroup('host')", '${first?.namedGroup('host')}'),
                DemoValue('allMatches.length', '${pattern.allMatches(input).length}'),
              ]),
            ),
            DemoItem(
              title: '遍历所有匹配',
              code:
                  "for (final match in pattern.allMatches(input)) {\n"
                  "  print('\${match.group(0)} -> \${match.namedGroup('host')}');\n"
                  "}",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final FlRegExpMatch match in pattern.allMatches(input))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${match.group(0)}  →  ${match.namedGroup('host')}',
                        style: TextStyle(color: colors.primary, fontFamily: 'monospace'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '构造与属性',
          description: '支持 multiLine / caseSensitive / unicode / dotAll，可读取原始 pattern 与配置。',
          children: [
            DemoItem(
              title: '匹配选项',
              code: r"FlRegExp(r'^flutter$', caseSensitive: false, multiLine: true)",
              child: DemoValues([
                DemoValue('pattern', pattern.pattern),
                DemoValue('isCaseSensitive', '${pattern.isCaseSensitive}'),
                DemoValue('isMultiLine', '${pattern.isMultiLine}'),
                DemoValue('isUnicode', '${pattern.isUnicode}'),
                DemoValue('isDotAll', '${pattern.isDotAll}'),
                DemoValue('matchAsPrefix', '${pattern.matchAsPrefix(input)?.group(0)}'),
              ]),
            ),
            DemoItem(
              title: '转义',
              description: '把字符串中的正则元字符转义，按字面量匹配。',
              code: "FlRegExp.escape('a+b?'); // a\\+b\\?",
              child: DemoValues([
                DemoValue("FlRegExp.escape('a+b?')", FlRegExp.escape('a+b?')),
                DemoValue("FlRegExp(r'a\\+b\\?').hasMatch('a+b?')", '${FlRegExp(r'a\+b\?').hasMatch('a+b?')}'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'FlRegExpMatch',
          description: 'FlRegExpMatch 实现 Match 接口，并额外提供 namedGroup / groupNames / groups。',
          children: [
            DemoItem(
              title: '分组读取',
              code:
                  "final match = pattern.firstMatch(input)!;\n"
                  "match.groupCount;\n"
                  "match.group(1);\n"
                  "match.namedGroup('user');\n"
                  "match.groups([0, 1, 2]);",
              child: DemoValues([
                DemoValue('groupCount', '${first?.groupCount}'),
                DemoValue('group(1)', '${first?.group(1)}'),
                DemoValue('namedGroup("user")', '${first?.namedGroup('user')}'),
                DemoValue('groups([0, 1, 2])', '${first?.groups(<int>[0, 1, 2])}'),
                DemoValue('groupNames', '${first?.groupNames.join(', ')}'),
                DemoValue('start / end', '${first?.start} / ${first?.end}'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
