import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

class ModelRect {
  const ModelRect(
      {this.left, this.top, this.right, this.bottom, this.width, this.height});

  /// left
  final double? left;

  /// top
  final double? top;

  /// right
  final double? right;

  /// bottom
  final double? bottom;

  /// width
  final double? width;

  /// height
  final double? height;

  ModelRect.fromRect(Rect rect)
      : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  const ModelRect.fill({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  })  : width = null,
        height = null;

  ModelRect copyWith(
          {double? left,
          double? top,
          double? right,
          double? bottom,
          double? width,
          double? height}) =>
      ModelRect(
          left: left ?? this.left,
          top: top ?? this.top,
          right: right ?? this.right,
          bottom: bottom ?? this.bottom,
          width: width ?? this.width,
          height: height ?? this.height);

  ModelRect marge([ModelRect? rect]) => ModelRect(
      left: rect?.left ?? left,
      top: rect?.top ?? top,
      right: rect?.right ?? right,
      bottom: rect?.bottom ?? bottom,
      width: rect?.width ?? width,
      height: rect?.height ?? height);

  @override
  String toString() =>
      'ModelRect(${left?.toStringAsFixed(1)}, ${top?.toStringAsFixed(1)}, ${right?.toStringAsFixed(1)}, ${bottom?.toStringAsFixed(1)})';
}

abstract class BaseModalOptions {
  const BaseModalOptions({
    this.gaussian = false,
    this.addMaterial = false,
    this.ignoring = false,
    this.absorbing = false,
    this.fuzzyDegree = 4,
    this.color,
    this.onModalTap,
    this.blendMode = BlendMode.srcOver,
    this.filter,
    this.rect,
    this.alignment,
    this.onPopInvoked,
    this.canPop = true,
  });

  /// [Modal]背景点击事件
  final GestureTapCallback? onModalTap;

  /// 背景色
  final Color? color;

  /// 是否忽略子组件点击事件响应背景点击事件 默认 false
  final bool ignoring;

  /// 是否吸收子组件的点击事件且不响应背景点击事件 默认 false
  /// [onTap] != null 时  无效
  final bool absorbing;

  /// 是否添加Material Widget 部分组件需要基于Material
  final bool addMaterial;

  /// [filter]!=null 时 [fuzzyDegree] 无效
  /// [gaussian] 必须为 true
  final ImageFilter? filter;

  /// 是否开始背景模糊
  final bool gaussian;

  /// 模糊程度 0-100
  /// [gaussian] 必须为 true
  final double fuzzyDegree;
  final BlendMode blendMode;

  /// modal上的组件区域 [rect] > [alignment]
  final ModelRect? rect;

  /// modal上的组件对齐方式 [rect] > [alignment]
  final AlignmentGeometry? alignment;

  /// 返回处理
  final PopInvokedCallback? onPopInvoked;
  final bool canPop;
}

class ModalWindowsOptions extends BaseModalOptions {
  const ModalWindowsOptions(
      {super.rect,
      super.alignment,
      super.gaussian = false,
      super.addMaterial = false,
      super.ignoring = false,
      super.absorbing = false,
      super.fuzzyDegree = 4,
      super.color,
      super.onModalTap,
      super.blendMode = BlendMode.srcOver,
      super.filter,
      super.canPop,
      super.onPopInvoked});

  ModalWindowsOptions copyWith({
    GestureTapCallback? onModalTap,
    Color? color,
    bool? ignoring,
    bool? absorbing,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    ModelRect? rect,
    AlignmentGeometry? alignment,
    PopInvokedCallback? onPopInvoked,
    bool? canPop,
  }) =>
      ModalWindowsOptions(
          onPopInvoked: onPopInvoked ?? this.onPopInvoked,
          canPop: canPop ?? this.canPop,
          rect: rect ?? this.rect,
          alignment: alignment ?? this.alignment,
          onModalTap: onModalTap ?? this.onModalTap,
          color: color ?? this.color,
          ignoring: ignoring ?? this.ignoring,
          absorbing: absorbing ?? this.absorbing,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree);

  ModalWindowsOptions merge([BaseModalOptions? options]) => copyWith(
      onPopInvoked: options?.onPopInvoked,
      canPop: options?.canPop,
      rect: options?.rect,
      alignment: options?.alignment,
      onModalTap: options?.onModalTap,
      color: options?.color,
      ignoring: options?.ignoring,
      absorbing: options?.absorbing,
      addMaterial: options?.addMaterial,
      filter: options?.filter,
      gaussian: options?.gaussian,
      fuzzyDegree: options?.fuzzyDegree);
}

/// 模态框背景
class ModalWindows extends StatelessWidget {
  ModalWindows({super.key, this.child, BaseModalOptions? options})
      : options = options ?? FlExtended().modalWindowsOptions;

  /// 顶层组件
  final Widget? child;

  /// 弹框最底层配置
  final BaseModalOptions options;

  @override
  Widget build(BuildContext context) {
    Widget child = buildBase;
    if (options.gaussian) child = backdropFilter(child);
    if (options.addMaterial) {
      child = Material(
          color: Colors.transparent,
          child: MediaQuery(data: context.mediaQuery, child: child));
    }
    if (options.ignoring) {
      child = IgnorePointer(child: child);
    } else if (options.onModalTap == null && options.absorbing) {
      child = AbsorbPointer(child: child);
    }
    if (options.onPopInvoked != null || !options.canPop) {
      PopScope(
          onPopInvoked: options.onPopInvoked,
          canPop: options.canPop,
          child: child);
    }
    return child;
  }

  Widget backdropFilter(Widget child) => BackdropFilter(
      blendMode: options.blendMode,
      filter: options.filter ??
          ImageFilter.blur(
              sigmaX: options.fuzzyDegree, sigmaY: options.fuzzyDegree),
      child: child);

  Widget get buildBase => Universal(
      color: options.color,
      onTap: options.onModalTap,
      child: isStack ? null : child,
      isStack: isStack,
      children: child != null
          ? [
              if (options.rect != null)
                Positioned(
                    left: options.rect!.left,
                    top: options.rect!.top,
                    right: options.rect!.right,
                    bottom: options.rect!.bottom,
                    child: child!)
              else if (options.alignment != null)
                Align(alignment: options.alignment!, child: child),
            ]
          : []);

  bool get isStack => options.rect != null || options.alignment != null;
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
    this.left,
    this.right,
    this.decoration,
    this.options,
  });

  /// 弹框内容
  final Widget content;

  /// 弹框背景色
  final Color? backgroundColor;

  /// 弹框 padding
  final EdgeInsetsGeometry? padding;

  /// 左边按钮
  final Widget? left;

  /// 右边按钮
  final Widget? right;

  /// 弹框样式
  final Decoration? decoration;

  /// 底层模态框配置
  /// 可设置宽高
  final ModalWindowsOptions? options;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [content];
    if (left != null && right != null) widgets.add(leftAndRight);
    var options = FlExtended().modalWindowsOptions.merge(this.options);
    BoxConstraints? constraints;
    if (context.mediaQuery.size.width > 400) {
      constraints = const BoxConstraints(maxWidth: 350);
    }
    return ModalWindows(
        options: options,
        child: Universal(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            constraints: constraints,
            decoration: decoration ??
                BoxDecoration(
                    color:
                        backgroundColor ?? context.theme.dialogBackgroundColor),
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
