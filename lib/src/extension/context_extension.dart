import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension ExtensionNavigatorStateContext on BuildContext {
  /// [NavigatorState]
  NavigatorState get navigator => Navigator.of(this);

  /// 压入路由，见 [Navigator.push]
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push<T>(route);

  /// 按名称压入路由，见 [Navigator.pushNamed]
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);

  /// 可恢复地压入路由，见 [Navigator.restorablePush]
  String restorablePush<T extends Object?>(RestorableRouteBuilder<T> routeBuilder, {Object? arguments}) =>
      navigator.restorablePush<T>(routeBuilder, arguments: arguments);

  /// 可恢复地按名称压入路由，见 [Navigator.restorablePushNamed]
  String restorablePushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      navigator.restorablePushNamed<T>(routeName, arguments: arguments);

  /// 替换当前路由，见 [Navigator.pushReplacement]
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Route<T> newRoute, {TO? result}) =>
      navigator.pushReplacement<T, TO>(newRoute, result: result);

  /// 按名称替换当前路由，见 [Navigator.pushReplacementNamed]
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => navigator.pushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);

  /// 可恢复地替换当前路由，见 [Navigator.restorablePushReplacement]
  String restorablePushReplacement<T extends Object?, TO extends Object?>(
    RestorableRouteBuilder<T> routeBuilder, {
    TO? result,
    Object? arguments,
  }) => navigator.restorablePushReplacement<T, TO>(routeBuilder, result: result, arguments: arguments);

  /// 可恢复地按名称替换当前路由，见 [Navigator.restorablePushReplacementNamed]
  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => navigator.restorablePushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);

  /// 压入新路由并移除直到满足条件，见 [Navigator.pushAndRemoveUntil]
  Future<T?> pushAndRemoveUntil<T extends Object?>(Route<T> newRoute, RoutePredicate predicate) =>
      navigator.pushAndRemoveUntil<T>(newRoute, predicate);

  /// 按名称压入并移除直到满足条件，见 [Navigator.pushNamedAndRemoveUntil]
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) => navigator.pushNamedAndRemoveUntil<T>(newRouteName, predicate, arguments: arguments);

  /// 可恢复地按名称压入并移除直到满足条件，见 [Navigator.restorablePushNamedAndRemoveUntil]
  String restorablePushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) => navigator.restorablePushNamedAndRemoveUntil<T>(newRouteName, predicate, arguments: arguments);

  /// 弹出当前路由并按名称压入，见 [Navigator.popAndPushNamed]
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => navigator.popAndPushNamed<T, TO>(routeName, result: result, arguments: arguments);

  /// 可恢复地弹出并按名称压入，见 [Navigator.restorablePopAndPushNamed]
  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => navigator.restorablePopAndPushNamed<T, TO>(routeName, result: result, arguments: arguments);

  /// 可恢复地替换指定路由，见 [Navigator.restorableReplace]
  String restorableReplace<T extends Object?>({
    required Route<dynamic> oldRoute,
    required RestorableRouteBuilder<T> newRouteBuilder,
    Object? arguments,
  }) => navigator.restorableReplace<T>(oldRoute: oldRoute, newRouteBuilder: newRouteBuilder, arguments: arguments);

  /// 可恢复地替换锚点路由下方的路由，见 [Navigator.restorableReplaceRouteBelow]
  String restorableReplaceRouteBelow<T extends Object?>({
    required Route<dynamic> anchorRoute,
    required RestorableRouteBuilder<T> newRouteBuilder,
    Object? arguments,
  }) => navigator.restorableReplaceRouteBelow<T>(
    anchorRoute: anchorRoute,
    newRouteBuilder: newRouteBuilder,
    arguments: arguments,
  );

  /// 弹出路由，见 [Navigator.pop]
  void pop<T extends Object?>([T? result]) => navigator.pop<T>(result);

  /// 尝试弹出路由，见 [Navigator.maybePop]
  Future<bool> maybePop<T extends Object?>([T? result]) => navigator.maybePop<T>(result);

  /// 弹出直到满足条件，见 [Navigator.popUntil]
  void popUntil(RoutePredicate predicate) => navigator.popUntil(predicate);

  /// 移除指定路由，见 [Navigator.removeRoute]
  void removeRoute(Route<dynamic> route) => navigator.removeRoute(route);

  /// 移除指定路由下方的路由，见 [Navigator.removeRouteBelow]
  void removeRouteBelow(Route<dynamic> route) => navigator.removeRouteBelow(route);

  /// 是否可弹出，见 [Navigator.canPop]
  bool canPop() => navigator.canPop();

  /// 是否正在处理用户手势，见 [Navigator.userGestureInProgress]
  bool get userGestureInProgress => navigator.userGestureInProgress;
}

