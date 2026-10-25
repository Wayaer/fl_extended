import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniversalPage extends StatefulWidget {
  const UniversalPage({super.key});

  @override
  State<UniversalPage> createState() => _UniversalPageState();
}

class _UniversalPageState extends State<UniversalPage> {
  final Map<String, String> _gestureStates = <String, String>{};
  bool _hovered = false;
  bool _focused = false;
  int _buttonCount = 0;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _buttonFocusNode = FocusNode();
  final WidgetStatesController _buttonStates = WidgetStatesController();

  @override
  void dispose() {
    _scrollController.dispose();
    _buttonFocusNode.dispose();
    _buttonStates.dispose();
    super.dispose();
  }

  void _record(String name) {
    setState(() => _gestureStates[_gestureFamily(name)] = name);
  }

  String _gestureFamily(String name) {
    if (name.startsWith('onTertiary')) return 'tertiary';
    if (name.startsWith('onSecondary')) return 'secondary';
    if (name.startsWith('onForcePress')) return 'forcePress';
    if (name.startsWith('onScale')) return 'scale';
    if (name.startsWith('onPan')) return 'pan';
    if (name.startsWith('onVerticalDrag') || name.startsWith('onHorizontalDrag')) return 'drag';
    if (name.startsWith('onLongPress')) return 'longPress';
    return 'tap';
  }

