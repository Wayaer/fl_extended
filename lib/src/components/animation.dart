import 'dart:async';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

const Duration kFlAnimationDuration = Duration(milliseconds: 300);

typedef FlAnimationCallback = void Function(Function running);

abstract class _FlAnimation extends StatefulWidget {
  const _FlAnimation({
    super.key,
    required this.child,
    this.onAnimate,
    this.delayDuration,
    this.animationDuration = kFlAnimationDuration,
    this.stayDuration,
    this.reverse = true,
    this.number = 1,
    this.repeat = false,
  });

  /// 子组件
  final Widget child;

  /// 动画时长
  final Duration animationDuration;

  /// 正向播放结束后是否反向播放
  final bool reverse;

  /// 正向结束后、反向开始前的停留时长
  final Duration? stayDuration;

  /// 开始播放前的延迟
  final Duration? delayDuration;

  /// 播放次数（[repeat] 为 false 时生效）
  final int number;

  /// 是否循环播放
  final bool repeat;

  /// 动画就绪回调，参数为可手动触发「正向+反向」的函数
  final FlAnimationCallback? onAnimate;
}

/// 动画样式
enum FlAnimationStyle {
  /// 淡入淡出
  fade,

  /// 水平晃动
  horizontalHunting,

  /// 垂直晃动
  verticalHunting,
}

/// 简单动画组件（淡入 / 晃动）
class FlAnimation extends _FlAnimation {
  const FlAnimation({
    super.key,
    required super.child,
    required this.style,
    super.animationDuration,
    super.delayDuration,
    super.reverse,
    super.stayDuration,
    super.number,
    super.repeat,
    super.onAnimate,
  });

  /// 动画样式
  final FlAnimationStyle style;

  @override
  State<FlAnimation> createState() => _FlAnimationState();
}

class _FlAnimationState extends ExtendedState<FlAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    initialize();
    if (widget.delayDuration != null) {
      _delayTimer = Timer(widget.delayDuration!, () => unawaited(run()));
    } else {
      run();
    }
    widget.onAnimate?.call(forwardAndReverse);
  }

  void initialize() {
    _controller = AnimationController(duration: widget.animationDuration, vsync: this);
    _animation = buildAnimation(widget.style);
  }

  Animation<double> buildAnimation(FlAnimationStyle style) => switch (style) {
    FlAnimationStyle.fade => Tween(begin: 0.0, end: 1.0).animate(_controller),
    FlAnimationStyle.horizontalHunting || FlAnimationStyle.verticalHunting => huntingAnimation(),
  };

  Animation<double> huntingAnimation() => TweenSequence([
    TweenSequenceItem<double>(
      tween: Tween(begin: 0.0, end: -10.0).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 0.5,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: -10.0, end: 10.0).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 10.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 0.5,
    ),
  ]).animate(_controller);

  Future<void> run() async {
    if (!mounted) return;
    if (widget.repeat) {
      _controller.repeat(reverse: widget.reverse);
      return;
    }
    for (int i = 0; i < widget.number; i++) {
      await forwardAndReverse();
    }
  }

  Future<void> forwardAndReverse() async {
    if (!mounted) return;
    await _controller.forward();
    if (widget.reverse) {
      if (!mounted) return;
      await widget.stayDuration?.delayed();
      if (!mounted) return;
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _animation, builder: (BuildContext context, Widget? child) => buildChild());
  }

  Widget buildChild() {
    switch (widget.style) {
      case FlAnimationStyle.fade:
        return Opacity(opacity: _animation.value, child: widget.child);
      case FlAnimationStyle.horizontalHunting:
        return Transform.translate(offset: Offset(_animation.value, 0.0), child: widget.child);
      case FlAnimationStyle.verticalHunting:
        return Transform.translate(offset: Offset(0.0, _animation.value), child: widget.child);
    }
  }

  @override
  void didUpdateWidget(covariant FlAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) _animation = buildAnimation(widget.style);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _delayTimer = null;
    _controller.dispose();
    super.dispose();
  }
}