extension ExtensionFocusScopeContext on BuildContext {
  /// 当前 [FocusScope]
  FocusScopeNode get focusScope => FocusScope.of(this);

  FocusScopeNode get nearestScope => focusScope.nearestScope;

  bool get isFirstFocus => focusScope.isFirstFocus;

  bool get hasFocus => focusScope.hasFocus;

  bool get canRequestFocus => focusScope.canRequestFocus;

  bool get hasPrimaryFocus => focusScope.hasPrimaryFocus;

  FocusNode? get parent => focusScope.parent;

  /// [focusNode] 为 null 时移出焦点（关闭键盘）；非 null 时请求该节点焦点
  void requestFocus([FocusNode? focusNode]) {
    if (focusNode != null) {
      focusScope.requestFocus(focusNode);
    } else {
      focusScope.unfocus();
    }
  }

  /// 自动获取焦点
  void autofocus([FocusNode? focusNode]) => focusScope.autofocus(focusNode ?? FocusNode());

  bool nextFocus() => focusScope.nextFocus();

  bool previousFocus() => focusScope.previousFocus();

  bool focusInDirection(TraversalDirection direction) => focusScope.focusInDirection(direction);

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      focusScope.unfocus(disposition: disposition);

  FocusAttachment attach(BuildContext? context, {FocusOnKeyEventCallback? onKeyEvent}) =>
      focusScope.attach(context, onKeyEvent: onKeyEvent);

  void addListener(VoidCallback listener) => focusScope.addListener(listener);

  void removeListener(VoidCallback listener) => focusScope.removeListener(listener);

  void setFirstFocus(FocusScopeNode scope) => focusScope.setFirstFocus(scope);
}

