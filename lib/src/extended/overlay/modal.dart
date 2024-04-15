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
    this.constraints,
    this.safeLTRB = true,
  });

  /// [Material] 属性
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final MaterialType? type;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final bool? borderOnForeground;

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

  /// 高斯模糊
  final double gaussian;

  /// modal上的组件对齐方式 [alignment]
  final AlignmentGeometry? alignment;

  /// [SafeArea]
  final bool safeLTRB;

  /// constraints
  final BoxConstraints? constraints;
}

class ModalBoxOptions extends ModalOptions {
  const ModalBoxOptions({
    super.alignment = Alignment.center,
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
    super.foregroundColor,
    super.constraints,
  });

  ModalBoxOptions copyWith({
    GestureTapCallback? onModalTap,
    Color? backgroundColor,
    Color? foregroundColor,
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
    BoxConstraints? constraints,
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
        foregroundColor: foregroundColor ?? this.foregroundColor,
        constraints: constraints ?? this.constraints,
      );

  ModalBoxOptions merge([ModalBoxOptions? options]) => copyWith(
        alignment: options?.alignment,
        onModalTap: options?.onModalTap,
        backgroundColor: options?.backgroundColor,
        foregroundColor: options?.foregroundColor,
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
        constraints: options?.constraints,
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
        type: options.type ?? MaterialType.canvas,
        elevation: options.elevation ?? 0.0,
        shadowColor: options.shadowColor,
        textStyle: options.textStyle,
        borderRadius: options.borderRadius,
        shape: options.shape,
        borderOnForeground: options.borderOnForeground ?? true,
        child: child);

    if (materialBuilder != null) {
      current = materialBuilder!(current);
    }
    current = MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Universal(
            onTap: options.onModalTap,
            color: options.backgroundColor,
            alignment: options.alignment,
            child: Universal(
                safeLTRB: options.safeLTRB,
                constraints: options.constraints,
                child: current)));
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

extension ExtensionActionDialog on ActionDialog {
  Future<T?> show<T>({DialogOptions? options}) => popupDialog<T>(
      options: const DialogOptions(fromStyle: PopupFromStyle.fromCenter)
          .merge(options));
}

class ActionDialog extends StatelessWidget {
  const ActionDialog({
    super.key,
    this.title,
    required this.content,
    this.padding,
    this.actions = const [],
    this.options,
    this.constraints,
    this.actionsMaxHeight = 45,
    this.dividerColor,
    this.dividerMargin,
    this.dividerThickness = 1,
  });

  /// content
  final Widget content;

  /// title
  final Widget? title;

  /// content padding
  final EdgeInsetsGeometry? padding;

  /// BoxConstraints
  final BoxConstraints? constraints;

  /// actions
  final List<Widget> actions;

  /// 底层模态框配置
  /// 可设置宽高
  final ModalBoxOptions? options;

  /// divider color
  final Color? dividerColor;

  /// divider padding
  final EdgeInsets? dividerMargin;

  /// divider height
  final double dividerThickness;

  /// actions max height
  final double actionsMaxHeight;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      if (title != null) ...[title!],
      content
    ];
    if (dividerColor != null && dividerThickness > 0) {
      widgets.add(buildDivider());
    }
    if (actions.isNotEmpty) widgets.add(buildActions);
    BoxConstraints? constraints =
        this.constraints ?? BoxConstraints(maxWidth: context.width - 40);
    return ModalBox(
        options: ModalBoxOptions(
                constraints: constraints,
                foregroundColor: context.theme.dialogBackgroundColor)
            .merge(options),
        child: Universal(
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: padding,
            mainAxisSize: MainAxisSize.min,
            children: widgets));
  }

  Widget buildDivider([bool isVertical = false]) {
    EdgeInsets? margin;
    if (dividerMargin != null) {
      if (isVertical) {
        margin = EdgeInsets.only(
            top: dividerMargin!.top, bottom: dividerMargin!.bottom);
      } else {
        margin = EdgeInsets.only(
            left: dividerMargin!.left, right: dividerMargin!.right);
      }
    }
    return Container(
        margin: margin,
        width: isVertical ? dividerThickness : double.infinity,
        height: isVertical ? double.infinity : dividerThickness,
        color: dividerColor);
  }

  Widget get buildActions {
    List<Widget> children = actions;
    if (dividerColor != null && dividerThickness > 0) {
      children = children.insertElementBetween(buildDivider(true));
    }
    return Universal(
        constraints: BoxConstraints(maxHeight: actionsMaxHeight),
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children);
  }
}
