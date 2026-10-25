import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ContextPage extends StatefulWidget {
  const ContextPage({super.key});

  @override
  State<ContextPage> createState() => _ContextPageState();
}

class _ContextPageState extends State<ContextPage> {
  final GlobalKey _boxKey = GlobalKey();
  final FocusNode _focusA = FocusNode(debugLabel: 'A');
  final FocusNode _focusB = FocusNode(debugLabel: 'B');

  Rect? _bounds;
  Offset? _global;
  Offset? _local;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) => _measure(), debugLabel: 'context-demo');
  }

  @override
  void dispose() {
    _focusA.dispose();
    _focusB.dispose();
    super.dispose();
  }

  void _measure() {
    final BuildContext? boxContext = _boxKey.currentContext;
    if (!mounted || boxContext == null) return;
    final Offset global = boxContext.getWidgetLocalToGlobal();
    setState(() {
      _bounds = boxContext.getWidgetBounds;
      _global = global;
      _local = boxContext.getWidgetGlobalToLocal(point: global);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Context & Focus',
      description: 'BuildContext 扩展把主题、MediaQuery、RenderBox、焦点与 Navigator 能力收敛成直接可读的属性/方法。',
      sections: [
        DemoSection(
          title: '主题',
          children: [
            DemoItem(
              title: '主题属性',
              code: "context.theme;\ncontext.textTheme;\ncontext.iconTheme;\ncontext.isDarkMode;\ncontext.iconColor;",
              child: DemoValues([
                DemoValue('context.isDarkMode', '${context.isDarkMode}'),
                DemoValue('context.theme.brightness', '${context.theme.brightness}'),
                DemoValue('context.textTheme.bodyMedium.fontSize', '${context.textTheme.bodyMedium?.fontSize}'),
                DemoValue('context.iconColor', '${context.iconColor}'),
                DemoValue('context.width', context.width.toStringAsFixed(1)),
                DemoValue('context.height', context.height.toStringAsFixed(1)),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'MediaQuery',
          description: '屏幕尺寸、方向、安全区、像素比与设备类型判断。',
          children: [
            DemoItem(
              title: '设备信息',
              code: "context.mediaQuerySize;\ncontext.orientation;\ncontext.devicePixelRatio;\ncontext.statusBarHeight;\ncontext.isPhone;\ncontext.isTablet;\ncontext.widthPixel;",
              child: DemoValues([
                DemoValue('mediaQuerySize', '${context.mediaQuerySize}'),
                DemoValue('orientation', '${context.orientation}'),
                DemoValue('devicePixelRatio', '${context.devicePixelRatio}'),
                DemoValue('statusBarHeight', '${context.statusBarHeight}'),
                DemoValue('isLandscape / isPortrait', '${context.isLandscape} / ${context.isPortrait}'),
                DemoValue('isPhone / isTablet', '${context.isPhone} / ${context.isTablet}'),
                DemoValue(
                  'widthPixel / heightPixel',
                  '${context.widthPixel.toStringAsFixed(1)} / ${context.heightPixel.toStringAsFixed(1)}',
                ),
                DemoValue('padding', '${context.padding}'),
                DemoValue('viewInsets', '${context.viewInsets}'),
              ]),
            ),
            DemoItem(
              title: '尺寸换算',
              code: "context.heightTransformer(dividedBy: 3);\ncontext.widthTransformer(reducedBy: 20);\ncontext.ratio();",
              child: DemoValues([
                DemoValue(
                  'heightTransformer(dividedBy: 3)',
                  context.heightTransformer(dividedBy: 3).toStringAsFixed(1),
                ),
                DemoValue(
                  'widthTransformer(reducedBy: 20)',
                  context.widthTransformer(reducedBy: 20).toStringAsFixed(1),
                ),
                DemoValue('ratio()', context.ratio().toStringAsFixed(3)),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'RenderBox',
          description: '获取组件尺寸、全局位置与本地坐标；组件需已完成渲染。',
          children: [
            DemoItem(
              title: '测量示例',
              code: "final rect = context.getWidgetRectLocalToGlobal();\ncontext.getWidgetBounds;\ncontext.getWidgetLocalToGlobal();\ncontext.getWidgetGlobalToLocal();",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: _boxKey,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: 12.borderRadiusAll),
                    child: const FlText('测量这个盒子'),
                  ),
                  10.heightBox,
                  DemoValues([
                    DemoValue('getWidgetBounds', '$_bounds'),
                    DemoValue('getWidgetLocalToGlobal()', '$_global'),
                    DemoValue('getWidgetGlobalToLocal()', '$_local'),
                  ]),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: _measure,
                    child: const Text('重新测量'),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '焦点',
          description: 'requestFocus / unfocus / nextFocus / previousFocus 直接作用于当前 FocusScope。',
          children: [
            DemoItem(
              title: '焦点控制',
              code: "context.requestFocus(focusNode);\ncontext.unfocus();\ncontext.nextFocus();\ncontext.previousFocus();",
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      TextField(
                        focusNode: _focusA,
                        decoration: const InputDecoration(labelText: '输入框 A', border: OutlineInputBorder()),
                      ),
                      8.heightBox,
                      TextField(
                        focusNode: _focusB,
                        decoration: const InputDecoration(labelText: '输入框 B', border: OutlineInputBorder()),
                      ),
                      8.heightBox,
                      FlListenableBuilder<FocusManager>(
                        listenable: FocusManager.instance,
                        builder: (_, FocusManager manager) => Text('A: ${_focusA.hasFocus}   B: ${_focusB.hasFocus}'),
                      ),
                      8.heightBox,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FlButton(onPressed: () => context.requestFocus(_focusA), child: const Text('聚焦 A')),
                          FlButton(onPressed: () => context.requestFocus(_focusB), child: const Text('聚焦 B')),
                          FlButton(
                            category: FlButtonCategory.outlined,
                            onPressed: () => context.nextFocus(),
                            child: const Text('下一个'),
                          ),
                          FlButton(
                            category: FlButtonCategory.outlined,
                            onPressed: () => context.previousFocus(),
                            child: const Text('上一个'),
                          ),
                          FlButton(
                            category: FlButtonCategory.outlined,
                            onPressed: () => context.unfocus(),
                            child: const Text('取消焦点'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'View / Overlay / Navigator',
          children: [
            const DemoItem(
              child: DemoValues([
                DemoValue('context.view / maybeView', '当前 FlutterView'),
                DemoValue('context.overlay', 'Overlay.of(context)'),
                DemoValue('context.maybeOverlay', 'Overlay.maybeOf(context)'),
                DemoValue('context.navigator', 'NavigatorState'),
                DemoValue('context.canPop()', '是否还能返回'),
                DemoValue('context.userGestureInProgress', '是否在处理返回手势'),
                DemoValue('context.push / pop / maybePop', '导航方法（详见 Navigator 页）'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
