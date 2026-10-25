import 'dart:ui';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';

/// 关闭弹窗
/// 也可通过 `Navigator.of(context).maybePop()` 关闭
Future<bool> closePopup([dynamic value]) => maybePop(value);

/// 弹窗进入方向
enum PopupFromStyle {
  /// 从左边进入
  fromLeft,

  /// 从右边进入
  fromRight,

  /// 从顶部进入
  fromTop,

  /// 从底部进入
  fromBottom,

  /// 居中渐变显示
  fromCenter;

  RouteTransitionsBuilder get transitionBuilder =>
      (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        Offset translation;
        switch (this) {
          case PopupFromStyle.fromLeft:
            translation = Offset(animation.value - 1, 0);
            break;
          case PopupFromStyle.fromRight:
            translation = Offset(1 - animation.value, 0);
            break;
          case PopupFromStyle.fromTop:
            translation = Offset(0, animation.value - 1);
            break;
          case PopupFromStyle.fromBottom:
            translation = Offset(0, 1 - animation.value);
            break;
          case PopupFromStyle.fromCenter:
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
        }
        return FractionalTranslation(translation: translation, child: child);
      };
}

/// 通用模态弹层配置基类
abstract class GeneralModalOptions {
  const GeneralModalOptions({
    this.useRootNavigator = true,
    this.barrierColor = kCupertinoModalBarrierColor,
    this.barrierDismissible = true,
    this.anchorPoint,
    this.routeSettings,
  });

  /// 是否使用根导航器
  final bool useRootNavigator;

  /// 路由设置
  final RouteSettings? routeSettings;

  /// 遮罩背景色
  final Color barrierColor;

  /// 点击遮罩是否可关闭，默认 true
  final bool barrierDismissible;

  /// 锚点
  final Offset? anchorPoint;
}

/// 通用对话框配置；关闭请使用 [closePopup]
class GeneralDialogOptions extends GeneralModalOptions {
  const GeneralDialogOptions({
    super.barrierDismissible = false,
    super.useRootNavigator,
    super.routeSettings,
    super.barrierColor,
    super.anchorPoint,
    this.barrierLabel,
    this.useSafeArea = true,
    this.transitionBuilder,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.fromStyle = PopupFromStyle.fromCenter,
  });

  /// 遮罩语义标签
  final String? barrierLabel;

  /// 是否使用安全区域
  final bool useSafeArea;

  /// 弹窗进入方向
  final PopupFromStyle fromStyle;

  /// 从开始到完全显示的时长
  final Duration transitionDuration;

  /// 路由显示/隐藏过渡；参数为 animation、secondaryAnimation 与 pageBuilder 构建的 child
  final RouteTransitionsBuilder? transitionBuilder;

  GeneralDialogOptions copyWith({
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
  }) => GeneralDialogOptions(
    useSafeArea: useSafeArea ?? this.useSafeArea,
    anchorPoint: anchorPoint ?? this.anchorPoint,
    fromStyle: fromStyle ?? this.fromStyle,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    barrierLabel: barrierLabel ?? this.barrierLabel,
    barrierColor: barrierColor ?? this.barrierColor,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    routeSettings: routeSettings ?? this.routeSettings,
  );

  GeneralDialogOptions merge([GeneralDialogOptions? options]) => copyWith(
    useSafeArea: options?.useSafeArea,
    anchorPoint: options?.anchorPoint,
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

/// Material 底部弹层配置
class ModalBottomSheetOptions extends GeneralModalOptions {
  const ModalBottomSheetOptions({
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
    this.useSafeArea = true,
    this.isScrollControlled = true,
    this.constraints,
  });

  /// BottomSheet 背景色
  final Color? backgroundColor;

  /// 底部阴影海拔
  final double? elevation;

  /// 形状
  final ShapeBorder? shape;

  /// 裁剪行为
  final Clip? clipBehavior;

  /// 是否开启滑动关闭，默认 true
  final bool enableDrag;

  /// 是否开启安全区域，默认 true
  final bool useSafeArea;

  /// 是否可滚动控制（true 时可近全屏），默认 true
  final bool isScrollControlled;

  /// 尺寸约束
  final BoxConstraints? constraints;

  /// 过渡动画控制器
  final AnimationController? transitionAnimationController;

  ModalBottomSheetOptions copyWith({
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? barrierDismissible,
    bool? enableDrag,
    bool? useSafeArea,
    bool? isScrollControlled,
    RouteSettings? routeSettings,
    bool? useRootNavigator,
    AnimationController? transitionAnimationController,
    BoxConstraints? constraints,
    Offset? anchorPoint,
  }) => ModalBottomSheetOptions(
    anchorPoint: anchorPoint ?? this.anchorPoint,
    constraints: constraints ?? this.constraints,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shape: shape ?? this.shape,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    barrierColor: barrierColor ?? this.barrierColor,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    enableDrag: enableDrag ?? this.enableDrag,
    useSafeArea: useSafeArea ?? this.useSafeArea,
    isScrollControlled: isScrollControlled ?? this.isScrollControlled,
    routeSettings: routeSettings ?? this.routeSettings,
    useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    transitionAnimationController: transitionAnimationController ?? this.transitionAnimationController,
  );

  ModalBottomSheetOptions merge([ModalBottomSheetOptions? options]) => copyWith(
    anchorPoint: options?.anchorPoint,
    constraints: options?.constraints,
    backgroundColor: options?.backgroundColor,
    elevation: options?.elevation,
    shape: options?.shape,
    clipBehavior: options?.clipBehavior,
    barrierColor: options?.barrierColor,
    barrierDismissible: options?.barrierDismissible,
    enableDrag: options?.enableDrag,
    useSafeArea: options?.useSafeArea,
    isScrollControlled: options?.isScrollControlled,
    routeSettings: options?.routeSettings,
    useRootNavigator: options?.useRootNavigator,
    transitionAnimationController: options?.transitionAnimationController,
  );
}

/// Cupertino 模态弹层配置
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

  /// 图像滤镜
  final ImageFilter? filter;

  /// 是否可通过语义关闭
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

  CupertinoModalPopupOptions merge([CupertinoModalPopupOptions? options]) => copyWith(
    barrierDismissible: options?.barrierDismissible,
    useRootNavigator: options?.useRootNavigator,
    routeSettings: options?.routeSettings,
    barrierColor: options?.barrierColor,
    anchorPoint: options?.anchorPoint,
    filter: options?.filter,
    semanticsDismissible: options?.semanticsDismissible,
  );
}
