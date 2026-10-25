import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// 图标 + 文案组合组件，可包装为 [FlButton]
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
    this.buttonCategory,

    /// 文案
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.labelText,
    this.labelStyle,
    this.label,

    /// 图标
    this.imageProvider,
    this.image,
    this.size,
    this.icon,
    this.widget,
  });

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 文本方向
  final TextDirection? textDirection;

  /// 整个组件高度
  final double? height;

  /// 整个组件宽度
  final double? width;

  /// 背景色
  final Color? background;

  /// 整个组件装饰器
  final BoxDecoration? decoration;

  /// 作为按钮时的样式类型
  final FlButtonCategory? buttonCategory;

  /// [icon]、[imageProvider]、[labelText] 的颜色
  final Color? color;

  /// 整个组件点击事件
  final GestureTapCallback? onTap;

  /// 整个组件对齐方式
  final AlignmentGeometry? alignment;

  /// 布局方向（水平 / 垂直）
  final Axis direction;

  /// 主轴对齐
  final MainAxisAlignment mainAxisAlignment;

  /// 交叉轴对齐
  final CrossAxisAlignment crossAxisAlignment;

  /// 是否反转图标与文案顺序，默认 false
  final bool reverse;

  /// [icon] 与 [label] 间距
  final double spacing;

  /// 包裹 [Hero] 的 tag
  final Object? heroTag;

  /// 自定义组件（优先级：icon > image > imageProvider > widget）
  final Widget? widget;

  /// 图标数据
  final IconData? icon;

  /// 图片组件
  final Image? image;

  /// 图片提供者
  final ImageProvider? imageProvider;

  /// [icon]、[imageProvider] 大小
  final double? size;

  /// 文案字符串
  final String? labelText;

  /// 文案对齐
  final TextAlign textAlign;

  /// 文案溢出处理
  final TextOverflow overflow;

  /// [labelText] 最大行数
  final int maxLines;

  /// 文案样式
  final TextStyle? labelStyle;

  /// 自定义文案组件
  final Widget? label;

  /// [FlButton] 点击回调
  final VoidCallback? onPressed;

  /// [FlButton] 长按回调
  final GestureLongPressCallback? onLongPress;

  /// [FlButton] 悬停回调
  final ValueChanged<bool>? onHover;

  /// [FlButton] 焦点变化回调
  final ValueChanged<bool>? onFocusChange;

  /// [FlButton] 样式
  final ButtonStyle? style;

  /// [FlButton] 焦点节点
  final FocusNode? focusNode;

  /// [FlButton] 是否自动获取焦点
  final bool autofocus;

  /// [FlButton] 状态控制器
  final WidgetStatesController? statesController;

  /// 裁剪行为
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
      buttonCategory: buttonCategory,
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

  Widget? get buildIcon => [
    if (icon != null) Icon(icon, color: color, size: size, textDirection: textDirection),
    ?image,
    if (imageProvider != null)
      Image(
        image: imageProvider!,
        width: size,
        height: size,
        color: color,
        fit: BoxFit.scaleDown,
        excludeFromSemantics: true,
      ),
    ?widget,
  ].firstOrNull;
}
