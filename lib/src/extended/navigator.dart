import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

typedef PopInvokedWithResultAndOverlayCallback<T> =
    void Function(bool didPop, T? result, bool didCloseOverlay);

typedef PopInvokedWithOverlayCallback =
    void Function(bool didPop, bool didCloseOverlay);

class ExtendedPopScope<T> extends PopScope<T> {
  ExtendedPopScope({
    super.key,
    required super.child,
    super.canPop = false,
    PopInvokedWithResultAndOverlayCallback? onPopInvokedWithResult,

    /// true 点击 android 实体返回按键先关闭 [Overlay]
    bool isCloseOverlay = true,
  }) : super(
         onPopInvokedWithResult: (bool didPop, T? result) {
           bool didCloseOverlay = false;
           if (FlOverlay().overlayEntries.isNotEmpty) {
             didCloseOverlay = true;
             if (isCloseOverlay) hideOverlay();
           }
           onPopInvokedWithResult?.call(didPop, result, didCloseOverlay);
         },
       );
}

/// page route
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
  }) : style = RoutePushStyle.material;

  /// maintainState
  final bool maintainState;

  /// fullscreenDialog
  final bool fullscreenDialog;

  /// title
  final String? title;

  /// settings
  final RouteSettings? settings;

  /// allowSnapshotting
  final bool allowSnapshotting;

  /// barrierDismissible
  final bool barrierDismissible;

  /// builder
  final WidgetBuilder? builder;

  /// style
  final RoutePushStyle style;

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

  /// Builds the primary contents of the route.
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

enum RoutePushStyle {
  /// Cupertino风格
  cupertino,

  /// Material风格
  material,
}

/// 打开新页面
Future<T?> push<T extends Object?, TO extends Object?>(
  Widget widget, {
  PageRouteOptions? options,
}) => widget.push<T>(
  widget,
  options: (options ??= PageRouteOptions(style: FlExtended().pushStyle)),
);

/// 打开新页面替换当前页面
Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
  Widget widget, {
  PageRouteOptions? options,
  TO? result,
}) => widget.pushReplacement<T, TO>(
  widget,
  options: (options ??= PageRouteOptions(style: FlExtended().pushStyle)),
  result: result,
);

/// 打开新页面 并移出堆栈所有页面
Future<T?> pushAndRemoveUntil<T extends Object?>(
  Widget widget, {
  PageRouteOptions? options,
  RoutePredicate? predicate,
}) => widget.pushAndRemoveUntil(
  widget,
  options: (options ??= PageRouteOptions(style: FlExtended().pushStyle)),
  predicate: predicate ?? (Route<dynamic> route) => route.isFirst,
);

/// 可能返回到上一个页面
Future<bool> maybePop<T extends Object>([T? result]) {
  assert(
    FlExtended().navigatorKey.currentState != null,
    'Set FlExtended().navigatorKey to one of [MaterialApp CupertinoApp WidgetsApp]',
  );
  return FlExtended().navigatorKey.currentState!.maybePop<T>(result);
}

/// 返回上一个页面
Future<bool> pop<T extends Object>([T? result, bool isMaybe = false]) {
  if (isMaybe) {
    return maybePop<T>(result);
  } else {
    assert(
      FlExtended().navigatorKey.currentState != null,
      'Set FlExtended().navigatorKey to one of [MaterialApp CupertinoApp WidgetsApp]',
    );
    FlExtended().navigatorKey.currentState!.pop<T>(result);
    return Future.value(true);
  }
}

/// pop 返回简写 带参数  [nullBack] =true  navigator 返回为空 就继续返回上一页面
void popBack(
  Future<dynamic> navigator, {
  bool nullBack = false,
  bool useMaybePop = false,
}) {
  final Future<dynamic> future = navigator;
  future.then((dynamic value) {
    if (nullBack) {
      pop(value, useMaybePop);
    } else {
      if (value != null) pop(value, useMaybePop);
    }
  });
}

/// 循环pop 直到pop至指定页面
void popUntil([RoutePredicate? predicate]) {
  assert(
    FlExtended().navigatorKey.currentState != null,
    'Set FlExtended().navigatorKey to one of [MaterialApp CupertinoApp WidgetsApp]',
  );
  return FlExtended().navigatorKey.currentState!.popUntil(
    predicate ?? (Route<dynamic> route) => route.isFirst,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
  SnackBar snackBar,
) {
  assert(
    FlExtended().scaffoldMessengerKey.currentState != null,
    'Set FlExtended().scaffoldMessengerKey to the MaterialApp',
  );
  return FlExtended().scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

Future<T?> showMenuPopup<T>({
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) {
  assert(FlExtended().navigatorKey.currentContext != null);
  return showMenu<T>(
    context: FlExtended().navigatorKey.currentContext!,
    position: position,
    useRootNavigator: useRootNavigator,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    shape: shape,
    color: color,
    items: items,
  );
}
