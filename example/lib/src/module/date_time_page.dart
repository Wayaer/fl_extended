import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class DateTimePage extends StatelessWidget {
  const DateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime(2026, 10, 24, 8, 9, 10, 5);
    return DemoPage(
      title: 'DateTime & Duration',
      description: '日期格式化、闰年判断、日期区间，以及 Duration 的延迟、定时与时长运算。',
      sections: [
        DemoSection(
          title: 'DateTime.format',
          description: 'format 默认输出年月日时分秒，也可指定 DateTimeDist 精度。',
          children: [
            DemoItem(
              title: '全部精度',
              code: "date.format();\ndate.format(DateTimeDist.yearMillisecond);\ndate.format(DateTimeDist.hourMinute);",
              child: DemoValues([
                DemoValue('date.format()', date.format()),
                for (final DateTimeDist dist in DateTimeDist.values)
                  DemoValue('format(${dist.name})', date.format(dist)),
              ]),
            ),
            DemoItem(
              title: 'dual = false',
              code: "date.format(DateTimeDist.yearSecond, false);",
              child: DemoValues([
                DemoValue('dual: true', date.format(DateTimeDist.yearSecond)),
                DemoValue('dual: false', date.format(DateTimeDist.yearSecond, false)),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '日期计算',
          children: [
            DemoItem(
              title: '闰年与日期区间',
              code: r"""
DateTime(2024, 1, 1).isLeapYearByYear; // true
DateTime(2026, 1, 1).getDaysForRange(DateTime(2026, 1, 4));
""",
              child: DemoValues([
                DemoValue('DateTime(2024).isLeapYearByYear', '${DateTime(2024).isLeapYearByYear}'),
                DemoValue('DateTime(2023).isLeapYearByYear', '${DateTime(2023).isLeapYearByYear}'),
                DemoValue(
                  'Jan 1 → Jan 4 getDaysForRange',
                  '${DateTime(2026, 1, 1, 12).getDaysForRange(DateTime(2026, 1, 4, 6)).map((DateTime d) => d.format(DateTimeDist.yearDay)).toList()}',
                ),
                DemoValue(
                  'endDate 早于当前日期',
                  '${DateTime(2026, 1, 2, 12).getDaysForRange(DateTime(2026, 1, 1, 18)).length}',
                ),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'Duration 格式化与运算',
          description: 'toString 去掉末尾后得到毫秒 / 秒 / 分 / 时。',
          children: [
            DemoItem(
              title: 'toEnd*',
              code:
                  "final d = Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4);\n"
                  "d.toEndMilliseconds;\nd.toEndSeconds;\nd.toEndMinutes;\nd.toEndHours;",
              child: DemoValues([
                DemoValue('toString()', const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4).toString()),
                DemoValue(
                  'toEndMilliseconds',
                  const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4).toEndMilliseconds,
                ),
                DemoValue(
                  'toEndSeconds',
                  const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4).toEndSeconds,
                ),
                DemoValue(
                  'toEndMinutes',
                  const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4).toEndMinutes,
                ),
                DemoValue('toEndHours', const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4).toEndHours),
              ]),
            ),
            DemoItem(
              title: 'add / subtract',
              code:
                  "2.seconds.add(3.seconds);          // 0:00:05\n"
                  "1.seconds.subtract(2.seconds);    // 0:00:00（不会为负）",
              child: const DemoValues([
                DemoValue('2.seconds.add(3.seconds)', '0:00:05.000000'),
                DemoValue('2.seconds.add(3.seconds, 4.seconds)', '0:00:09.000000'),
                DemoValue('1.seconds.subtract(2.seconds)', '0:00:00.000000'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '延迟与定时',
          description: 'Duration.delayed / timer / timerPeriodic。',
          children: [
            const DemoItem(
              title: '交互演示',
              code: "await 1.seconds.delayed();\n\nfinal timer = 500.milliseconds.timerPeriodic((timer) {});\ntimer.cancel();",
              child: _DurationDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _DurationDemo extends StatefulWidget {
  const _DurationDemo();

  @override
  State<_DurationDemo> createState() => _DurationDemoState();
}

class _DurationDemoState extends State<_DurationDemo> {
  Timer? _timer;
  int _ticks = 0;
  String _delayStatus = '尚未开始';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      setState(() {});
      return;
    }
    setState(() => _ticks = 0);
    _timer = 500.milliseconds.timerPeriodic((Timer timer) {
      setState(() => _ticks++);
    });
  }

  Future<void> _delay() async {
    setState(() => _delayStatus = '等待 1 秒…');
    await 1.seconds.delayed();
    if (!mounted) return;
    setState(() => _delayStatus = '已完成：${DateTime.now().format(DateTimeDist.hourMinute)}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FlButton(onPressed: _delay, child: const Text('delayed 1s')),
            10.widthBox,
            Expanded(child: Text(_delayStatus)),
          ],
        ),
        10.heightBox,
        Row(
          children: [
            FlButton(
              category: FlButtonCategory.outlined,
              onPressed: _toggleTimer,
              child: Text(_timer == null ? '启动 timerPeriodic' : '停止'),
            ),
            10.widthBox,
            Expanded(child: Text('ticks: $_ticks（500ms/次）')),
          ],
        ),
      ],
    );
  }
}
