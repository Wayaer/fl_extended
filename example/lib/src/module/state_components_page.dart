import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class StateComponentsPage extends StatelessWidget {
  const StateComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'State Components',
      description: '这些组件把“状态放在哪、怎么刷新”封装成简单 API，适合局部刷新、表单状态与轻量动画。',
      sections: [
        DemoSection(
          title: 'ValueBuilder',
          description: '内部持有值，通过 updater 更新并自动 setState。',
          children: [
            DemoItem(
              title: '计数器',
              code: r"""
ValueBuilder<int>(
  initial: 0,
  builder: (_, value, update) => Row(children: [
    IconButton(onPressed: () => update(value! - 1), icon: Icon(Icons.remove)),
    Text('$value'),
    IconButton(onPressed: () => update(value! + 1), icon: Icon(Icons.add)),
  ]),
)
""",
              child: const _ValueBuilderDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'ValueListenBuilder',
          description: '暴露 ValueNotifier，赋值即刷新；适合需要从外部修改值的场景。',
          children: [
            DemoItem(
              title: 'ValueNotifier',
              code: r"""
ValueListenBuilder<int>(
  initial: 0,
  builder: (_, notifier) => Row(children: [
    Text('${notifier.value}'),
    IconButton(onPressed: () => notifier.value = notifier.value! + 1, icon: Icon(Icons.add)),
  ]),
)
""",
              child: const _ValueListenDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'FlListenableBuilder',
          description: '监听任意 Listenable（TabController、AnimationController、自定义 ChangeNotifier）。',
          children: [
            DemoItem(
              title: 'TabController',
              code: r"""
FlListenableBuilder<TabController>(
  listenable: controller,
  builder: (_, controller) => Row(
    children: List.generate(2, (index) => Icon(
      index == controller.index ? Icons.circle : Icons.circle_outlined,
    )),
  ),
)
""",
              child: const _TabListenableDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'ChangedBuilder',
          description: '同步或异步变更：onWaitChanged 返回的新值会在异步完成后写回。',
          children: [
            DemoItem(
              title: '同步 / 异步开关',
              code: r"""
ChangedBuilder<bool>(
  value: false,
  onChanged: (value) {},
  builder: (value, onChanged) => Switch(value: value, onChanged: onChanged),
)

ChangedBuilder<bool>(
  value: false,
  onWaitChanged: (value) async {
    await Future.delayed(Duration(milliseconds: 600));
    return !value;
  },
  builder: (value, onChanged) => Switch(value: value, onChanged: onChanged),
)
""",
              child: const _ChangedBuilderDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'FlStatefulBuilder',
          description: '在 builder 内直接使用 setState，不需要额外写 State 类。',
          children: [
            DemoItem(
              title: '局部状态',
              code: r"""
FlStatefulBuilder(
  builder: (context, setState) => Row(children: [
    IconButton(onPressed: () => setState(() => count--), icon: Icon(Icons.remove)),
    Text('$count'),
    IconButton(onPressed: () => setState(() => count++), icon: Icon(Icons.add)),
  ]),
)
""",
              child: const _FlStatefulBuilderDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'FlStatefulWidget 生命周期回调',
          description: '在构造参数里注入 initState / didChangeDependencies / didUpdateWidget / deactivate / dispose。',
          children: [
            DemoItem(
              title: '生命周期日志',
              code: r"""
class MyWidget extends FlStatefulWidget {
  const MyWidget({
    super.initState,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });
}

MyWidget(
  initState: (_) => log('initState'),
  didUpdateWidget: (_) => log('didUpdateWidget'),
  deactivate: (_) => log('deactivate'),
  dispose: (_) => log('dispose'),
)
""",
              child: const _LifecycleDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'FlInheritedWidget',
          description: '自定义 updateShouldNotify，依赖方在回调返回 true 时刷新。',
          children: [
            DemoItem(
              title: '依赖通知',
              code: r"""
FlInheritedWidget(
  onShouldNotify: (oldWidget) => true,
  child: Builder(builder: (context) {
    context.dependOnInheritedWidgetOfExactType<FlInheritedWidget>();
    return const Text('dependent');
  }),
)
""",
              child: const _InheritedDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ValueBuilderDemo extends StatelessWidget {
  const _ValueBuilderDemo();

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<int>(
      initial: 0,
      builder: (_, int? value, ValueCallback<int> update) {
        return Row(
          children: [
            IconButton(onPressed: () => update((value ?? 0) - 1), icon: const Icon(Icons.remove_circle_outline)),
            Expanded(child: Text('${value ?? 0}', textAlign: TextAlign.center)),
            IconButton(onPressed: () => update((value ?? 0) + 1), icon: const Icon(Icons.add_circle_outline)),
          ],
        );
      },
    );
  }
}

class _ValueListenDemo extends StatelessWidget {
  const _ValueListenDemo();

  @override
  Widget build(BuildContext context) {
    return ValueListenBuilder<int>(
      initial: 0,
      builder: (_, ValueNotifier<int?> notifier) {
        return Row(
          children: [
            IconButton(
              onPressed: () => notifier.value = (notifier.value ?? 0) - 1,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Expanded(child: Text('${notifier.value ?? 0}', textAlign: TextAlign.center)),
            IconButton(
              onPressed: () => notifier.value = (notifier.value ?? 0) + 1,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        );
      },
    );
  }
}

class _TabListenableDemo extends StatefulWidget {
  const _TabListenableDemo();

  @override
  State<_TabListenableDemo> createState() => _TabListenableDemoState();
}

class _TabListenableDemoState extends State<_TabListenableDemo> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlListenableBuilder<TabController>(
          listenable: _controller,
          builder: (_, TabController controller) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              2,
              (int index) => Icon(
                index == controller.index ? Icons.circle_rounded : Icons.circle_outlined,
                color: index == controller.index ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ),
        8.heightBox,
        TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'Tab A'),
            Tab(text: 'Tab B'),
          ],
        ),
      ],
    );
  }
}

class _ChangedBuilderDemo extends StatelessWidget {
  const _ChangedBuilderDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Text('同步')),
            ChangedBuilder<bool>(
              value: false,
              onChanged: (bool value) {},
              builder: (bool value, ValueCallback<bool> onChanged) => Switch(value: value, onChanged: onChanged),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text('异步（600ms）')),
            ChangedBuilder<bool>(
              value: false,
              onWaitChanged: (bool value) async {
                await const Duration(milliseconds: 600).delayed();
                return !value;
              },
              builder: (bool value, ValueCallback<bool> onChanged) => Switch(value: value, onChanged: onChanged),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlStatefulBuilderDemo extends StatefulWidget {
  const _FlStatefulBuilderDemo();

  @override
  State<_FlStatefulBuilderDemo> createState() => _FlStatefulBuilderDemoState();
}

class _FlStatefulBuilderDemoState extends State<_FlStatefulBuilderDemo> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return FlStatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: [
            IconButton(onPressed: () => setState(() => count -= 1), icon: const Icon(Icons.remove_circle_outline)),
            Expanded(child: Text('count: $count', textAlign: TextAlign.center)),
            IconButton(onPressed: () => setState(() => count += 1), icon: const Icon(Icons.add_circle_outline)),
          ],
        );
      },
    );
  }
}

class _LifecycleDemo extends StatefulWidget {
  const _LifecycleDemo();

  @override
  State<_LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<_LifecycleDemo> {
  final ValueNotifier<List<String>> _logs = ValueNotifier<List<String>>(<String>[]);
  int _count = 0;
  bool _visible = true;

  @override
  void dispose() {
    _logs.dispose();
    super.dispose();
  }

  void _log(String message) {
    // 生命周期回调可能在 build / finalizeTree 期间触发，此时不能直接更新
    // ValueNotifier；延迟到微任务中执行，确保 widget tree 已解锁。
    scheduleMicrotask(() {
      if (!mounted) return;
      _logs.value = <String>[..._logs.value, message];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<List<String>>(
          valueListenable: _logs,
          builder: (_, List<String> logs, _) => DemoConsole(logs),
        ),
        8.heightBox,
        if (_visible)
          _LifecycleChild(
            count: _count,
            initState: (_) => _log('initState'),
            didChangeDependencies: (_) => _log('didChangeDependencies'),
            didUpdateWidget: (_) => _log('didUpdateWidget'),
            deactivate: (_) => _log('deactivate'),
            dispose: (_) => _log('dispose'),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FlButton(
              onPressed: () => setState(() => _count++),
              child: const Text('触发 didUpdateWidget'),
            ),
            FlButton(
              category: FlButtonCategory.outlined,
              onPressed: () => setState(() => _visible = !_visible),
              child: Text(_visible ? '移除子组件' : '重新挂载子组件'),
            ),
          ],
        ),
      ],
    );
  }
}

class _LifecycleChild extends FlStatefulWidget {
  const _LifecycleChild({
    required this.count,
    super.initState,
    super.didChangeDependencies,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });

  final int count;

  @override
  State<_LifecycleChild> createState() => _LifecycleChildState();
}

class _LifecycleChildState extends FlStatefulWidgetState<_LifecycleChild> {
  @override
  Widget build(BuildContext context) =>
      FlText('子组件 count: ${widget.count}', color: Theme.of(context).colorScheme.primary);
}

class _InheritedDemo extends StatefulWidget {
  const _InheritedDemo();

  @override
  State<_InheritedDemo> createState() => _InheritedDemoState();
}

class _InheritedDemoState extends State<_InheritedDemo> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return FlInheritedWidget(
      onShouldNotify: (FlInheritedWidget oldWidget) => true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlText('host count: $count'),
          8.heightBox,
          FlButton(onPressed: () => setState(() => count++), child: const Text('通知依赖方')),
          8.heightBox,
          Builder(
            builder: (BuildContext context) {
              context.dependOnInheritedWidgetOfExactType<FlInheritedWidget>();
              return FlText('dependent rebuilds with host: $count');
            },
          ),
        ],
      ),
    );
  }
}
