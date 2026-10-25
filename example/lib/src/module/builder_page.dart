import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class BuilderPage extends StatelessWidget {
  const BuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoPage(
      title: 'Future & Stream Builder',
      description:
          'FlFutureBuilder / FlStreamBuilder 用回调替代嵌套 builder；CustomFutureBuilder / '
          'CustomStreamBuilder 额外支持重试、错误态与手动刷新。',
      sections: [
        DemoSection(
          title: 'FlFutureBuilder',
          description: '按 ConnectionState 与 error 分发到不同回调，未提供的状态回退为 SizedBox。',
          children: [
            DemoItem(
              title: '成功 / 等待 / 错误',
              code: r"""
FlFutureBuilder<String>(
  future: _future,
  onNone: (_, data) => FlText('none'),
  onWaiting: (_, data) => CircularProgressIndicator(),
  onDone: (_, data) => FlText(data),
  onError: (_, error) => FlText('$error'),
)
""",
              child: _FlFutureDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'CustomFutureBuilder',
          description: '通过 future 函数延迟执行，onDone / onError / onNone 都提供 reset 回调。',
          children: [
            DemoItem(
              title: '可重试 Future',
              description: 'didUpdateWidgetCallFuture 为 true 时，父组件更新会重新发起请求。',
              code: r"""
CustomFutureBuilder<String>(
  didUpdateWidgetCallFuture: true,
  future: _load,
  onWaiting: (_) => CircularProgressIndicator(),
  onDone: (_, data, reset) => FlText(data),
  onError: (_, error, reset) => FlText('$error'),
  onNone: (_, reset) => FlText('点击加载'),
)
""",
              child: _CustomFutureDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'FlStreamBuilder',
          description: '流每次 emit 都会重建，适合轮询、倒计时与实时数据。',
          children: [
            DemoItem(
              title: '周期流',
              code: r"""
FlStreamBuilder<int>(
  stream: Stream.periodic(Duration(milliseconds: 700), (i) => i + 1).take(4),
  onWaiting: (_, data) => CircularProgressIndicator(),
  onActive: (_, data) => FlText('active: $data'),
  onDone: (_, data) => FlText('done: $data'),
)
""",
              child: _FlStreamDemo(),
            ),
          ],
        ),
        DemoSection(
          title: 'CustomStreamBuilder',
          description: '订阅生命周期由组件管理，stream 实例变化时自动重新订阅。',
          children: [
            DemoItem(
              title: '切换数据源',
              description: '点击“重新订阅”会创建一个新的 Stream，CustomStreamBuilder 会自动切换。',
              code: r"""
CustomStreamBuilder<int>(
  stream: _stream,
  onWaiting: (_) => CircularProgressIndicator(),
  onDone: (_, data) => FlText('$data'),
  onError: (_, error) => FlText('$error'),
)
""",
              child: _CustomStreamDemo(),
            ),
          ],
        ),
        DemoSection(
          title: '参数说明',
          children: [
            DemoItem(
              child: DemoValues([
                DemoValue('initial', '初始数据，不为 null 时直接进入 done 状态'),
                DemoValue('initialCallFuture / initialCallStream', 'initial 不为 null 时是否仍发起请求'),
                DemoValue('didUpdateWidgetCallFuture', '父组件更新时是否重新执行 future 函数'),
                DemoValue('didUpdateWidgetCallStream', '强制重新订阅（stream 实例变化时也会自动重订）'),
                DemoValue('onNone / onWaiting / onError / onDone', '各状态 UI 回调'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlFutureDemo extends StatefulWidget {
  const _FlFutureDemo();

  @override
  State<_FlFutureDemo> createState() => _FlFutureDemoState();
}

class _FlFutureDemoState extends State<_FlFutureDemo> {
  int _seed = 0;
  bool _fail = false;
  late Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<String> _load() async {
    final bool fail = _fail;
    await const Duration(milliseconds: 900).delayed();
    if (fail) throw StateError('模拟 Future 错误');
    return 'Future 数据 #${++_seed}';
  }

  void _reload({bool? fail}) {
    setState(() {
      _fail = fail ?? _fail;
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlFutureBuilder<String>(
          future: _future,
          onNone: (_, String? data) => const FlText('none：尚未开始'),
          onWaiting: (_, String? data) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          onDone: (_, String? data) => FlText(data ?? '-'),
          onError: (_, Object? error) => FlText('$error', color: Theme.of(context).colorScheme.error),
        ),
        10.heightBox,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FlButton(onPressed: () => _reload(), child: const Text('重新加载')),
            FlButton(
              category: FlButtonCategory.outlined,
              onPressed: () => _reload(fail: true),
              child: const Text('模拟错误'),
            ),
            FlButton(
              category: FlButtonCategory.outlined,
              onPressed: () => _reload(fail: false),
              child: const Text('恢复正常'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomFutureDemo extends StatefulWidget {
  const _CustomFutureDemo();

  @override
  State<_CustomFutureDemo> createState() => _CustomFutureDemoState();
}

class _CustomFutureDemoState extends State<_CustomFutureDemo> {
  int _seed = 0;
  bool _fail = false;

  Future<String> _load() async {
    final bool fail = _fail;
    await const Duration(milliseconds: 800).delayed();
    if (fail) throw StateError('CustomFutureBuilder 模拟错误');
    return 'CustomFuture 数据 #${++_seed}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFutureBuilder<String>(
          didUpdateWidgetCallFuture: true,
          future: _load,
          onWaiting: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          onDone: (_, String data, Function reset) => Row(
            children: [
              Expanded(child: FlText(data)),
              FlButton(onPressed: () => reset(), child: const Text('重试')),
            ],
          ),
          onError: (_, Object? error, Function reset) => Row(
            children: [
              Expanded(child: FlText('$error', color: Theme.of(context).colorScheme.error)),
              FlButton(onPressed: () => reset(), child: const Text('重试')),
            ],
          ),
          onNone: (_, Function reset) => FlButton(onPressed: () => reset(), child: const Text('开始加载')),
        ),
        10.heightBox,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FlButton(onPressed: () => setState(() => _fail = false), child: const Text('成功')),
            FlButton(
              category: FlButtonCategory.outlined,
              onPressed: () => setState(() => _fail = true),
              child: const Text('失败'),
            ),
          ],
        ),
      ],
    );
  }
}

class _FlStreamDemo extends StatefulWidget {
  const _FlStreamDemo();

  @override
  State<_FlStreamDemo> createState() => _FlStreamDemoState();
}

class _FlStreamDemoState extends State<_FlStreamDemo> {
  int _round = 0;
  late Stream<int> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _newStream();
  }

  Stream<int> _newStream() => Stream<int>.periodic(
    const Duration(milliseconds: 700),
    (int index) => index + 1,
  ).take(4).map((int value) => value + _round * 10);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlStreamBuilder<int>(
          stream: _stream,
          onNone: (_, int? data) => const FlText('none'),
          onWaiting: (_, int? data) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          onActive: (_, int? data) => FlText('active：$data'),
          onDone: (_, int? data) => FlText('done：$data'),
        ),
        10.heightBox,
        FlButton(
          onPressed: () => setState(() {
            _round++;
            _stream = _newStream();
          }),
          child: const Text('重新订阅'),
        ),
      ],
    );
  }
}

class _CustomStreamDemo extends StatefulWidget {
  const _CustomStreamDemo();

  @override
  State<_CustomStreamDemo> createState() => _CustomStreamDemoState();
}

class _CustomStreamDemoState extends State<_CustomStreamDemo> {
  int _round = 0;
  late Stream<int> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _newStream();
  }

  Stream<int> _newStream() => Stream<int>.periodic(
    const Duration(milliseconds: 700),
    (int index) => index + 1,
  ).take(4).map((int value) => value + _round * 10);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomStreamBuilder<int>(
          stream: _stream,
          onWaiting: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          onDone: (_, int? data) => FlText('最新值：${data ?? '-'}'),
          onNone: (_) => const FlText('none'),
          onError: (_, Object? error) => FlText('$error'),
        ),
        10.heightBox,
        FlButton(
          onPressed: () => setState(() {
            _round++;
            _stream = _newStream();
          }),
          child: const Text('切换 Stream'),
        ),
      ],
    );
  }
}