  Widget _gestureHint(ColorScheme colors, String family) => Align(
    alignment: Alignment.centerLeft,
    child: Universal(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: 8.borderRadiusAll),
      child: FlText('最近手势：${_gestureStates[family] ?? '暂无手势'}', color: colors.onPrimaryContainer),
    ),
  );

  Widget _chip(String label, Color color) => Universal(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color, borderRadius: 8.borderRadiusAll),
    child: FlText(label),
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Universal',
      description:
          '一个容器覆盖布局、尺寸、滚动、裁剪、手势、按钮与安全区。'
          '下面按参数分组展示全部构造参数；每一项的代码都只包含该组相关的参数。',
      sections: [
        DemoSection(
          title: '基础容器',
          description: 'padding / margin / color / decoration / decorationPosition / alignment / widthFactor / heightFactor / child / children / opacity / key。',
          children: [
            DemoItem(
              title: 'padding、margin、decoration 与 key',
              description: 'decoration 的 color 优先于 color；decorationPosition 控制绘制在前景还是背景。',
              code:
                  "Universal(\n"
                  "  key: const ValueKey('universal-base'),\n"
                  "  padding: const EdgeInsets.all(14),\n"
                  "  margin: const EdgeInsets.only(bottom: 8),\n"
                  "  decoration: BoxDecoration(\n"
                  "    color: color,\n"
                  "    borderRadius: BorderRadius.circular(12),\n"
                  "  ),\n"
                  "  alignment: Alignment.center,\n"
                  "  child: const Text('padding + margin + decoration'),\n"
                  ")",
              child: Universal(
                key: const ValueKey<String>('universal-base'),
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: 12.borderRadiusAll),
                alignment: Alignment.center,
                child: const Text('padding + margin + decoration'),
              ),
            ),
            DemoItem(
              title: 'decorationPosition',
              description: 'foreground 会把装饰绘制在子组件上方；这里用描边演示，避免遮住文字。',
              code:
                  "Universal(\n"
                  "  decoration: BoxDecoration(\n"
                  "    border: Border.all(color: color, width: 2),\n"
                  "    borderRadius: BorderRadius.circular(12),\n"
                  "  ),\n"
                  "  decorationPosition: DecorationPosition.foreground,\n"
                  "  padding: const EdgeInsets.all(14),\n"
                  "  child: const Text('foreground border'),\n"
                  ")",
              child: Universal(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.primary, width: 2),
                  borderRadius: 12.borderRadiusAll,
                ),
                decorationPosition: DecorationPosition.foreground,
                padding: const EdgeInsets.all(14),
                child: const Text('foreground border'),
              ),
            ),
            DemoItem(
              title: 'child 与 children',
              description: '同时设置时 child 会并入列表首位。',
              code:
                  "Universal(\n"
                  "  color: color,\n"
                  "  padding: const EdgeInsets.all(12),\n"
                  "  children: const [Text('children[0]'), Text('children[1]')],\n"
                  "  child: const Text('child 并入首位'),\n"
                  ")",
              child: Universal(
                color: colors.secondaryContainer,
                padding: const EdgeInsets.all(12),
                children: const <Widget>[Text('children[0]'), Text('children[1]')],
                child: const Text('child 并入首位'),
              ),
            ),
            DemoItem(
              title: 'widthFactor / heightFactor',
              description: '设置倍数后会自动包裹 Align；父级需要给松约束才能看到尺寸变化。',
              code:
                  "Center(\n"
                  "  child: Universal(\n"
                  "    alignment: Alignment.center,\n"
                  "    widthFactor: 2,\n"
                  "    heightFactor: 2,\n"
                  "    color: color,\n"
                  "    child: const SizedBox(width: 48, height: 24, child: Center(child: Text('2×'))),\n"
                  "  ),\n"
                  ")",
              child: Center(
                child: Universal(
                  alignment: Alignment.center,
                  widthFactor: 2,
                  heightFactor: 2,
                  color: colors.tertiaryContainer,
                  child: const SizedBox(width: 48, height: 24, child: Center(child: Text('2×'))),
                ),
              ),
            ),
            DemoItem(
              title: 'opacity',
              description: '0 全透明、1 不透明；会作用于所有子组件。',
              code:
                  "Universal(\n"
                  "  opacity: 0.45,\n"
                  "  color: color,\n"
                  "  padding: const EdgeInsets.all(12),\n"
                  "  child: const Text('opacity: 0.45'),\n"
                  ")",
              child: Universal(
                opacity: 0.45,
                color: colors.primary,
                padding: const EdgeInsets.all(12),
                child: const Text('opacity: 0.45', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '尺寸与约束',
          description: 'width / height / size / expand / aspectRatio / constraints / intrinsicWidth / intrinsicHeight / stepWidth / stepHeight。',
          children: [
            DemoItem(
              title: 'width、height 与 size',
              description: 'size 与 width/height 互斥；expand 优先级最高。',
              code:
                  "Universal(width: 180, height: 48, color: color, alignment: Alignment.center, child: const Text('180 × 48'))\n"
                  "Universal(size: const Size(160, 52), color: color, alignment: Alignment.center, child: const Text('160 × 52'))",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Universal(
                    width: 180,
                    height: 48,
                    color: colors.primaryContainer,
                    alignment: Alignment.center,
                    child: const Text('180 × 48'),
                  ),
                  Universal(
                    size: const Size(160, 52),
                    color: colors.secondaryContainer,
                    alignment: Alignment.center,
                    child: const Text('160 × 52'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'expand',
              description: '占满父级给定空间，需要父级提供有界约束。',
              code:
                  "SizedBox(\n"
                  "  width: 220,\n"
                  "  height: 48,\n"
                  "  child: Universal(expand: true, color: color, alignment: Alignment.center, child: const Text('expand')),\n"
                  ")",
              child: SizedBox(
                width: 220,
                height: 48,
                child: Universal(
                  expand: true,
                  color: colors.tertiaryContainer,
                  alignment: Alignment.center,
                  child: const Text('expand'),
                ),
              ),
            ),
            DemoItem(
              title: 'aspectRatio 与 constraints',
              description: 'aspectRatio 固定宽高比；constraints 在尺寸外层再叠加约束。',
              code:
                  "SizedBox(\n"
                  "  width: 220,\n"
                  "  child: Universal(aspectRatio: 16 / 9, color: color, alignment: Alignment.center, child: const Text('16 : 9')),\n"
                  ")\n"
                  "Universal(constraints: const BoxConstraints(minWidth: 180, minHeight: 48), color: color)",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 220,
                    child: Universal(
                      aspectRatio: 16 / 9,
                      color: colors.primaryContainer,
                      alignment: Alignment.center,
                      child: const Text('16 : 9'),
                    ),
                  ),
                  Universal(
                    constraints: const BoxConstraints(minWidth: 180, minHeight: 48),
                    color: colors.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Text('BoxConstraints'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'intrinsicWidth / stepWidth / stepHeight',
              description: 'IntrinsicWidth 按子组件最大宽度计算，stepWidth 与 stepHeight 会把结果向上对齐到步长整数倍。',
              code:
                  "Center(\n"
                  "  child: Universal(\n"
                  "    intrinsicWidth: true,\n"
                  "    stepWidth: 30,\n"
                  "    stepHeight: 8,\n"
                  "    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),\n"
                  "    color: color,\n"
                  "    child: const Text('stepWidth 30'),\n"
                  "  ),\n"
                  ")",
              child: Center(
                child: Universal(
                  intrinsicWidth: true,
                  stepWidth: 30,
                  stepHeight: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: colors.secondaryContainer,
                  child: const Text('stepWidth 30'),
                ),
              ),
            ),
            DemoItem(
              title: 'intrinsicHeight',
              description: 'IntrinsicHeight 按子组件最大高度计算；配合 stretch 可让同行子组件等高。',
              code:
                  "Center(\n"
                  "  child: Universal(\n"
                  "    intrinsicHeight: true,\n"
                  "    direction: Axis.horizontal,\n"
                  "    crossAxisAlignment: CrossAxisAlignment.stretch,\n"
                  "    children: [\n"
                  "      Universal(width: 24, height: 24, color: color),\n"
                  "      Universal(width: 24, height: 48, color: color),\n"
                  "      Universal(width: 24, height: 36, color: color),\n"
                  "    ],\n"
                  "  ),\n"
                  ")",
              child: Center(
                child: Universal(
                  intrinsicHeight: true,
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Universal(width: 24, height: 24, color: colors.primary),
                    Universal(width: 24, height: 48, color: colors.tertiary),
                    Universal(width: 24, height: 36, color: colors.secondary),
                  ],
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Flex 线性布局',
          description: 'direction / mainAxisAlignment / crossAxisAlignment / mainAxisSize / spacing / textDirection / verticalDirection / textBaseline / flex / expanded / flexible。',
          children: [
            DemoItem(
              title: 'Row 基础对齐',
              description: 'direction、mainAxisAlignment、crossAxisAlignment、mainAxisSize、textDirection、verticalDirection 与 spacing 一起映射到 Flex。',
              code:
                  "Universal(\n"
                  "  direction: Axis.horizontal,\n"
                  "  height: 48,\n"
                  "  mainAxisAlignment: MainAxisAlignment.spaceBetween,\n"
                  "  textDirection: TextDirection.ltr,\n"
                  "  spacing: 8,\n"
                  "  children: const [\n"
                  "    Universal(size: Size(32, 32), color: color),\n"
                  "    Universal(size: Size(32, 32), color: color),\n"
                  "    Universal(size: Size(32, 32), color: color),\n"
                  "  ],\n"
                  ")",
              child: Universal(
                direction: Axis.horizontal,
                height: 48,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.ltr,
                spacing: 8,
                children: [
                  Universal(size: const Size(32, 32), color: colors.primary),
                  Universal(size: const Size(32, 32), color: colors.tertiary),
                  Universal(size: const Size(32, 32), color: colors.secondary),
                ],
              ),
            ),
            DemoItem(
              title: 'Column + verticalDirection',
              description: 'verticalDirection.up 会从下往上排列子组件。',
              code:
                  "Center(\n"
                  "  child: Universal(\n"
                  "    verticalDirection: VerticalDirection.up,\n"
                  "    mainAxisSize: MainAxisSize.min,\n"
                  "    spacing: 6,\n"
                  "    children: const [Text('第一项'), Text('第二项'), Text('第三项')],\n"
                  "  ),\n"
                  ")",
              child: Center(
                child: Universal(
                  verticalDirection: VerticalDirection.up,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: const <Widget>[Text('第一项'), Text('第二项'), Text('第三项')],
                ),
              ),
            ),
            DemoItem(
              title: 'textBaseline',
              description: '仅 CrossAxisAlignment.baseline 时生效，必须同时设置 textBaseline。',
              code:
                  "Universal(\n"
                  "  direction: Axis.horizontal,\n"
                  "  crossAxisAlignment: CrossAxisAlignment.baseline,\n"
                  "  textBaseline: TextBaseline.alphabetic,\n"
                  "  spacing: 8,\n"
                  "  children: const [\n"
                  "    Text('小号', style: TextStyle(fontSize: 14)),\n"
                  "    Text('大号', style: TextStyle(fontSize: 28)),\n"
                  "  ],\n"
                  ")",
              child: Universal(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                spacing: 8,
                children: const <Widget>[
                  Text('小号', style: TextStyle(fontSize: 14)),
                  Text('大号', style: TextStyle(fontSize: 28)),
                ],
              ),
            ),
            DemoItem(
              title: 'expanded / flexible / flex',
              description: 'expanded 与 flexible 互斥；flex 决定主轴占比。',
              code:
                  "Universal(\n"
                  "  direction: Axis.horizontal,\n"
                  "  height: 48,\n"
                  "  spacing: 8,\n"
                  "  crossAxisAlignment: CrossAxisAlignment.stretch,\n"
                  "  children: [\n"
                  "    Universal(expanded: true, flex: 2, color: color),\n"
                  "    Universal(flexible: true, color: color, alignment: Alignment.center, child: const Text('flexible')),\n"
                  "    Universal(width: 64, color: color, alignment: Alignment.center, child: const Text('fixed')),\n"
                  "  ],\n"
                  ")",
              child: Universal(
                direction: Axis.horizontal,
                height: 48,
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Universal(expanded: true, flex: 2, color: colors.primary),
                  Universal(
                    flexible: true,
                    color: colors.tertiaryContainer,
                    alignment: Alignment.center,
                    child: const Text('flexible'),
                  ),
                  Universal(
                    width: 64,
                    color: colors.secondaryContainer,
                    alignment: Alignment.center,
                    child: const Text('fixed'),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Wrap 流式布局',
          description:
              'isWrap / wrapAlignment / runAlignment / spacing / runSpacing / wrapCrossAxisAlignment / clipBehavior。',
          children: [
            DemoItem(
              title: 'Wrap 全套参数',
              description: 'isWrap 与 isStack 互斥；runSpacing 控制行间距。',
              code:
                  "Universal(\n"
                  "  isWrap: true,\n"
                  "  direction: Axis.horizontal,\n"
                  "  wrapAlignment: WrapAlignment.spaceBetween,\n"
                  "  runAlignment: WrapAlignment.center,\n"
                  "  spacing: 8,\n"
                  "  runSpacing: 8,\n"
                  "  wrapCrossAxisAlignment: WrapCrossAlignment.center,\n"
                  "  clipBehavior: Clip.none,\n"
                  "  children: chips,\n"
                  ")",
              child: Universal(
                isWrap: true,
                direction: Axis.horizontal,
                wrapAlignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                wrapCrossAxisAlignment: WrapCrossAlignment.center,
                clipBehavior: Clip.none,
                children: List<Widget>.generate(7, (int index) {
                  return _chip('Chip $index', index.isEven ? colors.primaryContainer : colors.tertiaryContainer);
                }),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Stack 与定位',
          description: 'isStack / stackFit / stackAlignment / left / top / right / bottom / clipBehavior。',
          children: [
            DemoItem(
              title: 'Stack + Positioned',
              description: '未定位子组件受 stackFit / stackAlignment 影响；left/top/right/bottom 会自动变为 Positioned。',
              code:
                  "Universal(\n"
                  "  isStack: true,\n"
                  "  size: const Size(220, 150),\n"
                  "  stackFit: StackFit.expand,\n"
                  "  stackAlignment: AlignmentDirectional.center,\n"
                  "  clipBehavior: Clip.hardEdge,\n"
                  "  color: color,\n"
                  "  children: [\n"
                  "    Universal(color: color),\n"
                  "    Universal(left: 12, top: 12, size: const Size(56, 56), color: color),\n"
                  "    Universal(right: 12, bottom: 12, size: const Size(56, 56), color: color),\n"
                  "  ],\n"
                  ")",
              child: Universal(
                isStack: true,
                size: const Size(220, 150),
                stackFit: StackFit.expand,
                stackAlignment: AlignmentDirectional.center,
                clipBehavior: Clip.hardEdge,
                color: colors.surfaceContainerHighest,
                children: [
                  Universal(color: colors.primaryContainer),
                  Universal(left: 12, top: 12, size: const Size(56, 56), color: colors.primary),
                  Universal(right: 12, bottom: 12, size: const Size(56, 56), color: colors.tertiary),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '裁剪',
          description: 'isClipRRect / isClipRect / isOval / isClipPath / borderRadius / clipper / clipBehavior；四个开关互斥，clipper 类型需与开关匹配。',
          children: [
            DemoItem(
              title: '圆角矩形与圆形',
              description: '圆角使用 isClipRRect + borderRadius；isOval 会忽略 borderRadius。',
              code:
                  "Universal(\n"
                  "  isClipRRect: true,\n"
                  "  borderRadius: BorderRadius.circular(16),\n"
                  "  clipBehavior: Clip.antiAlias,\n"
                  "  size: const Size(150, 76),\n"
                  "  child: overflowChild,\n"
                  ")\n"
                  "Universal(\n"
                  "  isOval: true,\n"
                  "  clipBehavior: Clip.antiAlias,\n"
                  "  size: const Size(76, 76),\n"
                  "  child: overflowChild,\n"
                  ")",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Universal(
                    isClipRRect: true,
                    borderRadius: 16.borderRadiusAll,
                    clipBehavior: Clip.antiAlias,
                    size: const Size(150, 76),
                    child: _overflowStrip(colors),
                  ),
                  Universal(
                    isOval: true,
                    clipBehavior: Clip.antiAlias,
                    size: const Size(76, 76),
                    child: _overflowStrip(colors),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'ClipRect + 自定义 clipper',
              description: 'isClipRect 使用 CustomClipper<Rect>；isClipPath 使用 CustomClipper<Path>。',
              code:
                  "Universal(\n"
                  "  isClipRect: true,\n"
                  "  clipper: _RectClipper(),\n"
                  "  clipBehavior: Clip.hardEdge,\n"
                  "  size: const Size(120, 80),\n"
                  "  child: overflowChild,\n"
                  ")\n"
                  "Universal(\n"
                  "  isClipPath: true,\n"
                  "  clipper: _TriangleClipper(),\n"
                  "  clipBehavior: Clip.antiAlias,\n"
                  "  size: const Size(120, 80),\n"
                  "  child: overflowChild,\n"
                  ")",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Universal(
                    isClipRect: true,
                    clipper: _RectClipper(),
                    clipBehavior: Clip.hardEdge,
                    size: const Size(120, 80),
                    child: _overflowStrip(colors),
                  ),
                  Universal(
                    isClipPath: true,
                    clipper: _TriangleClipper(),
                    clipBehavior: Clip.antiAlias,
                    size: const Size(120, 80),
                    child: _overflowStrip(colors),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '滚动',
          description: 'isScroll / scrollDirection / reverse / physics / primary / dragStartBehavior / keyboardDismissBehavior / clipBehavior / noScrollBehavior / scrollController / restorationId。',
          children: [
            DemoItem(
              title: '横向滚动与滚动配置',
              description: 'noScrollBehavior 为 true 时会关闭滚动边缘发光；scrollDirection 未设置时回退到 direction。',
              code:
                  "Universal(\n"
                  "  isScroll: true,\n"
                  "  direction: Axis.horizontal,\n"
                  "  scrollDirection: Axis.horizontal,\n"
                  "  physics: const BouncingScrollPhysics(),\n"
                  "  primary: false,\n"
                  "  dragStartBehavior: DragStartBehavior.down,\n"
                  "  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,\n"
                  "  clipBehavior: Clip.hardEdge,\n"
                  "  noScrollBehavior: false,\n"
                  "  spacing: 8,\n"
                  "  children: chips,\n"
                  ")",
              child: SizedBox(
                height: 60,
                child: Universal(
                  isScroll: true,
                  direction: Axis.horizontal,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  dragStartBehavior: DragStartBehavior.down,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  clipBehavior: Clip.hardEdge,
                  noScrollBehavior: false,
                  spacing: 8,
                  children: List<Widget>.generate(10, (int index) => _chip('Item $index', colors.primaryContainer)),
                ),
              ),
            ),
            DemoItem(
              title: 'scrollController 与 reverse',
              description: 'reverse 为 true 时从底部开始；restorationId 可用于页面重建后恢复滚动位置。',
              code:
                  "Universal(\n"
                  "  isScroll: true,\n"
                  "  reverse: true,\n"
                  "  height: 120,\n"
                  "  scrollController: controller,\n"
                  "  restorationId: 'universal-scroll',\n"
                  "  children: items,\n"
                  ")",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FlButton(
                        onPressed: () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: const Text('回到起点'),
                      ),
                      8.widthBox,
                      FlButton(
                        onPressed: () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: const Text('回到末尾'),
                      ),
                    ],
                  ),
                  8.heightBox,
                  Universal(
                    isScroll: true,
                    reverse: true,
                    height: 120,
                    scrollController: _scrollController,
                    children: List<Widget>.generate(10, (int index) {
                      return Universal(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        color: index.isEven ? colors.primaryContainer : colors.tertiaryContainer,
                        child: FlText('reverse item $index'),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '安全区与系统 UI',
          description: 'safeLeft / safeTop / safeRight / safeBottom / safeLTRB / systemOverlayStyle / sized。',
          children: [
            DemoItem(
              title: '四边 SafeArea',
              description: 'safeLeft / safeTop / safeRight / safeBottom 可单独开启；在无遮挡区域视觉上可能看不出变化。',
              code:
                  "Universal(\n"
                  "  safeLeft: true,\n"
                  "  safeTop: true,\n"
                  "  safeRight: true,\n"
                  "  safeBottom: true,\n"
                  "  color: color,\n"
                  "  child: const Text('safeLeft / safeTop / safeRight / safeBottom'),\n"
                  ")",
              child: Universal(
                safeLeft: true,
                safeTop: true,
                safeRight: true,
                safeBottom: true,
                padding: const EdgeInsets.all(12),
                color: colors.surfaceContainerHighest,
                child: const Text('safeLeft / safeTop / safeRight / safeBottom'),
              ),
            ),
            DemoItem(
              title: 'safeLTRB 与 systemOverlayStyle',
              description: 'safeLTRB 一次开启四边；systemOverlayStyle 通过 AnnotatedRegion 控制状态栏，sized 决定区域是否贴合子组件。',
              code:
                  "Universal(\n"
                  "  safeLTRB: true,\n"
                  "  systemOverlayStyle: SystemUiOverlayStyle.dark,\n"
                  "  sized: false,\n"
                  "  color: color,\n"
                  "  padding: const EdgeInsets.all(12),\n"
                  "  child: const Text('safeLTRB + AnnotatedRegion'),\n"
                  ")",
              child: Universal(
                safeLTRB: true,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                sized: false,
                color: Colors.black87,
                padding: const EdgeInsets.all(12),
                child: const Text('safeLTRB + AnnotatedRegion', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '按钮体系',
          description: 'buttonCategory / onPressed / onHover / onFocusChange / style / focusNode / autofocus / statesController。',
          children: [
            DemoItem(
              title: '五种 buttonCategory',
              description: 'buttonCategory 非空时使用 FlButton；onPressed 为空会得到禁用态按钮。',
              code:
                  "Universal(buttonCategory: FlButtonCategory.none, onPressed: () {}, child: const Text('none'))\n"
                  "Universal(buttonCategory: FlButtonCategory.filled, onPressed: () {}, child: const Text('filled'))\n"
                  "Universal(buttonCategory: FlButtonCategory.filledTonal, onPressed: () {}, child: const Text('filledTonal'))\n"
                  "Universal(buttonCategory: FlButtonCategory.elevated, onPressed: () {}, child: const Text('elevated'))\n"
                  "Universal(buttonCategory: FlButtonCategory.outlined, onPressed: () {}, child: const Text('outlined'))",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FlButtonCategory.values.map((FlButtonCategory category) {
                  return Universal(buttonCategory: category, onPressed: () {}, child: Text(category.name));
                }).toList(),
              ),
            ),
            DemoItem(
              title: '按钮交互全套参数',
              description: '聚焦、悬浮、状态控制器与自定义样式可以同时使用。',
              code:
                  "Universal(\n"
                  "  buttonCategory: FlButtonCategory.filled,\n"
                  "  onPressed: () => setState(() => _buttonCount++),\n"
                  "  onHover: (hovered) => setState(() => _hovered = hovered),\n"
                  "  onFocusChange: (focused) => setState(() => _focused = focused),\n"
                  "  style: FilledButton.styleFrom(backgroundColor: color),\n"
                  "  focusNode: _buttonFocusNode,\n"
                  "  autofocus: true,\n"
                  "  statesController: _buttonStates,\n"
                  "  child: Text('点击 \$_buttonCount 次'),\n"
                  ")",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Universal(
                    buttonCategory: FlButtonCategory.filled,
                    onPressed: () => setState(() => _buttonCount++),
                    onHover: (bool hovered) => setState(() => _hovered = hovered),
                    onFocusChange: (bool focused) => setState(() => _focused = focused),
                    style: FilledButton.styleFrom(backgroundColor: colors.primary),
                    focusNode: _buttonFocusNode,
                    autofocus: true,
                    statesController: _buttonStates,
                    child: Text('点击 $_buttonCount 次'),
                  ),
                  8.heightBox,
                  FlText('hovered: $_hovered / focused: $_focused'),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '手势',
          description:
              '每个手势家族上方单独显示该家族最近触发的回调；'
              'tap / doubleTap / longPress / drag / pan / scale / forcePress / secondary / tertiary 全部直接透传给 GestureDetector。',
          children: [
            _gestureHint(colors, 'tap'),
            8.heightBox,
            DemoItem(
              title: 'Tap 家族 + 命中配置',
              description: 'behavior / excludeFromSemantics / supportedDevices / dragStartBehavior 同时演示。',
              code:
                  "Universal(\n"
                  "  onTap: () => record('onTap'),\n"
                  "  onTapDown: (_) => record('onTapDown'),\n"
                  "  onTapUp: (_) => record('onTapUp'),\n"
                  "  onTapCancel: () => record('onTapCancel'),\n"
                  "  onDoubleTap: () => record('onDoubleTap'),\n"
                  "  onDoubleTapDown: (_) => record('onDoubleTapDown'),\n"
                  "  onDoubleTapCancel: () => record('onDoubleTapCancel'),\n"
                  "  behavior: HitTestBehavior.translucent,\n"
                  "  excludeFromSemantics: true,\n"
                  "  supportedDevices: const {\n"
                  "    PointerDeviceKind.touch,\n"
                  "    PointerDeviceKind.mouse,\n"
                  "    PointerDeviceKind.stylus,\n"
                  "  },\n"
                  "  dragStartBehavior: DragStartBehavior.down,\n"
                  "  child: const Text('Tap / Double Tap'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Tap / Double Tap / Cancel',
                onTap: () => _record('onTap'),
                onTapDown: (TapDownDetails _) => _record('onTapDown'),
                onTapUp: (TapUpDetails _) => _record('onTapUp'),
                onTapCancel: () => _record('onTapCancel'),
                onDoubleTap: () => _record('onDoubleTap'),
                onDoubleTapDown: (TapDownDetails _) => _record('onDoubleTapDown'),
                onDoubleTapCancel: () => _record('onDoubleTapCancel'),
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                supportedDevices: const <PointerDeviceKind>{
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                },
                dragStartBehavior: DragStartBehavior.down,
              ),
            ),
            _gestureHint(colors, 'longPress'),
            8.heightBox,
            DemoItem(
              title: 'LongPress 家族',
              description: '长按 500ms 后依次触发 down → start →（moveUpdate）→ up → end。',
              code:
                  "Universal(\n"
                  "  onLongPress: () => record('onLongPress'),\n"
                  "  onLongPressDown: (_) => record('onLongPressDown'),\n"
                  "  onLongPressStart: (_) => record('onLongPressStart'),\n"
                  "  onLongPressMoveUpdate: (_) => record('onLongPressMoveUpdate'),\n"
                  "  onLongPressUp: () => record('onLongPressUp'),\n"
                  "  onLongPressEnd: (_) => record('onLongPressEnd'),\n"
                  "  onLongPressCancel: () => record('onLongPressCancel'),\n"
                  "  child: const Text('Long Press'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Long Press',
                onLongPress: () => _record('onLongPress'),
                onLongPressDown: (LongPressDownDetails _) => _record('onLongPressDown'),
                onLongPressStart: (LongPressStartDetails _) => _record('onLongPressStart'),
                onLongPressMoveUpdate: (LongPressMoveUpdateDetails _) => _record('onLongPressMoveUpdate'),
                onLongPressUp: () => _record('onLongPressUp'),
                onLongPressEnd: (LongPressEndDetails _) => _record('onLongPressEnd'),
                onLongPressCancel: () => _record('onLongPressCancel'),
              ),
            ),
            _gestureHint(colors, 'drag'),
            8.heightBox,
            DemoItem(
              title: '垂直 / 水平拖拽',
              description: '垂直与水平拖拽可以同时存在，手势竞技场会根据首次移动方向选择。',
              code:
                  "Universal(\n"
                  "  onVerticalDragDown: (_) => record('onVerticalDragDown'),\n"
                  "  onVerticalDragStart: (_) => record('onVerticalDragStart'),\n"
                  "  onVerticalDragUpdate: (_) => record('onVerticalDragUpdate'),\n"
                  "  onVerticalDragEnd: (_) => record('onVerticalDragEnd'),\n"
                  "  onVerticalDragCancel: () => record('onVerticalDragCancel'),\n"
                  "  onHorizontalDragDown: (_) => record('onHorizontalDragDown'),\n"
                  "  onHorizontalDragStart: (_) => record('onHorizontalDragStart'),\n"
                  "  onHorizontalDragUpdate: (_) => record('onHorizontalDragUpdate'),\n"
                  "  onHorizontalDragEnd: (_) => record('onHorizontalDragEnd'),\n"
                  "  onHorizontalDragCancel: () => record('onHorizontalDragCancel'),\n"
                  "  child: const Text('Drag me'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Drag me',
                onVerticalDragDown: (DragDownDetails _) => _record('onVerticalDragDown'),
                onVerticalDragStart: (DragStartDetails _) => _record('onVerticalDragStart'),
                onVerticalDragUpdate: (DragUpdateDetails _) => _record('onVerticalDragUpdate'),
                onVerticalDragEnd: (DragEndDetails _) => _record('onVerticalDragEnd'),
                onVerticalDragCancel: () => _record('onVerticalDragCancel'),
                onHorizontalDragDown: (DragDownDetails _) => _record('onHorizontalDragDown'),
                onHorizontalDragStart: (DragStartDetails _) => _record('onHorizontalDragStart'),
                onHorizontalDragUpdate: (DragUpdateDetails _) => _record('onHorizontalDragUpdate'),
                onHorizontalDragEnd: (DragEndDetails _) => _record('onHorizontalDragEnd'),
                onHorizontalDragCancel: () => _record('onHorizontalDragCancel'),
              ),
            ),
            _gestureHint(colors, 'pan'),
            8.heightBox,
            DemoItem(
              title: 'Pan 家族',
              description: 'pan 与 scale 互斥，不能同时设置；pan 会优先于单方向拖拽。',
              code:
                  "Universal(\n"
                  "  onPanDown: (_) => record('onPanDown'),\n"
                  "  onPanStart: (_) => record('onPanStart'),\n"
                  "  onPanUpdate: (_) => record('onPanUpdate'),\n"
                  "  onPanEnd: (_) => record('onPanEnd'),\n"
                  "  onPanCancel: () => record('onPanCancel'),\n"
                  "  child: const Text('Pan me'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Pan me',
                onPanDown: (DragDownDetails _) => _record('onPanDown'),
                onPanStart: (DragStartDetails _) => _record('onPanStart'),
                onPanUpdate: (DragUpdateDetails _) => _record('onPanUpdate'),
                onPanEnd: (DragEndDetails _) => _record('onPanEnd'),
                onPanCancel: () => _record('onPanCancel'),
              ),
            ),
            _gestureHint(colors, 'scale'),
            8.heightBox,
            DemoItem(
              title: 'Scale 家族 + 触控板',
              description: 'trackpadScrollCausesScale 让触控板滚动转为缩放，trackpadScrollToScaleFactor 控制转换比例。',
              code:
                  "Universal(\n"
                  "  onScaleStart: (_) => record('onScaleStart'),\n"
                  "  onScaleUpdate: (_) => record('onScaleUpdate'),\n"
                  "  onScaleEnd: (_) => record('onScaleEnd'),\n"
                  "  trackpadScrollCausesScale: true,\n"
                  "  trackpadScrollToScaleFactor: const Offset(0.01, 0.01),\n"
                  "  child: const Text('Scale me'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Scale me',
                onScaleStart: (ScaleStartDetails _) => _record('onScaleStart'),
                onScaleUpdate: (ScaleUpdateDetails _) => _record('onScaleUpdate'),
                onScaleEnd: (ScaleEndDetails _) => _record('onScaleEnd'),
                trackpadScrollCausesScale: true,
                trackpadScrollToScaleFactor: const Offset(0.01, 0.01),
              ),
            ),
            _gestureHint(colors, 'forcePress'),
            8.heightBox,
            DemoItem(
              title: 'ForcePress 家族',
              description: '仅在支持压感的设备上会触发，桌面鼠标通常不会触发。',
              code:
                  "Universal(\n"
                  "  onForcePressStart: (_) => record('onForcePressStart'),\n"
                  "  onForcePressPeak: (_) => record('onForcePressPeak'),\n"
                  "  onForcePressUpdate: (_) => record('onForcePressUpdate'),\n"
                  "  onForcePressEnd: (_) => record('onForcePressEnd'),\n"
                  "  child: const Text('Force Press'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Force Press',
                onForcePressStart: (ForcePressDetails _) => _record('onForcePressStart'),
                onForcePressPeak: (ForcePressDetails _) => _record('onForcePressPeak'),
                onForcePressUpdate: (ForcePressDetails _) => _record('onForcePressUpdate'),
                onForcePressEnd: (ForcePressDetails _) => _record('onForcePressEnd'),
              ),
            ),
            _gestureHint(colors, 'secondary'),
            8.heightBox,
            DemoItem(
              title: 'Secondary 手势',
              description: '鼠标右键等次要触摸；长按家族与 tap 家族可同时存在。',
              code:
                  "Universal(\n"
                  "  onSecondaryTapDown: (_) => record('onSecondaryTapDown'),\n"
                  "  onSecondaryTapUp: (_) => record('onSecondaryTapUp'),\n"
                  "  onSecondaryTapCancel: () => record('onSecondaryTapCancel'),\n"
                  "  onSecondaryTap: () => record('onSecondaryTap'),\n"
                  "  onSecondaryLongPressDown: (_) => record('onSecondaryLongPressDown'),\n"
                  "  onSecondaryLongPressStart: (_) => record('onSecondaryLongPressStart'),\n"
                  "  onSecondaryLongPressMoveUpdate: (_) => record('onSecondaryLongPressMoveUpdate'),\n"
                  "  onSecondaryLongPress: () => record('onSecondaryLongPress'),\n"
                  "  onSecondaryLongPressUp: () => record('onSecondaryLongPressUp'),\n"
                  "  onSecondaryLongPressEnd: (_) => record('onSecondaryLongPressEnd'),\n"
                  "  onSecondaryLongPressCancel: () => record('onSecondaryLongPressCancel'),\n"
                  "  child: const Text('Right Click'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Right Click',
                onSecondaryTapDown: (TapDownDetails _) => _record('onSecondaryTapDown'),
                onSecondaryTapUp: (TapUpDetails _) => _record('onSecondaryTapUp'),
                onSecondaryTapCancel: () => _record('onSecondaryTapCancel'),
                onSecondaryTap: () => _record('onSecondaryTap'),
                onSecondaryLongPressDown: (LongPressDownDetails _) => _record('onSecondaryLongPressDown'),
                onSecondaryLongPressStart: (LongPressStartDetails _) => _record('onSecondaryLongPressStart'),
                onSecondaryLongPressMoveUpdate: (LongPressMoveUpdateDetails _) {
                  _record('onSecondaryLongPressMoveUpdate');
                },
                onSecondaryLongPress: () => _record('onSecondaryLongPress'),
                onSecondaryLongPressUp: () => _record('onSecondaryLongPressUp'),
                onSecondaryLongPressEnd: (LongPressEndDetails _) => _record('onSecondaryLongPressEnd'),
                onSecondaryLongPressCancel: () => _record('onSecondaryLongPressCancel'),
              ),
            ),
            _gestureHint(colors, 'tertiary'),
            8.heightBox,
            DemoItem(
              title: 'Tertiary 手势',
              description: '第三个触摸点的点击与长按；多指设备上可观察到回调。',
              code:
                  "Universal(\n"
                  "  onTertiaryTapDown: (_) => record('onTertiaryTapDown'),\n"
                  "  onTertiaryTapUp: (_) => record('onTertiaryTapUp'),\n"
                  "  onTertiaryTapCancel: () => record('onTertiaryTapCancel'),\n"
                  "  onTertiaryLongPressDown: (_) => record('onTertiaryLongPressDown'),\n"
                  "  onTertiaryLongPressStart: (_) => record('onTertiaryLongPressStart'),\n"
                  "  onTertiaryLongPressMoveUpdate: (_) => record('onTertiaryLongPressMoveUpdate'),\n"
                  "  onTertiaryLongPressUp: () => record('onTertiaryLongPressUp'),\n"
                  "  onTertiaryLongPressEnd: (_) => record('onTertiaryLongPressEnd'),\n"
                  "  onTertiaryLongPressCancel: () => record('onTertiaryLongPressCancel'),\n"
                  "  onTertiaryLongPress: () => record('onTertiaryLongPress'),\n"
                  "  child: const Text('Third Finger'),\n"
                  ")",
              child: _gestureTile(
                colors,
                'Third Finger',
                onTertiaryTapDown: (TapDownDetails _) => _record('onTertiaryTapDown'),
                onTertiaryTapUp: (TapUpDetails _) => _record('onTertiaryTapUp'),
                onTertiaryTapCancel: () => _record('onTertiaryTapCancel'),
                onTertiaryLongPressDown: (LongPressDownDetails _) => _record('onTertiaryLongPressDown'),
                onTertiaryLongPressStart: (LongPressStartDetails _) => _record('onTertiaryLongPressStart'),
                onTertiaryLongPressMoveUpdate: (LongPressMoveUpdateDetails _) {
                  _record('onTertiaryLongPressMoveUpdate');
                },
                onTertiaryLongPressUp: () => _record('onTertiaryLongPressUp'),
                onTertiaryLongPressEnd: (LongPressEndDetails _) => _record('onTertiaryLongPressEnd'),
                onTertiaryLongPressCancel: () => _record('onTertiaryLongPressCancel'),
                onTertiaryLongPress: () => _record('onTertiaryLongPress'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Hero 转场',
          description:
              'heroTag / createRectTween / flightShuttleBuilder / transitionOnUserGestures / placeholderBuilder。',
          children: [
            DemoItem(
              title: 'Hero 全套参数',
              description:
                  'Hero 需要在两个路由中使用相同的 heroTag；点击按钮打开目标页观察转场。'
                  'flightShuttleBuilder 运行在 Overlay 中，文字需要显式样式或自行包裹 Material。',
              code:
                  "Universal(\n"
                  "  heroTag: 'universal-hero',\n"
                  "  createRectTween: (begin, end) => MaterialRectArcTween(begin: begin, end: end),\n"
                  "  flightShuttleBuilder: (context, animation, direction, from, to) {\n"
                  "    return const ColoredBox(\n"
                  "      color: Colors.amber,\n"
                  "      child: Center(\n"
                  "        child: Text('Flying', style: TextStyle(color: Colors.black, fontSize: 16)),\n"
                  "      ),\n"
                  "    );\n"
                  "  },\n"
                  "  transitionOnUserGestures: true,\n"
                  "  placeholderBuilder: (context, size, child) => SizedBox.fromSize(size: size, child: child),\n"
                  "  size: const Size(120, 80),\n"
                  "  color: color,\n"
                  "  alignment: Alignment.center,\n"
                  "  child: const Text('Hero'),\n"
                  ")",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Universal(
                    heroTag: 'universal-hero',
                    createRectTween: (Rect? begin, Rect? end) => MaterialRectArcTween(begin: begin, end: end),
                    flightShuttleBuilder:
                        (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return const ColoredBox(
                            color: Colors.amber,
                            child: Center(
                              child: Text(
                                'Flying',
                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        },
                    transitionOnUserGestures: true,
                    placeholderBuilder: (BuildContext context, Size size, Widget child) {
                      return SizedBox.fromSize(size: size, child: child);
                    },
                    size: const Size(120, 80),
                    color: colors.primary,
                    alignment: Alignment.center,
                    child: const Text('Hero', style: TextStyle(color: Colors.white)),
                  ),
                  10.heightBox,
                  FlButton(
                    onPressed: () => unawaited(const _HeroTargetPage().push()),
                    child: const Text('打开 Hero 目标页'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _gestureTile(
    ColorScheme colors,
    String label, {
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCancelCallback? onTapCancel,
    GestureTapCallback? onDoubleTap,
    GestureTapDownCallback? onDoubleTapDown,
    GestureTapCancelCallback? onDoubleTapCancel,
    GestureLongPressCallback? onLongPress,
    GestureLongPressDownCallback? onLongPressDown,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressCancelCallback? onLongPressCancel,
    GestureDragDownCallback? onVerticalDragDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragDownCallback? onHorizontalDragDown,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureDragDownCallback? onPanDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    GestureTapCancelCallback? onSecondaryTapCancel,
    GestureTapCallback? onSecondaryTap,
    GestureLongPressDownCallback? onSecondaryLongPressDown,
    GestureLongPressStartCallback? onSecondaryLongPressStart,
    GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate,
    GestureLongPressCallback? onSecondaryLongPress,
    GestureLongPressCallback? onSecondaryLongPressUp,
    GestureLongPressEndCallback? onSecondaryLongPressEnd,
    GestureLongPressCancelCallback? onSecondaryLongPressCancel,
    GestureTapDownCallback? onTertiaryTapDown,
    GestureTapUpCallback? onTertiaryTapUp,
    GestureTapCancelCallback? onTertiaryTapCancel,
    GestureLongPressDownCallback? onTertiaryLongPressDown,
    GestureLongPressStartCallback? onTertiaryLongPressStart,
    GestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate,
    GestureLongPressUpCallback? onTertiaryLongPressUp,
    GestureLongPressEndCallback? onTertiaryLongPressEnd,
    GestureLongPressCancelCallback? onTertiaryLongPressCancel,
    GestureLongPressCallback? onTertiaryLongPress,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    bool excludeFromSemantics = false,
    Set<PointerDeviceKind>? supportedDevices,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool trackpadScrollCausesScale = false,
    Offset trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
  }) {
    return Universal(
      padding: const EdgeInsets.all(14),
      color: colors.secondaryContainer,
      alignment: Alignment.center,
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onDoubleTap: onDoubleTap,
      onDoubleTapDown: onDoubleTapDown,
      onDoubleTapCancel: onDoubleTapCancel,
      onLongPress: onLongPress,
      onLongPressDown: onLongPressDown,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressUp: onLongPressUp,
      onLongPressEnd: onLongPressEnd,
      onLongPressCancel: onLongPressCancel,
      onVerticalDragDown: onVerticalDragDown,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
      onHorizontalDragDown: onHorizontalDragDown,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragCancel: onHorizontalDragCancel,
      onPanDown: onPanDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      onForcePressStart: onForcePressStart,
      onForcePressPeak: onForcePressPeak,
      onForcePressUpdate: onForcePressUpdate,
      onForcePressEnd: onForcePressEnd,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onSecondaryTap: onSecondaryTap,
      onSecondaryLongPressDown: onSecondaryLongPressDown,
      onSecondaryLongPressStart: onSecondaryLongPressStart,
      onSecondaryLongPressMoveUpdate: onSecondaryLongPressMoveUpdate,
      onSecondaryLongPress: onSecondaryLongPress,
      onSecondaryLongPressUp: onSecondaryLongPressUp,
      onSecondaryLongPressEnd: onSecondaryLongPressEnd,
      onSecondaryLongPressCancel: onSecondaryLongPressCancel,
      onTertiaryTapDown: onTertiaryTapDown,
      onTertiaryTapUp: onTertiaryTapUp,
      onTertiaryTapCancel: onTertiaryTapCancel,
      onTertiaryLongPressDown: onTertiaryLongPressDown,
      onTertiaryLongPressStart: onTertiaryLongPressStart,
      onTertiaryLongPressMoveUpdate: onTertiaryLongPressMoveUpdate,
      onTertiaryLongPressUp: onTertiaryLongPressUp,
      onTertiaryLongPressEnd: onTertiaryLongPressEnd,
      onTertiaryLongPressCancel: onTertiaryLongPressCancel,
      onTertiaryLongPress: onTertiaryLongPress,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      supportedDevices: supportedDevices,
      dragStartBehavior: dragStartBehavior,
      trackpadScrollCausesScale: trackpadScrollCausesScale,
      trackpadScrollToScaleFactor: trackpadScrollToScaleFactor,
      child: Text(label),
    );
  }

  Widget _overflowStrip(ColorScheme colors) => Universal(
    width: 220,
    height: 140,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[colors.primary, colors.tertiary, colors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    alignment: Alignment.center,
    child: const Text('overflow content', style: TextStyle(color: Colors.white)),
  );
}

class _HeroTargetPage extends StatelessWidget {
  const _HeroTargetPage();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Hero 目标页')),
      body: Center(
        child: Universal(
          heroTag: 'universal-hero',
          size: const Size(180, 120),
          color: colors.primary,
          alignment: Alignment.center,
          child: const Text('目标页 Hero', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width, size.height * 0.62);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
