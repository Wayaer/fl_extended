import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ObjectPage extends StatefulWidget {
  const ObjectPage({super.key});

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  final ValueNotifiers<int> _notifier = ValueNotifiers<int>(0);
  int _frameCount = 0;

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? nullableValue = int.tryParse('3');
    final int? nullValue = null;
    return DemoPage(
      title: 'Object & Binding',
      description: '所有对象都可用的 let / also / log / notifier / toList，以及 Size、bool 和全局 Binding 快捷能力。',
      sections: [
        DemoSection(
          title: 'let / also / 判空',
          children: [
            DemoItem(
              title: '链式处理',
              code: r"""
int? value = 3;
value.let((it) => it * 2);   // 6
value.also((it) => print(it)); // 原样返回 3

int? none;
none.let((it) => it * 2);    // null
none.isNull;                 // true
3.isNotNull;                 // true
""",
              child: DemoValues([
                DemoValue('nullableValue.let((it) => it * 2)', '${nullableValue.let((int? it) => (it ?? 0) * 2)}'),
                DemoValue('nullValue.let((it) => it * 2)', '${nullValue.let((int? it) => (it ?? 0) * 2)}'),
                DemoValue('nullValue.isNull', '${nullValue.isNull}'),
                DemoValue('3.isNotNull', '${3.isNotNull}'),
                DemoValue('3.toList', '${3.toList}'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'ValueNotifier',
          description: '任意值可直接转为 ValueNotifier；ValueNotifiers 支持手动 notify。',
          children: [
            DemoItem(
              title: 'notifier / notify',
              code: r"""
final notifier = 0.notifier;
notifier.value = 1;

final manual = ValueNotifiers<int>(0);
manual.value = 1;
manual.notify();
""",
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: _notifier,
                      builder: (_, int value, _) => Text('value: $value'),
                    ),
                  ),
                  FlButton(
                    onPressed: () {
                      _notifier.value += 1;
                      _notifier.notify();
                    },
                    child: const Text('+1 并 notify'),
                  ),
                ],
              ),
            ),
            const DemoItem(
              child: DemoValues([
                DemoValue('0.notifier', 'ValueNotifier<int>'),
                DemoValue('ValueNotifiers<T>', '可手动 notifyListeners'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '日志与 JSON',
          children: [
            DemoItem(
              title: 'log',
              description: '仅 Debug / Profile 生效，默认打印分隔线并自动分段 800 字。',
              code: "FlText('日志内容').log();\n{'a': 1, 'b': [2, 3]}.log(crossLine: false);",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () => const FlText('这是一条来自 FlText.log() 的日志').log(),
                    child: const Text('打印对象日志'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => <String, dynamic>{
                      'a': 1,
                      'b': <int>[2, 3],
                    }.log(crossLine: false),
                    child: const Text('打印 JSON'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'jsonEncode',
              code: "{\n  'name': 'fl_extended',\n  'versions': [4, 5],\n}.jsonEncode();",
              child: DemoValues([
                DemoValue(
                  'jsonEncode',
                  <String, dynamic>{
                    'name': 'fl_extended',
                    'versions': <int>[4, 5],
                  }.jsonEncode(),
                ),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'Size / bool / 可空集合',
          children: [
            DemoItem(
              title: 'Size 与 bool',
              code: "const Size(100, 50).scaling(p: 2); // Size(50, 25)\ntrue.toggle;                    // false\ntrue.toInt;                     // 1",
              child: const DemoValues([
                DemoValue('Size(100, 50).scaling(p: 2)', 'Size(50.0, 25.0)'),
                DemoValue('true.toggle', 'false'),
                DemoValue('false.toggle', 'true'),
                DemoValue('true.toInt', '1'),
              ]),
            ),
            DemoItem(
              title: 'isEmptyOrNull',
              code: r"""
String? s;  s.isEmptyOrNull;
List? l;    l.isEmptyOrNull;
Map? m;     m.isEmptyOrNull;
""",
              child: const DemoValues([
                DemoValue('String? null .isEmptyOrNull', 'true'),
                DemoValue("''.isEmptyOrNull", 'true'),
                DemoValue("'a'.isNotEmptyOrNull", 'true'),
                DemoValue('List? null .isEmptyOrNull', 'true'),
                DemoValue('Map? null .isEmptyOrNull', 'true'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'Binding',
          description: '全局 Binding getter 与常用回调注册，随取随用，不缓存旧实例。',
          children: [
            DemoItem(
              title: 'addPostFrameCallback',
              code: "addPostFrameCallback((_) {\n  setState(() => frameCount++);\n});",
              child: Row(
                children: [
                  Expanded(child: Text('下一帧回调次数：$_frameCount')),
                  FlButton(
                    onPressed: () => addPostFrameCallback((_) {
                      if (mounted) setState(() => _frameCount++);
                    }),
                    child: const Text('注册回调'),
                  ),
                ],
              ),
            ),
            const DemoItem(
              child: DemoValues([
                DemoValue('widgetsBinding', 'WidgetsBinding.instance'),
                DemoValue('schedulerBinding', 'SchedulerBinding.instance'),
                DemoValue('gestureBinding', 'GestureBinding.instance'),
                DemoValue('paintingBinding', 'PaintingBinding.instance'),
                DemoValue('semanticsBinding', 'SemanticsBinding.instance'),
                DemoValue('rendererBinding', 'RendererBinding.instance'),
                DemoValue('servicesBinding', 'ServicesBinding.instance'),
                DemoValue('addObserver / removeObserver', 'WidgetsBindingObserver'),
                DemoValue('addTimingsCallback / removeTimingsCallback', '帧耗时统计'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
