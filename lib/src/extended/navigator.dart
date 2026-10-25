import 'dart:async';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 返回键回调（含是否关闭了 Overlay）
typedef PopInvokedWithResultAndOverlayCallback<T> = void Function(bool didPop, T? result, bool didHideOverlay);

/// 返回键优先关闭 Overlay，再决定是否退出页面。
///
/// 有 Toast / Loading / 缓存 Overlay 且 [canHideOverlay] 为 true 时，本次返回不会 pop 路由，
/// 只会 [FlOverlay.hideAll]；Overlay 清空后下一次返回才按 [canPop] 处理。
class FlPopScope<T> extends StatelessWidget {
  const FlPopScope({
    super.key,
    required this.child,
    this.canPop = true,
    this.canHideOverlay = true,
    this.onPopInvokedWithResult,
  });

  /// 子组件
  final Widget child;

  /// 是否允许 pop 路由
  final bool canPop;

  /// 返回时是否优先关闭 Overlay
  final bool canHideOverlay;

  /// 返回键调用结果回调
  final PopInvokedWithResultAndOverlayCallback<T>? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FlOverlay(),
      child: child,
      builder: (BuildContext context, Widget? child) {
        final FlOverlay overlay = FlOverlay();
        final bool hasOverlay = overlay.hasOverlay;
        final bool effectiveCanPop = canPop && !(canHideOverlay && hasOverlay);
        return PopScope<T>(
          canPop: effectiveCanPop,
          onPopInvokedWithResult: (bool didPop, T? result) {
            bool didHideOverlay = false;
            if (!didPop && canHideOverlay && overlay.hasOverlay) {
              overlay.hideAll();
              didHideOverlay = true;
            }
            onPopInvokedWithResult?.call(didPop, result, didHideOverlay);
          },
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

/// 页面路由配置
class PageRouteOptions {
  const PageRouteOptions({
    required this.style,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.title,
    this.settings,
    this.allowSnapshotting = true,
    this.barrierDismissible = false,
    this.builder,
  });

  const PageRouteOptions.material({
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.settings,
    this.allowSnapshotting = true,
    this.barrierDismissible = false,
    this.builder,
  }) : title = null,
       style = RoutePushStyle.material;

  const PageRouteOptions.cupertino({
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.title,
    this.settings,
    this.allowSnapshotting = true,
    this.barrierDismissible = false,
    this.builder,
  }) : style = RoutePushStyle.cupertino;

  /// 对应 [PageRoute.maintainState]
  final bool maintainState;

  /// 是否以全屏对话框呈现
  final bool fullscreenDialog;

  /// 路由标题（Cupertino）
  final String? title;

  /// 路由设置
  final RouteSettings? settings;

  /// 是否允许快照
  final bool allowSnapshotting;

  /// 点击遮罩是否可关闭
  final bool barrierDismissible;

  /// 页面构建器
  final WidgetBuilder? builder;

  /// 路由风格
  final RoutePushStyle style;

  /// 拷贝并覆盖部分字段
  PageRouteOptions copyWith({
    bool? maintainState,
    bool? fullscreenDialog,
    String? title,
    RouteSettings? settings,
    bool? allowSnapshotting,
    bool? barrierDismissible,
    WidgetBuilder? builder,
    RoutePushStyle? style,
  }) => PageRouteOptions(
    maintainState: maintainState ?? this.maintainState,
    fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
    title: title ?? this.title,
    settings: settings ?? this.settings,
    allowSnapshotting: allowSnapshotting ?? this.allowSnapshotting,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    builder: builder ?? this.builder,
    style: style ?? this.style,
  );

  /// 与另一配置合并
  PageRouteOptions merge([PageRouteOptions? options]) => copyWith(
    maintainState: options?.maintainState,
    fullscreenDialog: options?.fullscreenDialog,
    title: options?.title,
    settings: options?.settings,
    allowSnapshotting: options?.allowSnapshotting,
    barrierDismissible: options?.barrierDismissible,
    builder: options?.builder,
    style: options?.style,
  );

  /// 按 [style] 构建对应风格的页面路由。
  PageRoute<T> buildPageRoute<T>(Widget widget) {
    switch (style) {
      case RoutePushStyle.cupertino:
        return CupertinoPageRoute<T>(
          title: title,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          barrierDismissible: barrierDismissible,
          allowSnapshotting: allowSnapshotting,
          builder: builder ?? widget.toWidgetBuilder,
        );
      case RoutePushStyle.material:
        return MaterialPageRoute<T>(
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          barrierDismissible: barrierDismissible,
          allowSnapshotting: allowSnapshotting,
          builder: builder ?? widget.toWidgetBuilder,
        );
    }
  }
}

/// 页面路由风格
enum RoutePushStyle {
  /// Cupertino 风格
  cupertino,

  /// Material 风格
  material,
}

PageRouteOptions _defaultPageRouteOptions([PageRouteOptions? options]) =>
    options ?? PageRouteOptions(style: FlExtended().pushStyle);

/// 打开新页面
Future<T?> push<T extends Object?>(Widget widget, {PageRouteOptions? options}) =>
    widget.push<T>(options: _defaultPageRouteOptions(options));

/// 打开新页面并替换当前页
Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
  Widget widget, {
  PageRouteOptions? options,
  TO? result,
}) => widget.pushReplacement<T, TO>(options: _defaultPageRouteOptions(options), result: result);

/// 打开新页面并清空栈中其余页面
Future<T?> pushAndRemoveUntil<T extends Object?>(
  Widget widget, {
  PageRouteOptions? options,
  RoutePredicate? predicate,
}) => widget.pushAndRemoveUntil(
  options: _defaultPageRouteOptions(options),
  predicate: predicate ?? (Route<dynamic> route) => route.isFirst,
);

/// 可能返回上一页（走 [Navigator.maybePop]）
Future<bool> maybePop<T extends Object>([T? result]) => FlExtended().navigatorState.maybePop<T>(result);

/// 返回上一页；[isMaybe] 为 true 时走 [maybePop]
Future<bool> pop<T extends Object>([T? result, bool isMaybe = false]) {
  if (isMaybe) return maybePop<T>(result);
  FlExtended().navigatorState.pop<T>(result);
  return Future<bool>.value(true);
}

/// 在异步导航完成后 pop；[nullBack] 为 true 时结果为 null 也继续返回
///
/// 返回的 Future 会把 [navigator] 的异常原样抛给调用方。
Future<void> popBack(Future<dynamic> navigator, {bool nullBack = false, bool useMaybePop = false}) async {
  final dynamic value = await navigator;
  if (nullBack || value != null) await pop(value, useMaybePop);
}

/// 循环 pop 直到满足 [predicate]（默认回到栈底）
void popUntil([RoutePredicate? predicate]) =>
    FlExtended().navigatorState.popUntil(predicate ?? (Route<dynamic> route) => route.isFirst);

/// 显示 [SnackBar]
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(SnackBar snackBar) {
  assert(
    FlExtended().scaffoldMessengerKey.currentState != null,
    'Set FlExtended().scaffoldMessengerKey to the MaterialApp',
  );
  return FlExtended().scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

/// 显示弹出菜单
Future<T?> showMenuPopup<T>({
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) => showMenu<T>(
  context: FlExtended().navigatorState.context,
  position: position,
  useRootNavigator: useRootNavigator,
  initialValue: initialValue,
  elevation: elevation,
  semanticLabel: semanticLabel,
  shape: shape,
  color: color,
  items: items,
);
