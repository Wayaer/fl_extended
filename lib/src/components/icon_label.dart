import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
    this.reverse = false,
    this.direction = Axis.horizontal,
    this.spacing = 4,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.heroTag,
    this.background,
    this.color,
    this.onPressed,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.onLongPress,
    this.clipBehavior,
    this.unifiedButtonCategory,

    /// label
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.labelText,
    this.labelStyle,
    this.label,

    /// icon
    this.imageProvider,
    this.image,
    this.size,
    this.icon,
    this.widget,
  });

  /// ****** [IconLabel] ****** ///
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextDirection? textDirection;

  /// 整个组件宽高
  final double? height;
  final double? width;

  /// 背景
  final Color? background;

  /// 整个组件装饰器
  final Decoration? decoration;

  /// 整个按钮样式
  final UnifiedButtonCategory? unifiedButtonCategory;

  /// [icon]、[imageProvider]、[labelText] 颜色
  final Color? color;

  /// 整个组件点击事件
  final GestureTapCallback? onTap;

  /// 整个组件居中
  final AlignmentGeometry? alignment;

  /// 组件水平或 垂直
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  /// reverse [false]
  final bool reverse;

  /// [icon] 与 [label] 间距
  final double spacing;

  /// add [Hero]
  final Object? heroTag;

  /// ****** [Icon] ****** ///
  /// icon > image > imageProvider > widget
  final Widget? widget;
  final IconData? icon;
  final Image? image;
  final ImageProvider? imageProvider;

  /// [icon]、[imageProvider] 大小
  final double? size;

  /// ****** [Label] ****** ///
  /// label
  final String? labelText;

  /// text
  final TextAlign textAlign;

  final TextOverflow overflow;

  /// [labelText]显示时最大行数
  final int maxLines;

  final TextStyle? labelStyle;

  /// 自定义 [Label]
  final Widget? label;

  /// ****** [UnifiedButton] ****** ///
  final VoidCallback? onPressed;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final WidgetStatesController? statesController;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final labelWidget = buildLabel;
    final iconWidget = buildIcon;
    if (labelWidget != null) children.add(labelWidget);
    if (iconWidget != null) {
      if (reverse) {
        children.add(iconWidget);
      } else {
        children.insert(0, iconWidget);
      }
    }
    return Universal(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      color: background,
      decoration: decoration,
      alignment: alignment,
      heroTag: heroTag,
      unifiedButtonCategory: unifiedButtonCategory,
      onTap: onTap ?? onPressed,
      onPressed: onTap ?? onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      clipBehavior: clipBehavior ?? Clip.none,
      focusNode: focusNode,
      autofocus: autofocus,
      statesController: statesController,
      spacing: children.length > 1 ? spacing : 0,
      child: children.length > 1 ? null : children.firstOrNull,
      children: children.length > 1 ? children : null,
    );
  }

  Widget? get buildLabel =>
      label ??
      (labelText != null
          ? Text(
            labelText!,
            style: TextStyle(color: color).merge(labelStyle),
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: textDirection,
            overflow: overflow,
          )
          : null);

  Widget? get buildIcon =>
      [
        if (icon != null) Icon(icon, color: color, size: size, textDirection: textDirection),
        if (image != null) image!,
        if (imageProvider != null)
          Image(
            image: imageProvider!,
            width: size,
            height: size,
            color: color,
            fit: BoxFit.scaleDown,
            excludeFromSemantics: true,
          ),
        if (widget != null) widget!,
      ].firstOrNull;
}