extension ExtensionContext on BuildContext {
  /// 按比例取屏幕高度的一部分，适合响应式布局。
  /// [dividedBy]：将结果再除以该值（如 3 表示约 1/3 高度）。
  /// [reducedBy]：先按百分比缩减高度（如要 46% 高度则 reducedBy=54）。
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) =>
      (mediaQuerySize.height - ((mediaQuerySize.height / 100) * reducedBy)) / dividedBy;

  /// 按比例取屏幕宽度的一部分，适合响应式布局。
  /// [dividedBy]：将结果再除以该值（如 3 表示约 1/3 宽度）。
  /// [reducedBy]：先按百分比缩减宽度（如要 46% 宽度则 reducedBy=54）。
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) =>
      (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) / dividedBy;

  /// 按给定缩减比例计算高宽比
  double ratio({double dividedBy = 1, double reducedByW = 0.0, double reducedByH = 0.0}) =>
      heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
      widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);

  /// 当前主题，等同于 [Theme.of]
  ThemeData get theme => Theme.of(this);

  /// 文本主题
  TextTheme get textTheme => Theme.of(this).textTheme;

  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  IconButtonThemeData get iconButtonTheme => Theme.of(this).iconButtonTheme;

  TabBarThemeData get tabBarTheme => Theme.of(this).tabBarTheme;

  /// 是否为深色主题
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// 主题图标颜色
  Color? get iconColor => theme.iconTheme.color;

  /// 当前 context 将渲染到的 [FlutterView]
  FlutterView get view => View.of(this);

  /// 当前 context 将渲染到的 [FlutterView]（可能为 null）
  FlutterView? get maybeView => View.maybeOf(this);

  OverlayState? get overlay => Overlay.of(this);

  OverlayState? get maybeOverlay => Overlay.maybeOf(this);

  /// 获取组件边界（宽高、位置等）；组件需已完成渲染
  Rect get getWidgetBounds {
    final RenderBox? box = getRenderBox;
    return box?.semanticBounds ?? Rect.zero;
  }

  RenderBox? get getRenderBox {
    final RenderObject? renderObject = findRenderObject();
    return renderObject is RenderBox ? renderObject : null;
  }

  /// 获取组件在屏幕上的坐标；组件需已完成渲染
  Offset getWidgetLocalToGlobal({Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null ? Offset.zero : box.localToGlobal(point, ancestor: ancestor);
  }

  /// 获取组件在屏幕上的 Rect；组件需已完成渲染
  Rect? getWidgetRectLocalToGlobal({Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null ? null : box.localToGlobal(point, ancestor: ancestor) & box.size;
  }

  /// 将全局坐标转为组件本地坐标；组件需已完成渲染
  Offset getWidgetGlobalToLocal({Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null ? Offset.zero : box.globalToLocal(point, ancestor: ancestor);
  }

  /// 将全局点转为组件本地 Rect；组件需已完成渲染
  Rect? getWidgetRectGlobalToLocal({Offset point = Offset.zero, RenderObject? ancestor}) {
    final RenderBox? box = getRenderBox;
    return box == null ? null : box.globalToLocal(point, ancestor: ancestor) & box.size;
  }
}

extension ExtensionContextWithMediaQuery on BuildContext {
  /// 状态栏高度
  double get statusBarHeight => mediaQuery.padding.top;

  /// 底部导航栏（安全区）高度
  double get bottomNavigationBarHeight => mediaQuery.padding.bottom;

  /// 屏幕方向（横向 / 纵向）
  Orientation get orientation => mediaQuery.orientation;

  /// 用户是否通过 TalkBack / VoiceOver 等辅助功能交互
  bool get accessibleNavigation => mediaQuery.accessibleNavigation;

  /// 是否启用粗体文本
  bool get boldText => mediaQuery.boldText;

  /// 设备像素比（逻辑像素对应的物理像素数，未必为整数）
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// 平台是否要求尽量禁用或减少动画
  bool get disableAnimations => mediaQuery.disableAnimations;

  /// 设备是否反转颜色
  bool get invertColors => mediaQuery.invertColors;

  /// 被系统 UI 部分遮挡的内边距（如刘海、状态栏）
  EdgeInsets get padding => mediaQuery.padding;

  /// 被系统 UI 完全遮挡的区域（通常为键盘）
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// 被系统 UI 部分遮挡的 viewPadding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// 当前亮度模式
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  /// 设备尺寸（逻辑像素）
  Size get deviceSize => mediaQuery.size;

  /// 屏幕宽度分辨率（逻辑宽 × 像素比）
  double get widthPixel => mediaQuery.size.width * devicePixelRatio;

  /// 屏幕高度分辨率（逻辑高 × 像素比）
  double get heightPixel => mediaQuery.size.height * devicePixelRatio;

  /// 屏幕逻辑宽度
  double get deviceWidth => mediaQuery.size.width;

  /// 屏幕逻辑高度
  double get deviceHeight => mediaQuery.size.height;

  /// [MediaQueryData]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 等同于 [MediaQuery.sizeOf] / mediaQuery.size
  Size get mediaQuerySize => mediaQuery.size;

  /// 是否为横屏
  bool get isLandscape => orientation == Orientation.landscape;

  /// 是否为竖屏
  bool get isPortrait => orientation == Orientation.portrait;

  /// 屏幕较短边长度
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// 宽度大于 800 时视为可显示导航栏
  bool get showNavBar => width > 800;

  /// 屏幕高度（窗口尺寸变化时会更新）
  double get height => mediaQuerySize.height;

  /// 屏幕宽度（窗口尺寸变化时会更新）
  double get width => mediaQuerySize.width;

  /// 较短边小于 600 视为手机
  bool get isPhone => mediaQueryShortestSide < 600;

  /// 较短边 ≥ 600 视为小平板
  bool get isSmallTablet => mediaQueryShortestSide >= 600;

  /// 较短边 ≥ 720 视为大平板
  bool get isLargeTablet => mediaQueryShortestSide >= 720;

  /// 是否为平板
  bool get isTablet => isSmallTablet || isLargeTablet;
}
