import 'dart:ui' show clampDouble, lerpDouble;

import 'package:flutter/material.dart';

/// 按钮类型
enum FlButtonCategory {
  /// 使用 [TextButton]
  none,

  /// 使用 [FilledButton]
  filled,

  /// 使用 [FilledButton.tonal]
  filledTonal,

  /// 使用 [ElevatedButton]
  elevated,

  /// 使用 [OutlinedButton]
  outlined,
}

/// 统一封装 Material 各类按钮，可选图标与布局
class FlButton extends StatelessWidget {
  const FlButton({
    super.key,
    this.category = FlButtonCategory.none,
    this.icon,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.padding,
    this.iconAlignment,
  }) : direction = Axis.horizontal,
       mainAxisAlignment = MainAxisAlignment.center,
       mainAxisSize = MainAxisSize.min,
       crossAxisAlignment = CrossAxisAlignment.center,
       textDirection = null,
       verticalDirection = VerticalDirection.down,
       textBaseline = null;

  const FlButton.icon({
    super.key,
    this.category = FlButtonCategory.none,
    this.icon,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.padding,
    this.iconAlignment,
  });

  /// 按钮类型
  final FlButtonCategory category;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 长按回调
  final VoidCallback? onLongPress;

  /// 悬停回调
  final ValueChanged<bool>? onHover;

  /// 焦点变化回调
  final ValueChanged<bool>? onFocusChange;

  /// 按钮样式
  final ButtonStyle? style;

  /// 裁剪行为
  final Clip clipBehavior;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 状态控制器
  final WidgetStatesController? statesController;

  /// 子组件
  final Widget child;

  /// 图标
  final Widget? icon;

  /// 图标对齐方式
  final IconAlignment? iconAlignment;

  /// [Flex] 主轴对齐
  final MainAxisAlignment mainAxisAlignment;

  /// [Flex] 交叉轴对齐
  final CrossAxisAlignment crossAxisAlignment;

  /// [Flex] 方向
  final Axis direction;

  /// [Flex] 文本基线
  final TextBaseline? textBaseline;

  /// [Flex] 垂直方向
  final VerticalDirection verticalDirection;

  /// [Flex] 文本方向
  final TextDirection? textDirection;

  /// [Flex] 主轴尺寸
  final MainAxisSize mainAxisSize;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    if (icon != null) {
      final themeStyle = switch (category) {
        FlButtonCategory.none => TextButtonTheme.of(context).style,
        FlButtonCategory.filled => FilledButtonTheme.of(context).style,
        FlButtonCategory.filledTonal => FilledButtonTheme.of(context).style,
        FlButtonCategory.elevated => ElevatedButtonTheme.of(context).style,
        FlButtonCategory.outlined => OutlinedButtonTheme.of(context).style,
      };
      final double defaultFontSize = (style ?? themeStyle)?.textStyle?.resolve(const <WidgetState>{})?.fontSize ?? 14.0;
      final double scale = clampDouble(MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0, 1.0, 2.0) - 1.0;
      final double gap = lerpDouble(8, 4, scale)!;
      final IconAlignment effectiveIconAlignment = iconAlignment ?? themeStyle?.iconAlignment ?? IconAlignment.start;
      current = Flex(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        direction: direction,
        textBaseline: textBaseline,
        verticalDirection: verticalDirection,
        textDirection: textDirection,
        mainAxisSize: mainAxisSize,
        clipBehavior: clipBehavior,
        spacing: gap,
        children: effectiveIconAlignment == IconAlignment.start
            ? [icon!, Flexible(child: current)]
            : [Flexible(child: current), icon!],
      );
    }
    if (padding != null) {
      current = Padding(padding: padding!, child: current);
    }
    switch (category) {
      case FlButtonCategory.none:
        return TextButton(
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: onPressed,
          child: current,
        );
      case FlButtonCategory.filled:
        return FilledButton(
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: onPressed,
          child: current,
        );
      case FlButtonCategory.filledTonal:
        return FilledButton.tonal(
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: onPressed,
          child: current,
        );
      case FlButtonCategory.elevated:
        return ElevatedButton(
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: onPressed,
          child: current,
        );
      case FlButtonCategory.outlined:
        return OutlinedButton(
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          statesController: statesController,
          onPressed: onPressed,
          child: current,
        );
    }
  }
}
