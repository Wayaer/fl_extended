import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class WidgetExtensionPage extends StatelessWidget {
  const WidgetExtensionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Widget Extensions',
      description:
          '以链式调用快速包裹 Padding、SizedBox、Clip、GestureDetector、DecoratedBox 等常用组件。'
          '所有方法都返回 Widget，可直接继续链式组合。',
      sections: [
        DemoSection(
          title: '间距与尺寸',
          children: [
            DemoItem(
              title: 'padding / margin',
              code:
                  "const Text('content')\n"
                  "  .padding(EdgeInsets.all(12))\n"
                  "  .margin(EdgeInsets.symmetric(vertical: 8));\n\n"
                  "const Text('content').paddingAll(12);\n"
                  "const Text('content').paddingSymmetric(horizontal: 16, vertical: 8);\n"
                  "const Text('content').paddingOnly(left: 8, top: 4);",
              child: Container(
                color: colors.surfaceContainerHighest,
                child: const Text('content')
                    .padding(const EdgeInsets.all(12))
                    .margin(const EdgeInsets.symmetric(vertical: 8)),
              ),
            ),
            DemoItem(
              title: 'sizedBox / setSize / aspectRatio',
              code:
                  "const FlText('box').sizedBox(width: 120, height: 40);\n"
                  "const FlText('box').setWidth(120);\n"
                  "const FlText('box').setHeight(40);\n"
                  "const FlText('box').setSize(Size(120, 40));\n"
                  "const FlText('box').aspectRatio(16 / 9);",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const FlText('sizedBox').sizedBox(width: 90, height: 36).color(colors.primaryContainer),
                  const FlText('setWidth').setWidth(100).color(colors.secondaryContainer),
                  const FlText('setHeight').setHeight(40).color(colors.tertiaryContainer),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '装饰与裁剪',
          children: [
            DemoItem(
              title: 'color / card / decoratedBox',
              code:
                  "const FlText('color').color(Colors.blue);\n"
                  "const FlText('card').card(elevation: 2);\n"
                  "const FlText('decoration').decoratedBox(\n"
                  "  BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),\n"
                  ");",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const FlText('color', color: Colors.white).paddingAll(8).color(Colors.blue),
                  const FlText('card').paddingAll(10).card(elevation: 1),
                  const FlText('decoration')
                      .paddingAll(10)
                      .decoratedBox(
                        BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                ],
              ),
            ),
            DemoItem(
              title: 'clipRRect / clipOval / clipPath',
              code:
                  "const FlText('clip').clipRRect(borderRadius: BorderRadius.circular(12));\n"
                  "const FlText('clip').clipOval();\n"
                  "const FlText('clip').clipPath(clipper: _TriangleClipper());",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const FlText(
                    'rr',
                    color: Colors.white,
                  ).paddingAll(14).color(Colors.indigo).clipRRect(borderRadius: 12.borderRadiusAll),
                  const FlText('oval', color: Colors.white).paddingAll(14).color(Colors.teal).clipOval(),
                ],
              ),
            ),
            DemoItem(
              title: 'BorderRadius / Border / Shadow / Gradient',
              code:
                  "BorderRadius.circular(12).toBoxDecoration();\n"
                  "Border.all(color: Colors.blue).toBoxDecoration();\n"
                  "[BoxShadow(color: Colors.black12, blurRadius: 8)].toBoxDecoration();\n"
                  "BoxShape.circle.toBoxDecoration();\n"
                  "LinearGradient(colors: [Colors.red, Colors.blue]).toBoxDecoration();",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: 12.borderRadiusAll.toBoxDecoration().copyWith(color: colors.primaryContainer),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: Border.all(color: colors.primary).toBoxDecoration(),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: <BoxShadow>[const BoxShadow(color: Colors.black26, blurRadius: 8)]
                        .toBoxDecoration()
                        .copyWith(color: Colors.white),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxShape.circle.toBoxDecoration().copyWith(color: colors.tertiary),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const LinearGradient(colors: <Color>[Colors.red, Colors.blue]).toBoxDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '布局与定位',
          children: [
            DemoItem(
              title: 'center / align / expanded / flexible',
              code:
                  "const FlText('center').center();\n"
                  "const FlText('align').align(alignment: Alignment.centerRight);\n"
                  "const FlText('expanded').expanded;",
              child: Column(
                children: [
                  const FlText('center').center().setHeight(40).color(colors.surfaceContainerHighest),
                  8.heightBox,
                  const FlText('align')
                      .align(alignment: Alignment.centerRight)
                      .setHeight(40)
                      .color(colors.surfaceContainerHighest),
                ],
              ),
            ),
            DemoItem(
              title: 'positioned',
              code:
                  "Stack(children: [\n"
                  "  const FlText('A').positioned(left: 12, top: 12),\n"
                  "  const FlText('B').positioned(right: 12, bottom: 12),\n"
                  "]);",
              child: SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    const FlText('A').paddingAll(6).color(colors.primaryContainer).positioned(left: 12, top: 12),
                    const FlText('B').paddingAll(6).color(colors.secondaryContainer).positioned(right: 12, bottom: 12),
                  ],
                ),
              ),
            ),
            DemoItem(
              title: 'setPreferredHeight',
              code:
                  "appBar: PreferredSize(\n"
                  "  preferredSize: Size.fromHeight(56),\n"
                  "  child: customAppBar,\n"
                  ");\n\n"
                  "customAppBar.setPreferredHeight(56);",
              child: const DemoValues([
                DemoValue('setPreferredSize', 'PreferredSize(preferredSize: size)'),
                DemoValue('setPreferredHeight', 'Size.fromHeight(height)'),
                DemoValue('setPreferredWidth', 'Size.fromWidth(width)'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '手势与视觉效果',
          children: [
            DemoItem(
              title: 'onTap / onDoubleTap / onLongPress',
              code:
                  "const FlText('tap')\n"
                  "  .paddingAll(12)\n"
                  "  .color(Colors.blue)\n"
                  "  .gestureDetector(\n"
                  "    onTap: () => log('tap'),\n"
                  "    onDoubleTap: () => log('double tap'),\n"
                  "    onLongPress: () => log('long press'),\n"
                  "  );",
              note:
                  '连续链式调用时请使用 gestureDetector 一次性传入多个回调，'
                  '因为 GestureDetector 自身已有 onTap / onDoubleTap 同名字段。',
              child: FlText('点我')
                  .paddingAll(12)
                  .color(colors.primary)
                  .clipRRect(borderRadius: 10.borderRadiusAll)
                  .gestureDetector(
                    onTap: () => showToast('onTap'),
                    onDoubleTap: () => showToast('onDoubleTap'),
                    onLongPress: () => showToast('onLongPress'),
                  ),
            ),
            DemoItem(
              title: 'backdropFilter / fittedBox / opacity / rotate',
              code:
                  "const FlText('blur').backdropFilter(fuzzyDegree: 6);\n"
                  "const FlText('fit').fittedBox(fit: BoxFit.contain);\n"
                  "const FlText('rot').rotatedBox(1);",
              child: const DemoValues([
                DemoValue('backdropFilter', 'BackdropFilter + ImageFilter.blur'),
                DemoValue('fittedBox', 'FittedBox 包裹'),
                DemoValue('rotatedBox', 'RotatedBox(quarterTurns)'),
                DemoValue('visibility / offstage', 'Visibility / Offstage'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '转换与 Builder',
          description: 'Widget 可直接转为各种回调或 Sliver，方便接入第三方组件。',
          children: [
            const DemoItem(
              child: DemoValues([
                DemoValue('toSliverBox', 'SliverToBoxAdapter'),
                DemoValue('toWidgetBuilder', '(context) => widget'),
                DemoValue('toRoutePageBuilder', 'RoutePageBuilder'),
                DemoValue('toRouteTransitionsBuilder', 'RouteTransitionsBuilder'),
                DemoValue('toToastBuilder', 'ToastBuilder'),
                DemoValue('toLoadingBuilder', 'LoadingBuilder'),
                DemoValue('statusBarStyle', 'AnnotatedRegion<SystemUiOverlayStyle>'),
                DemoValue('hero', 'Hero(tag: tag)'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
