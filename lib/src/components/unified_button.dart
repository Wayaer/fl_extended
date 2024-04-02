import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

enum UnifiedButtonCategory {
  /// use [TextButton]
  none,

  /// use [FilledButton]
  filled,

  /// use [FilledButton.tonal]
  filledTonal,

  /// use [ElevatedButton]
  elevated,

  /// use [OutlinedButton]
  outlined,
}

class UnifiedButton extends StatelessWidget {
  const UnifiedButton({
    super.key,
    this.category = UnifiedButtonCategory.none,
    this.icon,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    required this.child,
    this.padding,
  })  : direction = Axis.horizontal,
        mainAxisAlignment = MainAxisAlignment.center,
        mainAxisSize = MainAxisSize.min,
        crossAxisAlignment = CrossAxisAlignment.center,
        textDirection = null,
        verticalDirection = VerticalDirection.down,
        textBaseline = null;

  const UnifiedButton.icon(
      {super.key,
      this.category = UnifiedButtonCategory.none,
      this.icon,
      required this.onPressed,
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
      required this.child,
      this.padding});

  final UnifiedButtonCategory category;

  /// onPressed
  final VoidCallback? onPressed;

  /// onLongPress
  final VoidCallback? onLongPress;

  /// onHover
  final ValueChanged<bool>? onHover;

  /// onFocusChange
  final ValueChanged<bool>? onFocusChange;

  /// style
  final ButtonStyle? style;

  /// clipBehavior
  final Clip clipBehavior;

  /// focusNode
  final FocusNode? focusNode;

  /// autofocus
  final bool autofocus;

  /// statesController
  final MaterialStatesController? statesController;

  /// child
  final Widget child;

  /// icon
  final Widget? icon;

  /// [Flex]
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final MainAxisSize mainAxisSize;

  /// [Padding]
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    if (icon != null) {
      final double scale = MediaQuery.textScalerOf(context).textScaleFactor;
      final double gap =
          scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
      current = Flex(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          direction: direction,
          textBaseline: textBaseline,
          verticalDirection: verticalDirection,
          textDirection: textDirection,
          mainAxisSize: mainAxisSize,
          clipBehavior: clipBehavior,
          children: [icon!, SizedBox(width: gap), Flexible(child: current)]);
    }
    if (padding != null) {
      current = Padding(padding: padding!, child: current);
    }
    switch (category) {
      case UnifiedButtonCategory.none:
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
            child: current);
      case UnifiedButtonCategory.filled:
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
            child: current);
      case UnifiedButtonCategory.filledTonal:
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
            child: current);
      case UnifiedButtonCategory.elevated:
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
            child: current);
      case UnifiedButtonCategory.outlined:
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
            child: current);
    }
  }
}
