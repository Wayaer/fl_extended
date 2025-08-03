import 'dart:ui' show clampDouble, lerpDouble;
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

  const UnifiedButton.icon({
    super.key,
    this.category = UnifiedButtonCategory.none,
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
  final WidgetStatesController? statesController;

  /// child
  final Widget child;

  /// icon
  final Widget? icon;

  /// iconAlignment
  final IconAlignment? iconAlignment;

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
      final themeStyle = switch (category) {
        UnifiedButtonCategory.none => TextButtonTheme.of(context).style,
        UnifiedButtonCategory.filled => FilledButtonTheme.of(context).style,
        UnifiedButtonCategory.filledTonal => FilledButtonTheme.of(context).style,
        UnifiedButtonCategory.elevated => ElevatedButtonTheme.of(context).style,
        UnifiedButtonCategory.outlined => OutlinedButtonTheme.of(context).style,
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
        children:
            effectiveIconAlignment == IconAlignment.start
                ? [icon!, SizedBox(width: gap), Flexible(child: current)]
                : [Flexible(child: current), SizedBox(width: gap), icon!],
      );
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
          child: current,
        );
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
          child: current,
        );
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
          child: current,
        );
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
          child: current,
        );
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
          child: current,
        );
    }
  }
}
