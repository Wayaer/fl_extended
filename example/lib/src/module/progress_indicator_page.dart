import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorPage extends StatefulWidget {
  const ProgressIndicatorPage({super.key});

  @override
  State<ProgressIndicatorPage> createState() => _ProgressIndicatorPageState();
}

class _ProgressIndicatorPageState extends State<ProgressIndicatorPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _color = ColorTween(begin: Colors.red, end: Colors.greenAccent).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animated(Widget Function() builder) =>
      AnimatedBuilder(animation: _controller, builder: (BuildContext context, Widget? child) => builder());

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'FlProgressIndicator',
      description:
          '通过 ProgressIndicatorOptions 统一配置线性、环形与下拉刷新进度；'
          'ProgressIndicatorStyle.options 可快速拿到默认配置，.widget 直接构建组件。',
      sections: [
        DemoSection(
          title: '线性进度',
          description: 'value 为 null 时展示不确定进度；borderRadius 与 minHeight 控制外观。',
          children: [
            DemoItem(
              title: 'linear',
              code:
                  "ProgressIndicatorOptions.linear(\n"
                  "  height: 10,\n"
                  "  value: controller.value,\n"
                  "  valueColor: animationColor,\n"
                  "  backgroundColor: Colors.amber,\n"
                  "  borderRadius: BorderRadius.circular(10),\n"
                  ").widget",
              child: _animated(
                () => ProgressIndicatorOptions.linear(
                  height: 10,
                  value: _controller.value,
                  valueColor: _color,
                  backgroundColor: colors.surfaceContainerHighest,
                  borderRadius: 10.borderRadiusAll,
                ).widget,
              ),
            ),
            DemoItem(
              title: '不确定进度',
              code: "const FlProgressIndicator(ProgressIndicatorOptions.linear())",
              child: const FlProgressIndicator(ProgressIndicatorOptions.linear()),
            ),
          ],
        ),
        DemoSection(
          title: '环形进度',
          description: 'strokeWidth / strokeAlign / strokeCap 控制描边。',
          children: [
            DemoItem(
              title: 'circular',
              code:
                  "ProgressIndicatorOptions.circular(\n"
                  "  width: 100,\n"
                  "  height: 100,\n"
                  "  strokeWidth: 6,\n"
                  "  strokeCap: StrokeCap.round,\n"
                  "  value: controller.value,\n"
                  "  valueColor: animationColor,\n"
                  ").widget",
              child: _animated(
                () => Center(
                  child: ProgressIndicatorOptions.circular(
                    width: 100,
                    height: 100,
                    strokeWidth: 6,
                    strokeAlign: 2,
                    strokeCap: StrokeCap.round,
                    value: _controller.value,
                    valueColor: _color,
                    backgroundColor: colors.surfaceContainerHighest,
                  ).widget,
                ),
              ),
            ),
            DemoItem(
              title: '不确定环形',
              code: "ProgressIndicatorStyle.circular.options.widget",
              child: const Center(
                child: FlProgressIndicator(ProgressIndicatorOptions.circular()),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '下拉刷新进度',
          description: 'RefreshProgressIndicator 额外支持 elevation、indicatorMargin 与 indicatorPadding。',
          children: [
            DemoItem(
              title: 'refresh',
              description:
                  'width / height 控制外层占位；RefreshProgressIndicator 的图形尺寸由内部 41px 与 '
                  'indicatorMargin / indicatorPadding 决定，并始终要求正方形。',
              code:
                  "ProgressIndicatorOptions.refresh(\n"
                  "  width: 80,\n"
                  "  height: 80,\n"
                  "  value: controller.value,\n"
                  "  valueColor: animationColor,\n"
                  "  elevation: 4,\n"
                  "  indicatorMargin: EdgeInsets.all(8),\n"
                  "  indicatorPadding: EdgeInsets.all(8),\n"
                  ").widget",
              child: _animated(
                () => Center(
                  child: ProgressIndicatorOptions.refresh(
                    width: 80,
                    height: 80,
                    value: _controller.value,
                    valueColor: _color,
                    elevation: 4,
                    indicatorMargin: const EdgeInsets.all(8),
                    indicatorPadding: const EdgeInsets.all(8),
                  ).widget,
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '配置速查',
          children: [
            const DemoItem(
              title: '选项字段',
              child: DemoValues([
                DemoValue('style', 'linear / circular / refresh'),
                DemoValue('value', '0.0 ~ 1.0，null 表示不确定'),
                DemoValue('color / valueColor', '前景色与动画色'),
                DemoValue('backgroundColor', '轨道背景色'),
                DemoValue('minHeight / borderRadius', '仅 linear'),
                DemoValue('strokeWidth / strokeAlign / strokeCap', '仅 circular / refresh'),
                DemoValue('elevation / indicatorMargin / indicatorPadding', '仅 refresh'),
                DemoValue('width / height', '外层 SizedBox 尺寸'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
