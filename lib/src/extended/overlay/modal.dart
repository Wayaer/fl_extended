import 'dart:ui';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 模态框基础配置
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
    this.resizeToAvoidBottomInset = true,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  });

  /// [Material] 文本样式
  final TextStyle? textStyle;

  /// [Material] 圆角
  final BorderRadiusGeometry? borderRadius;

  /// [Material] 类型
  final MaterialType? type;

  /// [Material] 海拔
  final double? elevation;

  /// [Material] 阴影色
  final Color? shadowColor;

  /// [Material] 形状
  final ShapeBorder? shape;

  /// [Material] 是否在前景绘制边框
  final bool? borderOnForeground;

  /// 模态背景点击事件
  final GestureTapCallback? onModalTap;

  /// 背景色
  final Color? backgroundColor;

  /// 前景色
  final Color? foregroundColor;

  /// 是否忽略子组件点击，使背景可响应点击，默认 false
  final bool? ignoring;

  /// 是否吸收子组件点击且不响应背景点击，默认 false
  /// 当 [onModalTap] != null 时无效
  final bool? absorbing;

  /// 高斯模糊强度
  final double gaussian;

  /// 模态上内容的对齐方式
  final AlignmentGeometry? alignment;

  /// 尺寸约束
  final BoxConstraints? constraints;

  /// 是否使用 [SafeArea]
  final bool safeLTRB;

  /// 键盘弹出时是否顶起内容
  final bool resizeToAvoidBottomInset;

  /// 键盘弹出时顶起动画时长
  final Duration insetAnimationDuration;

  /// 键盘弹出时顶起动画曲线
  final Curve insetAnimationCurve;
}

/// 模态盒配置
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
    super.safeLTRB,
    super.resizeToAvoidBottomInset,
    super.insetAnimationCurve,
    super.insetAnimationDuration,
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
    bool? safeLTRB,
    bool? resizeToAvoidBottomInset,
    Duration? insetAnimationDuration,
    Curve? insetAnimationCurve,
  }) => ModalBoxOptions(
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
    safeLTRB: safeLTRB ?? this.safeLTRB,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    insetAnimationDuration: insetAnimationDuration ?? this.insetAnimationDuration,
    insetAnimationCurve: insetAnimationCurve ?? this.insetAnimationCurve,
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
    safeLTRB: options?.safeLTRB,
    resizeToAvoidBottomInset: options?.resizeToAvoidBottomInset,
    insetAnimationDuration: options?.insetAnimationDuration,
    insetAnimationCurve: options?.insetAnimationCurve,
  );
}

/// 模态框背景
class ModalBox extends StatelessWidget {
  const ModalBox({super.key, this.child, this.options, this.materialBuilder});

  /// 顶层组件
  final Widget? child;

  /// 弹框底层配置
  final ModalOptions? options;

  /// 自定义 [Material] 包装
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
      child: child,
    );
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
        child: Universal(safeLTRB: options.safeLTRB, constraints: options.constraints, child: current),
      ),
    );
    if (options.resizeToAvoidBottomInset) {
      current = AnimatedPadding(
        padding: MediaQuery.viewInsetsOf(context),
        duration: options.insetAnimationDuration,
        curve: options.insetAnimationCurve,
        child: current,
      );
    }
    if (options.gaussian > 0) current = backdropFilter(options, current);
    if (options.ignoring != null) {
      current = IgnorePointer(ignoring: options.ignoring!, child: current);
    } else if (options.onModalTap == null && options.absorbing != null) {
      current = AbsorbPointer(absorbing: options.absorbing!, child: current);
    }
    return current;
  }

  Widget backdropFilter(ModalOptions options, Widget child) => ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: options.gaussian, sigmaY: options.gaussian),
      child: child,
    ),
  );
}

extension ExtensionActionDialog on ActionDialog {
  Future<T?> show<T>({GeneralDialogOptions? options}) =>
      popupGeneralDialog<T>(options: const GeneralDialogOptions().merge(options));
}

const Color _kDialogColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFF2F2F2),
  darkColor: Color(0xFF2D2D2D),
);

/// 带标题、内容与操作按钮的对话框
class ActionDialog extends StatelessWidget {
  const ActionDialog({
    super.key,
    this.title,
    required this.content,
    this.padding,
    this.actions = const [],
    this.options,
    this.constraints,
    this.actionsMaxHeight,
    this.dividerColor,
    this.dividerMargin,
    this.dividerThickness = 1,
  });

  /// 内容
  final Widget content;

  /// 标题
  final Widget? title;

  /// 内容内边距
  final EdgeInsetsGeometry? padding;

  /// 尺寸约束
  final BoxConstraints? constraints;

  /// 底部操作按钮
  final List<Widget> actions;

  /// 底层模态框配置（可设置宽高）
  final ModalBoxOptions? options;

  /// 分隔线颜色
  final Color? dividerColor;

  /// 分隔线边距
  final EdgeInsets? dividerMargin;

  /// 分隔线厚度
  final double dividerThickness;

  /// 操作区最大高度；为 null 时不限制
  final double? actionsMaxHeight;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      if (title != null) ...[title!],
      content,
    ];
    if (dividerColor != null && dividerThickness > 0) {
      widgets.add(buildDivider());
    }
    if (actions.isNotEmpty) widgets.add(buildActions);
    final BoxConstraints constraints = this.constraints ?? BoxConstraints(maxWidth: context.width - 40);
    return ModalBox(
      options: ModalBoxOptions(
        constraints: constraints,
        foregroundColor: CupertinoDynamicColor.resolve(_kDialogColor, context),
      ).merge(options),
      child: Universal(padding: padding, mainAxisSize: MainAxisSize.min, children: widgets),
    );
  }

  Widget buildDivider([bool isVertical = false]) {
    EdgeInsets? margin;
    if (dividerMargin != null) {
      if (isVertical) {
        margin = EdgeInsets.only(top: dividerMargin!.top, bottom: dividerMargin!.bottom);
      } else {
        margin = EdgeInsets.only(left: dividerMargin!.left, right: dividerMargin!.right);
      }
    }
    return Container(
      margin: margin,
      width: isVertical ? dividerThickness : double.infinity,
      height: isVertical ? null : dividerThickness,
      color: dividerColor,
    );
  }

  Widget get buildActions {
    List<Widget> children = actions;
    if (dividerColor != null && dividerThickness > 0) {
      children = children.insertElementBetween(buildDivider(true));
    }
    return IntrinsicHeight(
      child: Universal(
        constraints: actionsMaxHeight == null ? null : BoxConstraints(maxHeight: actionsMaxHeight!),
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
