import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class LogcatPage extends StatefulWidget {
  const LogcatPage({super.key});

  @override
  State<LogcatPage> createState() => _LogcatPageState();
}

class _LogcatPageState extends State<LogcatPage> {
  bool get _running => FlLogcat().isRunning;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'FlLogcat',
      description:
          '在 Zone 中捕获 print / 未捕获错误，并提供可拖拽的悬浮日志入口。'
          '调试构建下建议在 main 最外层调用 runZone。',
      sections: [
        DemoSection(
          title: 'runZone',
          description: '不传 zoneSpecification 时使用默认实现；传入自定义配置时会保留原 print / errorCallback 并附加日志收集。',
          children: [
            const DemoItem(
              title: '入口',
              code: r"""
void main() {
  FlLogcat().runZone(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
  }, enable: true);
}

// 自定义 Zone，并读取 zoneValues
FlLogcat().runZone(
  () => print('hello'),
  zoneValues: {#tag: 'demo'},
  zoneSpecification: ZoneSpecification(
    print: (self, parent, zone, line) => parent.print(zone, line),
  ),
);
""",
              child: DemoValues([
                DemoValue('runZone', '在 Zone 中运行并收集日志'),
                DemoValue('enable', '是否启用收集，默认 kDebugMode'),
                DemoValue('zoneValues', '写入自定义 Zone'),
                DemoValue('onError', '未捕获错误回调'),
                DemoValue('insertLog', '手动插入日志'),
                DemoValue('maxLogs', '最多保留 500 条'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '插入日志',
          description:
              'LogType 区分 verbose / debug / info / warn / error / asyncError，决定日志列表中的展示颜色。'
              'print 输出归为 debug，Zone 捕获的未处理错误归为 asyncError。',
          children: [
            DemoItem(
              title: '手动插入',
              code: r"""
FlLogcat().insertLog(LogContent(
  type: LogType.info,
  dateTime: DateTime.now(),
  line: '来自示例页面的日志',
));
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final LogType type in LogType.values)
                    FlButton(
                      category: FlButtonCategory.outlined,
                      onPressed: () {
                        FlLogcat().isRunning = true;
                        FlLogcat().insertLog(
                          LogContent(type: type, dateTime: DateTime.now(), line: '示例日志：${type.name}'),
                        );
                        setState(() {});
                      },
                      child: Text(type.name),
                    ),
                ],
              ),
            ),
            const DemoItem(
              child: DemoValues([
                DemoValue('verbose', '详细日志'),
                DemoValue('debug', '调试日志，print 默认归到此类'),
                DemoValue('info', '普通信息'),
                DemoValue('warn', '警告'),
                DemoValue('error', '错误'),
                DemoValue('asyncError', 'Zone 捕获的未处理错误'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '悬浮入口',
          description: '开启后会在 Overlay 中显示可拖拽的终端图标，单击打开日志列表，双击隐藏。',
          children: [
            DemoItem(
              title: '控制入口',
              code: r"""
FlLogcat().isRunning = true;
FlLogcat().show();

FlLogcat().showLog();
FlLogcat().hide();
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('isRunning: $_running'),
                  10.heightBox,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FlButton(
                        onPressed: () {
                          FlLogcat().isRunning = true;
                          FlLogcat().show();
                          setState(() {});
                          showToast('已开启日志悬浮入口', iconStyle: ToastIconStyle.success);
                        },
                        child: const Text('开启悬浮入口'),
                      ),
                      FlButton(
                        category: FlButtonCategory.outlined,
                        onPressed: () {
                          FlLogcat().isRunning = false;
                          FlLogcat().hide();
                          setState(() {});
                          showToast('已隐藏日志悬浮入口');
                        },
                        child: const Text('隐藏悬浮入口'),
                      ),
                      FlButton(
                        category: FlButtonCategory.filledTonal,
                        onPressed: () {
                          FlLogcat().isRunning = true;
                          FlLogcat().showLog();
                        },
                        child: const Text('打开日志列表'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '捕获未捕获错误',
          description: 'runZonedGuarded 会捕获异步错误，示例不会导致页面崩溃。',
          children: [
            DemoItem(
              title: '模拟错误',
              code: r"""
FlLogcat().runZone(() {
  Future<void>.microtask(() => throw StateError('demo error'));
}, onError: (error, stack) {
  // 已由 FlLogcat 记录
});
""",
              child: FlButton(
                category: FlButtonCategory.outlined,
                onPressed: () {
                  FlLogcat().runZone(
                    () {
                      Future<void>.microtask(() => throw StateError('FlLogcat 示例错误'));
                    },
                    onError: (Object error, StackTrace stack) {
                      showToast('已捕获：$error', iconStyle: ToastIconStyle.fail);
                    },
                  );
                },
                child: const Text('触发一次捕获'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
