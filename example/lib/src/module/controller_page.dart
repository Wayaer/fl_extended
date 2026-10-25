import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'controller-demo');
  final GlobalKey _shotKey = GlobalKey();

  late final TabController _tabController;
  String _text = '';
  bool _focused = false;
  int _tabIndex = 0;
  Uint8List? _shotBytes;

  @override
  void initState() {
    super.initState();
    _textController.addTextChangedListener((String value) {
      setState(() => _text = value);
    });
    _focusNode.addFocusChangedListener((bool value) {
      setState(() => _focused = value);
    });
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addIndexChangedListener((int value) {
      setState(() => _tabIndex = value);
    });
  }

  @override
  void dispose() {
    _textController.clearAllTextChangedListeners();
    _textController.dispose();
    _focusNode.clearAllFocusListeners();
    _focusNode.dispose();
    _tabController.clearAllIndexChangedListeners();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _screenshot() async {
    final ByteData? data = await _shotKey.screenshots(format: ui.ImageByteFormat.png, pixelRatio: 2);
    if (data == null) {
      if (mounted) unawaited(showToast('截图失败：key 未绑定到 RepaintBoundary'));
      return;
    }
    if (mounted) setState(() => _shotBytes = data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Controller & GlobalKey',
      description:
          '为 TextEditingController、FocusNode、TabController 挂载额外监听，避免手动 removeListener；'
          'GlobalKey 可直接截取 RepaintBoundary 画面。',
      sections: [
        DemoSection(
          title: 'TextEditingController',
          description: 'addTextChangedListener 只在文本变化时触发；插入方法会自动处理未设置选区的情况。',
          children: [
            DemoItem(
              title: '文本监听与插入',
              code: r"""
controller.addTextChangedListener((value) => setState(() => text = value));
controller.addTextAfterCursor('X');
controller.addTextBeforeCursor('Y');

// dispose
controller.clearAllTextChangedListeners();
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(labelText: '输入文本', border: OutlineInputBorder()),
                  ),
                  8.heightBox,
                  Text('text: "$_text"  focused: $_focused'),
                  8.heightBox,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FlButton(
                        onPressed: () => _textController.addTextAfterCursor('X'),
                        child: const Text('光标后插入 X'),
                      ),
                      FlButton(
                        onPressed: () => _textController.addTextBeforeCursor('Y'),
                        child: const Text('光标前插入 Y'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'FocusNode',
          description: 'addFocusChangedListener 在获得/失去焦点时回调。',
          children: [
            const DemoItem(
              code:
                  "focusNode.addFocusChangedListener((value) => setState(() => hasFocus = value));\n"
                  "focusNode.clearAllFocusListeners();",
              child: DemoValues([
                DemoValue('addFocusChangedListener', '焦点变化回调'),
                DemoValue('removeFocusListener', '移除单个回调'),
                DemoValue('clearAllFocusListeners', '清空并移除系统监听'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'TabController',
          description: '索引监听会在动画结束后触发；animateToIndex / jumpToIndex 控制切换。',
          children: [
            DemoItem(
              title: '索引监听',
              code: r"""
tabController.addIndexChangedListener((index) => setState(() => tabIndex = index));
tabController.animateToIndex(2);
tabController.jumpToIndex(0);
tabController.clearAllIndexChangedListeners();
""",
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
                      Tab(text: 'Tab 3'),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        Center(child: FlText('页面 1')),
                        Center(child: FlText('页面 2')),
                        Center(child: FlText('页面 3')),
                      ],
                    ),
                  ),
                  Text('当前索引：$_tabIndex'),
                  8.heightBox,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FlButton(onPressed: () => _tabController.animateToIndex(2), child: const Text('动画到 2')),
                      FlButton(
                        category: FlButtonCategory.outlined,
                        onPressed: () => _tabController.jumpToIndex(0),
                        child: const Text('跳到 0'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Expando Listenable',
          description: 'expandoBinder 把监听状态挂在 Listenable 实例上，弱引用 key 被回收时自动清理。',
          children: [
            const DemoItem(
              code: "tabController.expandoBinder<int>();\nfocusNode.expandoBinder<bool>();\ntextController.expandoBinder<String>();",
              child: DemoValues([
                DemoValue('TabController', 'addIndexChangedListener / removeIndexChangedListener'),
                DemoValue('FocusNode', 'addFocusChangedListener / removeFocusListener'),
                DemoValue('TextEditingController', 'addTextChangedListener / removeTextChangedListener'),
                DemoValue('FlListenableBinder', 'addWeakListener / removeListener / change'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'GlobalKey 截图',
          description: 'key 必须绑定到 RepaintBoundary；返回的 ByteData 可直接写入 Image.memory。',
          children: [
            DemoItem(
              title: 'screenshots',
              code: r"""
final data = await key.screenshots(
  format: ui.ImageByteFormat.png,
  pixelRatio: 2,
);
final bytes = data?.buffer.asUint8List();
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: _shotKey,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[colors.primary, colors.tertiary]),
                        borderRadius: 16.borderRadiusAll,
                      ),
                      child: const FlText('截图区域', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  10.heightBox,
                  FlButton(onPressed: _screenshot, child: const Text('截图')),
                  if (_shotBytes != null) ...[
                    10.heightBox,
                    ClipRRect(
                      borderRadius: 12.borderRadiusAll,
                      child: Image.memory(_shotBytes!, height: 160, fit: BoxFit.contain),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
