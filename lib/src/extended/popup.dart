import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:fl_extended/fl_extended.dart';

/// 关闭弹窗
/// 也可以通过 Navigator.of(context).maybePop()
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 弹窗进入方向属性
enum PopupFromStyle {
  /// 从左边进入
  fromLeft,

  /// 从右边进入
  fromRight,

  /// 从头部进入
  fromTop,

  /// 从底部进入
  fromBottom,

  /// 默认渐变显示
  fromCenter,
}

abstract class GeneralModalOptions {
  const GeneralModalOptions({
    this.useRootNavigator = true,
    this.barrierColor = kCupertinoModalBarrierColor,
    this.barrierDismissible = true,
    this.anchorPoint,
    this.routeSettings,
  });

  final bool useRootNavigator;
  final RouteSettings? routeSettings;

  /// 背景颜色
  final Color barrierColor;

  /// [barrierDismissible] = true  默认为 true 可关闭
  final bool barrierDismissible;

  final Offset? anchorPoint;
}

/// 关闭 [closePopup]
class DialogOptions extends GeneralModalOptions {
  const DialogOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.barrierLabel = '',
    this.useSafeArea = true,
    this.startOffset,
    this.transitionBuilder,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.fromStyle = PopupFromStyle.fromCenter,
  });

  const DialogOptions.cupertino({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.barrierLabel = '',
  }) : useSafeArea = true,
       startOffset = null,
       fromStyle = PopupFromStyle.fromCenter,
       transitionDuration = const Duration(milliseconds: 200),
       transitionBuilder = null;

  const DialogOptions.material({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.anchorPoint,
    this.barrierLabel = '',
    this.useSafeArea = true,
  }) : startOffset = null,
       fromStyle = PopupFromStyle.fromCenter,
       transitionDuration = const Duration(milliseconds: 200),
       transitionBuilder = null,
       super(barrierColor: kCupertinoModalBarrierColor);

  /// 语义化
  final String barrierLabel;

  final bool useSafeArea;

  /// 进入方向的距离
  final double? startOffset;

  /// popup 进入的方向
  final PopupFromStyle fromStyle;

  /// 这个是从开始到完全显示的时间
  final Duration transitionDuration;

  /// 路由显示和隐藏的过程 这里入参是 animation,secondaryAnimation 和 child, 其中 child 是 是 pageBuilder 构建的 widget
  final RouteTransitionsBuilder? transitionBuilder;

  DialogOptions copyWith({
    double? startOffset,
    PopupFromStyle? fromStyle,
    bool? barrierDismissible,
    String? barrierLabel,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionBuilder,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    bool? useSafeArea,
  }) => DialogOptions(
    useSafeArea: useSafeArea ?? this.useSafeArea,
    anchorPoint: anchorPoint ?? this.anchorPoint,
    startOffset: startOffset ?? this.startOffset,
    fromStyle: fromStyle ?? this.fromStyle,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    barrierLabel: barrierLabel ?? this.barrierLabel,
    barrierColor: barrierColor ?? this.barrierColor,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    routeSettings: routeSettings ?? this.routeSettings,
  );

  DialogOptions merge([DialogOptions? options]) => copyWith(
    useSafeArea: options?.useSafeArea,
    anchorPoint: options?.anchorPoint,
    startOffset: options?.startOffset,
    fromStyle: options?.fromStyle,
    barrierDismissible: options?.barrierDismissible,
    barrierLabel: options?.barrierLabel,
    barrierColor: options?.barrierColor,
    transitionDuration: options?.transitionDuration,
    transitionBuilder: options?.transitionBuilder,
    useRootNavigator: options?.useRootNavigator,
    routeSettings: options?.routeSettings,
  );
}

class BottomSheetOptions extends GeneralModalOptions {
  const BottomSheetOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.transitionAnimationController,
    this.enableDrag = true,
    this.isScrollControlled = true,
    this.constraints,
  });

  /// BottomSheet 背景色
  final Color? backgroundColor;

  /// 底部阴影
  final double? elevation;

  final ShapeBorder? shape;

  final Clip? clipBehavior;

  /// 开启滑动关闭 默认[true]
  final bool enableDrag;

  /// [isScrollControlled] = true 可全屏显示 默认 [true]
  final bool isScrollControlled;

  final BoxConstraints? constraints;

  final AnimationController? transitionAnimationController;

  BottomSheetOptions copyWith({
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? barrierDismissible,
    bool? enableDrag,
    bool? isScrollControlled,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    AnimationController? transitionAnimationController,
    BoxConstraints? constraints,
    Offset? anchorPoint,
  }) => BottomSheetOptions(
    anchorPoint: anchorPoint ?? this.anchorPoint,
    constraints: constraints ?? this.constraints,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shape: shape ?? this.shape,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    barrierColor: barrierColor ?? this.barrierColor,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    enableDrag: enableDrag ?? this.enableDrag,
    isScrollControlled: isScrollControlled ?? this.isScrollControlled,
    routeSettings: routeSettings ?? this.routeSettings,
    useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    transitionAnimationController:
        transitionAnimationController ?? this.transitionAnimationController,
  );

  BottomSheetOptions merge([BottomSheetOptions? options]) => copyWith(
    anchorPoint: options?.anchorPoint,
    constraints: options?.constraints,
    backgroundColor: options?.backgroundColor,
    elevation: options?.elevation,
    shape: options?.shape,
    clipBehavior: options?.clipBehavior,
    barrierColor: options?.barrierColor,
    barrierDismissible: options?.barrierDismissible,
    enableDrag: options?.enableDrag,
    isScrollControlled: options?.isScrollControlled,
    routeSettings: options?.routeSettings,
    useRootNavigator: options?.useRootNavigator,
    transitionAnimationController: options?.transitionAnimationController,
  );
}

class CupertinoModalPopupOptions extends GeneralModalOptions {
  const CupertinoModalPopupOptions({
    super.barrierDismissible,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.filter,
    this.semanticsDismissible = false,
  });

  final ImageFilter? filter;

  final bool semanticsDismissible;

  CupertinoModalPopupOptions copyWith({
    Color? barrierColor,
    bool? barrierDismissible,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    Offset? anchorPoint,
    ImageFilter? filter,
    bool? semanticsDismissible,
  }) => CupertinoModalPopupOptions(
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    routeSettings: routeSettings ?? this.routeSettings,
    barrierColor: barrierColor ?? this.barrierColor,
    anchorPoint: anchorPoint ?? this.anchorPoint,
    filter: filter ?? this.filter,
    semanticsDismissible: semanticsDismissible ?? this.semanticsDismissible,
  );

  CupertinoModalPopupOptions merge([CupertinoModalPopupOptions? options]) =>
      copyWith(
        barrierDismissible: options?.barrierDismissible,
        useRootNavigator: options?.useRootNavigator,
        routeSettings: options?.routeSettings,
        barrierColor: options?.barrierColor,
        anchorPoint: options?.anchorPoint,
        filter: options?.filter,
        semanticsDismissible: options?.semanticsDismissible,
      );
}
