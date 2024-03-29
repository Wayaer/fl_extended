import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

abstract class ModalOptions {
  const ModalOptions({
    this.gaussian = 0,
    this.ignoring,
    this.absorbing,
    this.backgroundColor,
    this.foregroundColor,
    this.onModalTap,
    this.alignment,
    this.type,
    this.elevation,
    this.shadowColor,
    this.textStyle,
    this.borderRadius,
    this.shape,
    this.borderOnForeground,
    this.animationDuration,
  });

  /// [Material] 属性
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final MaterialType? type;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final bool? borderOnForeground;
  final Duration? animationDuration;

  /// [Modal]背景点击事件
  final GestureTapCallback? onModalTap;

  /// 背景色
  final Color? backgroundColor;

  /// 前景色
  final Color? foregroundColor;

  /// 是否忽略子组件点击事件响应背景点击事件 默认 false
  final bool? ignoring;

  /// 是否吸收子组件的点击事件且不响应背景点击事件 默认 false
  /// [onTap] != null 时  无效
  final bool? absorbing;

  final double gaussian;

  /// modal上的组件对齐方式 [alignment]
  final AlignmentGeometry? alignment;
}

class ModalBoxOptions extends ModalOptions {
  const ModalBoxOptions({
    super.alignment,
    super.gaussian,
    super.ignoring,
    super.absorbing,
    super.backgroundColor,
    super.onModalTap,
    super.type,
    super.elevation,
    super.shadowColor,
    super.textStyle,
    super.borderRadius,
    super.shape,
    super.borderOnForeground,
    super.animationDuration,
  });

  ModalBoxOptions copyWith({
    GestureTapCallback? onModalTap,
    Color? backgroundColor,
    bool? ignoring,
    bool? absorbing,
    double? gaussian,
    AlignmentGeometry? alignment,
    TextStyle? textStyle,
    BorderRadiusGeometry? borderRadius,
    MaterialType? type,
    double? elevation,
    Color? shadowColor,
    ShapeBorder? shape,
    bool? borderOnForeground,
    Duration? animationDuration,
  }) =>
      ModalBoxOptions(
        alignment: alignment ?? this.alignment,
        onModalTap: onModalTap ?? this.onModalTap,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        ignoring: ignoring ?? this.ignoring,
        absorbing: absorbing ?? this.absorbing,
        gaussian: gaussian ?? this.gaussian,
        type: type ?? this.type,
        elevation: elevation ?? this.elevation,
        shadowColor: shadowColor ?? this.shadowColor,
        textStyle: textStyle ?? this.textStyle,
        borderRadius: borderRadius ?? this.borderRadius,
        shape: shape ?? this.shape,
        borderOnForeground: borderOnForeground ?? this.borderOnForeground,
        animationDuration: animationDuration ?? this.animationDuration,
      );

  ModalBoxOptions merge([ModalOptions? options]) => copyWith(
        alignment: options?.alignment,
        onModalTap: options?.onModalTap,
        backgroundColor: options?.backgroundColor,
        ignoring: options?.ignoring,
        absorbing: options?.absorbing,
        gaussian: options?.gaussian,
        type: options?.type,
        elevation: options?.elevation,
        shadowColor: options?.shadowColor,
        textStyle: options?.textStyle,
        borderRadius: options?.borderRadius,
        shape: options?.shape,
        borderOnForeground: options?.borderOnForeground,
        animationDuration: options?.animationDuration,
      );
}

/// 模态框背景
class ModalBox extends StatelessWidget {
  const ModalBox({super.key, this.child, this.options, this.materialBuilder});

  /// 顶层组件
  final Widget? child;

  /// 弹框最底层配置
  final ModalOptions? options;

  /// builder material
  final ValueCallbackTV<Widget, Widget>? materialBuilder;

  @override
  Widget build(BuildContext context) {
    final options = this.options ?? FlExtended().modalOptions;

    Widget current = Material(
        color: options.foregroundColor ?? Colors.transparent,
        type: options.type ?? MaterialType.card,
        elevation: options.elevation ?? 0.0,
        shadowColor: options.shadowColor,
        textStyle: options.textStyle,
        borderRadius: options.borderRadius,
        shape: options.shape,
        borderOnForeground: options.borderOnForeground ?? true,
        animationDuration: options.animationDuration ?? kThemeChangeDuration,
        child: child);
    current = Universal(
        onTap: options.onModalTap,
        color: options.backgroundColor,
        alignment: options.alignment ?? Alignment.center,
        child: materialBuilder?.call(current) ?? current);
    if (options.gaussian > 0) current = backdropFilter(options, current);
    if (options.ignoring != null) {
      current = IgnorePointer(ignoring: options.ignoring!, child: current);
    } else if (options.onModalTap == null && options.absorbing != null) {
      current = AbsorbPointer(absorbing: options.absorbing!, child: current);
    }
    return current;
  }

  Widget backdropFilter(ModalOptions options, Widget child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: options.gaussian, sigmaY: options.gaussian),
      child: child);
}

extension ExtensionDoubleChooseWindows on DoubleChooseWindows {
  Future<T?> show<T>({DialogOptions? options}) => popupDialog<T>(
      options: const DialogOptions(fromStyle: PopupFromStyle.fromCenter)
          .merge(options));
}

class DoubleChooseWindows extends StatelessWidget {
  const DoubleChooseWindows({
    super.key,
    this.backgroundColor,
    required this.content,
    this.padding,
    this.margin = const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
    this.left,
    this.right,
    this.decoration,
    this.options,
    this.constraints,
  });

  /// 弹框内容
  final Widget content;

  /// 弹框背景色
  final Color? backgroundColor;

  /// 弹框 padding
  final EdgeInsetsGeometry? padding;

  /// 弹框 margin
  final EdgeInsetsGeometry? margin;

  /// BoxConstraints
  final BoxConstraints? constraints;

  /// 左边按钮
  final Widget? left;

  /// 右边按钮
  final Widget? right;

  /// 弹框样式
  final Decoration? decoration;

  /// 底层模态框配置
  /// 可设置宽高
  final ModalBoxOptions? options;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [content];
    if (left != null && right != null) widgets.add(leftAndRight);
    BoxConstraints? constraints;
    if (this.constraints == null && context.mediaQuery.size.width > 400) {
      constraints = const BoxConstraints(maxWidth: 350);
    }
    return ModalBox(
        options: options,
        child: Universal(
            constraints: constraints ?? this.constraints,
            color: backgroundColor ?? context.theme.dialogBackgroundColor,
            decoration: decoration,
            margin: margin,
            padding: padding,
            mainAxisSize: MainAxisSize.min,
            children: widgets));
  }

  Widget get leftAndRight =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(child: left!),
        Expanded(child: right!),
      ]);
}
