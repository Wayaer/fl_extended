import 'dart:ui' show clampDouble, lerpDouble;

import 'package:flutter/material.dart';

enum FlButtonCategory {
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

  final FlButtonCategory category;

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
        FlButtonCategory.none => TextButtonTheme.of(context).style,
        FlButtonCategory.filled => FilledButtonTheme.of(context).style,
        FlButtonCategory.filledTonal => FilledButtonTheme.of(context).style,
        FlButtonCategory.elevated => ElevatedButtonTheme.of(context).style,
        FlButtonCategory.outlined => OutlinedButtonTheme.of(context).style,
      };
      final double defaultFontSize = (style ?? themeStyle)?.textStyle?.resolve(const <WidgetState>{})?.fontSize ?? 14.0;
      final double scale = clampDouble(MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0, 1.0, 2.0) - 1.0;
      final double gap = lerpDouble(8, 4, scale)!;
      final IconAlignment effectiveIconAlignment = iconAlignment  ?? IconAlignment.start;
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
