import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  final Map<FlAnimationStyle, Function> _runners = <FlAnimationStyle, Function>{};

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'FlAnimation',
      description:
          '轻量动画组件：淡入淡出、水平晃动、垂直晃动。支持延迟、停留、反向、次数与循环，'
          'onAnimate 会返回一个可手动重播的函数。',
      sections: [
        DemoSection(
          title: '动画样式',
          description: '点击预览区域可再次触发“正向 + 停留 + 反向”。',
          children: [
            _animationItem(
              context,
              style: FlAnimationStyle.fade,
              title: 'fade 淡入淡出',
              description: '从透明到不透明，停留后反向淡出。',
            ),
            _animationItem(
              context,
              style: FlAnimationStyle.horizontalHunting,
              title: 'horizontalHunting 水平晃动',
              description: '向左偏移 10px 再回到右侧，适合提示错误输入。',
            ),
            _animationItem(
              context,
              style: FlAnimationStyle.verticalHunting,
              title: 'verticalHunting 垂直晃动',
              description: '上下移动，适合“摇一摇”或轻量提示。',
            ),
          ],
        ),
        DemoSection(
          title: '循环播放',
          description: 'repeat 为 true 时持续播放，直到组件销毁。',
          children: [
            DemoItem(
              title: 'repeat',
              code:
                  "FlAnimation(\n"
                  "  style: FlAnimationStyle.verticalHunting,\n"
                  "  repeat: true,\n"
                  "  animationDuration: Duration(milliseconds: 900),\n"
                  "  child: Icon(Icons.keyboard_arrow_down_rounded),\n"
                  ")",
              child: Universal(
                height: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.tertiaryContainer,
                  borderRadius: 14.borderRadiusAll,
                ),
                child: FlAnimation(
                  style: FlAnimationStyle.verticalHunting,
                  repeat: true,
                  animationDuration: const Duration(milliseconds: 900),
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: colors.onTertiaryContainer, size: 34),
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '配置说明',
          children: [
            DemoItem(
              title: '完整参数',
              code:
                  "FlAnimation(\n"
                  "  style: FlAnimationStyle.fade,\n"
                  "  animationDuration: Duration(milliseconds: 600),\n"
                  "  delayDuration: Duration(milliseconds: 300),\n"
                  "  stayDuration: Duration(seconds: 1),\n"
                  "  reverse: true,\n"
                  "  number: 2,\n"
                  "  repeat: false,\n"
                  "  onAnimate: (Function replay) => replay(),\n"
                  "  child: const FlText('content'),\n"
                  ")",
              child: const DemoValues([
                DemoValue('animationDuration', '单次正向 / 反向时长'),
                DemoValue('delayDuration', '首次播放前延迟'),
                DemoValue('stayDuration', '正向结束、反向开始前的停留'),
                DemoValue('number', 'repeat=false 时的播放次数'),
                DemoValue('reverse', '正向结束后是否反向'),
                DemoValue('onAnimate', '拿到可手动触发「正向+反向」的回调'),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  DemoItem _animationItem(
    BuildContext context, {
    required FlAnimationStyle style,
    required String title,
    required String description,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoItem(
      title: title,
      description: description,
      code:
          "FlAnimation(\n"
          "  style: FlAnimationStyle.${style.name},\n"
          "  animationDuration: Duration(milliseconds: 700),\n"
          "  delayDuration: Duration(milliseconds: 300),\n"
          "  stayDuration: Duration(seconds: 1),\n"
          "  onAnimate: (Function replay) => replay(),\n"
          "  child: ...,\n"
          ")",
      note: '点击预览区域重播',
      child: Universal(
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: 14.borderRadiusAll,
        ),
        onTap: () => _runners[style]?.call(),
        child: FlAnimation(
          style: style,
          animationDuration: const Duration(milliseconds: 700),
          delayDuration: const Duration(milliseconds: 300),
          stayDuration: const Duration(seconds: 1),
          onAnimate: (Function running) => _runners[style] = running,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(color: colors.primary, borderRadius: 10.borderRadiusAll),
            child: const FlText('FlAnimation', color: Colors.white),
          ),
        ),
      ),
    );
  }
}
