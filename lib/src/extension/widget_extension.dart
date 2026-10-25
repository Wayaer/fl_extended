import 'dart:ui';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [Widget] 导航与弹层快捷方法
extension ExtensionWidgetMethod on Widget {
  /// 将当前 Widget 作为新页面打开
  Future<T?> push<T extends Object?>({PageRouteOptions? options}) {
    final PageRouteOptions routeOptions = options ?? PageRouteOptions(style: FlExtended().pushStyle);
    return FlExtended().navigatorState.push<T>(routeOptions.buildPageRoute(this));
  }

  /// 用当前 Widget 替换当前页
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>({PageRouteOptions? options, TO? result}) {
    final PageRouteOptions routeOptions = options ?? PageRouteOptions(style: FlExtended().pushStyle);
    return FlExtended().navigatorState.pushReplacement<T, TO>(routeOptions.buildPageRoute(this), result: result);
  }

  /// 打开当前 Widget 并清空其余路由
  Future<T?> pushAndRemoveUntil<T extends Object?>({PageRouteOptions? options, required RoutePredicate predicate}) {
    final PageRouteOptions routeOptions = options ?? PageRouteOptions(style: FlExtended().pushStyle);
    return FlExtended().navigatorState.pushAndRemoveUntil<T>(routeOptions.buildPageRoute(this), predicate);
  }

  /// 对应 [FlOverlay.show]
  FlOverlayEntry? showOverlay({bool isCached = true}) => FlOverlay().show(this, isCached: isCached);

  /// 对应 [showGeneralDialog]
  Future<T?> popupGeneralDialog<T>({RoutePageBuilder? builder, GeneralDialogOptions? options}) {
    final GeneralDialogOptions dialogOptions = FlExtended().generalDialogOptions.merge(options);
    final RoutePageBuilder pageBuilder = builder ?? toRoutePageBuilder;
    return showGeneralDialog<T>(
      context: FlExtended().navigatorState.context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        Widget child = pageBuilder(context, animation, secondaryAnimation);
        if (dialogOptions.useSafeArea) child = SafeArea(child: child);
        // GeneralDialog 路由本身不提供 Material / DefaultTextStyle，
        // 这里补一层主题文字样式，避免原始内容落到 Flutter 的调试兜底样式。
        return DefaultTextStyle(style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(), child: child);
      },
      barrierDismissible: dialogOptions.barrierDismissible,
      barrierLabel: dialogOptions.barrierLabel,
      barrierColor: dialogOptions.barrierColor,
      transitionDuration: dialogOptions.transitionDuration,
      transitionBuilder: dialogOptions.transitionBuilder ?? dialogOptions.fromStyle.transitionBuilder,
      useRootNavigator: dialogOptions.useRootNavigator,
      routeSettings: dialogOptions.routeSettings,
      anchorPoint: dialogOptions.anchorPoint,
    );
  }

  /// 关闭请调用 [closePopup]
  Future<T?> popupModalBottomSheet<T>({WidgetBuilder? builder, ModalBottomSheetOptions? options}) {
    final ModalBottomSheetOptions sheetOptions = FlExtended().modalBottomSheetOptions.merge(options);
    return showModalBottomSheet<T>(
      context: FlExtended().navigatorState.context,
      builder: builder ?? toWidgetBuilder,
      backgroundColor: sheetOptions.backgroundColor,
      elevation: sheetOptions.elevation,
      shape: sheetOptions.shape,
      clipBehavior: sheetOptions.clipBehavior,
      constraints: sheetOptions.constraints,
      barrierColor: sheetOptions.barrierColor,
      routeSettings: sheetOptions.routeSettings,
      transitionAnimationController: sheetOptions.transitionAnimationController,
      isScrollControlled: sheetOptions.isScrollControlled,
      useRootNavigator: sheetOptions.useRootNavigator,
      isDismissible: sheetOptions.barrierDismissible,
      anchorPoint: sheetOptions.anchorPoint,
      enableDrag: sheetOptions.enableDrag,
      useSafeArea: sheetOptions.useSafeArea,
    );
  }

  /// 以 Cupertino 模态弹出
  Future<T?> popupCupertinoModal<T>({WidgetBuilder? builder, CupertinoModalPopupOptions? options}) {
    final CupertinoModalPopupOptions popupOptions = FlExtended().cupertinoModalPopupOptions.merge(options);
    final WidgetBuilder pageBuilder = builder ?? toWidgetBuilder;
    return showCupertinoModalPopup<T>(
      context: FlExtended().navigatorState.context,
      builder: (BuildContext context) {
        // CupertinoModalPopup 同样不提供文字样式，补一层主题 DefaultTextStyle。
        return DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
          child: pageBuilder(context),
        );
      },
      filter: popupOptions.filter,
      barrierColor: popupOptions.barrierColor,
      barrierDismissible: popupOptions.barrierDismissible,
      semanticsDismissible: popupOptions.semanticsDismissible,
      routeSettings: popupOptions.routeSettings,
      useRootNavigator: popupOptions.useRootNavigator,
      anchorPoint: popupOptions.anchorPoint,
    );
  }
}

/// [Widget] 转换与装饰扩展
extension ExtensionWidget on Widget {
  /// 转为 [SliverToBoxAdapter]
  Widget get toSliverBox => SliverToBoxAdapter(child: this);

  /// 转为 [WidgetBuilder]
  WidgetBuilder get toWidgetBuilder =>
      (BuildContext context) => this;

  /// 转为 [LoadingBuilder]
  LoadingBuilder get toLoadingBuilder =>
      (BuildContext context, ProgressIndicatorOptions? progressIndicator) => this;

  /// 转为 [ToastBuilder]
  ToastBuilder get toToastBuilder =>
      (BuildContext context, ToastContent content) => this;

  /// 转为 [RoutePageBuilder]
  RoutePageBuilder get toRoutePageBuilder =>
      (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => this;

  /// 转为 [RouteTransitionsBuilder]
  RouteTransitionsBuilder get toRouteTransitionsBuilder =>
      (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => this;

  /// 包裹 [BackdropFilter]
  BackdropFilter backdropFilter({Key? key, ImageFilter? filter, double fuzzyDegree = 4}) => BackdropFilter(
    key: key,
    filter: filter ?? ImageFilter.blur(sigmaX: fuzzyDegree, sigmaY: fuzzyDegree),
    child: this,
  );

  FittedBox fittedBox({
    Key? key,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.none,
  }) => FittedBox(key: key, fit: fit, alignment: alignment, clipBehavior: clipBehavior, child: this);

  AnnotatedRegion<SystemUiOverlayStyle> statusBarStyle(SystemUiOverlayStyle style) =>
      AnnotatedRegion<SystemUiOverlayStyle>(value: style, child: this);

  /// 内边距
  Padding padding(EdgeInsetsGeometry padding) => Padding(padding: padding, child: this);

  Padding margin(EdgeInsetsGeometry margin, {Key? key}) => Padding(key: key, padding: margin, child: this);

  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );

  Widget paddingOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) => Padding(
    padding: EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
    child: this,
  );

  Widget marginAll(double margin) => Padding(padding: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );

  Widget marginOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) => Padding(
    padding: EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
    child: this,
  );

  /// 颜色
  ColoredBox color(Color color, {Key? key}) => ColoredBox(key: key, color: color, child: this);

  Card card({
    Color? color,
    Color? shadowColor,
    double? elevation,
    ShapeBorder? shape,
    bool? borderOnForeground,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool? semanticContainer,
  }) => Card(
    color: color,
    shadowColor: shadowColor,
    elevation: elevation,
    shape: shape,
    borderOnForeground: borderOnForeground ?? true,
    margin: margin,
    clipBehavior: clipBehavior,
    semanticContainer: semanticContainer ?? true,
    child: this,
  );

  Positioned positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) => Positioned(
    key: key,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    width: width,
    height: height,
    child: this,
  );

  Center center({Key? key, double? widthFactor, double? heightFactor}) =>
      Center(key: key, widthFactor: widthFactor, heightFactor: heightFactor, child: this);

  SizedBox sizedBox({Key? key, double? width, double? height}) =>
      SizedBox(key: key, width: width, height: height, child: this);

  SizedBox setWidth(double width, {Key? key}) => SizedBox(key: key, width: width, child: this);

  SizedBox setHeight(double height, {Key? key}) => SizedBox(key: key, height: height, child: this);

  SizedBox setSize(Size size, {Key? key}) => fromSize(size, key: key);

  PreferredSize setPreferredHeight(double height, {Key? key}) =>
      PreferredSize(key: key, preferredSize: Size.fromHeight(height), child: this);

  PreferredSize setPreferredWidth(double width, {Key? key}) =>
      PreferredSize(key: key, preferredSize: Size.fromWidth(width), child: this);

  PreferredSize setPreferredSize(Size size, {Key? key}) => PreferredSize(key: key, preferredSize: size, child: this);

  Expanded get expanded => Expanded(child: this);

  Flexible get flexible => Flexible(child: this);

  SizedBox get expand => SizedBox.expand(child: this);

  SizedBox get shrink => SizedBox.shrink(child: this);

  AspectRatio aspectRatio(double aspectRatio, {Key? key}) =>
      AspectRatio(key: key, aspectRatio: aspectRatio, child: this);

  SizedBox fromSize(Size size, {Key? key}) => SizedBox.fromSize(key: key, size: size, child: this);

  Hero hero(
    Object tag, {
    Key? key,
    CreateRectTween? createRectTween,
    HeroFlightShuttleBuilder? flightShuttleBuilder,
    HeroPlaceholderBuilder? placeholderBuilder,
    bool transitionOnUserGestures = false,
  }) => Hero(
    key: key,
    tag: tag,
    createRectTween: createRectTween,
    flightShuttleBuilder: flightShuttleBuilder,
    placeholderBuilder: placeholderBuilder,
    transitionOnUserGestures: transitionOnUserGestures,
    child: this,
  );

  Container container({
    Key? key,
    EdgeInsetsGeometry? padding,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    BoxConstraints? constraints,
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Clip? clipBehavior,
    AlignmentGeometry? alignment,
  }) => Container(
    key: key,
    foregroundDecoration: foregroundDecoration,
    clipBehavior: clipBehavior ?? Clip.none,
    transform: transform,
    constraints: constraints,
    alignment: alignment,
    color: decoration == null ? color : null,
    width: width,
    height: height,
    padding: padding,
    margin: margin,
    decoration: decoration,
    child: this,
  );

  Align align({Key? key, Alignment alignment = Alignment.center, double? widthFactor, double? heightFactor}) =>
      Align(key: key, alignment: alignment, widthFactor: widthFactor, heightFactor: heightFactor, child: this);

  ClipRRect clipRRect({
    Key? key,
    BorderRadius borderRadius = BorderRadius.zero,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) => ClipRRect(key: key, borderRadius: borderRadius, clipper: clipper, clipBehavior: clipBehavior, child: this);

  ClipOval clipOval({Key? key, CustomClipper<Rect>? clipper, Clip clipBehavior = Clip.antiAlias}) =>
      ClipOval(key: key, clipper: clipper, clipBehavior: clipBehavior, child: this);

  ClipPath clipPath({Key? key, CustomClipper<Path>? clipper, Clip clipBehavior = Clip.antiAlias}) =>
      ClipPath(key: key, clipper: clipper, clipBehavior: clipBehavior, child: this);

  Offstage offstage(bool offstage, {Key? key}) => Offstage(key: key, offstage: offstage, child: this);

  Visibility visibility(bool visible, {Key? key}) => Visibility(key: key, visible: visible, child: this);

  LimitedBox limitedBox({Key? key, double maxWidth = double.infinity, double maxHeight = double.infinity}) =>
      LimitedBox(key: key, maxWidth: maxWidth, maxHeight: maxHeight, child: this);

  OverflowBox overflowBox({
    Key? key,
    Alignment alignment = Alignment.center,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) => OverflowBox(
    key: key,
    alignment: alignment,
    minWidth: minWidth,
    minHeight: minHeight,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    child: this,
  );

  SizedOverflowBox sizedOverflowBox(Size size, {Key? key, Alignment alignment = Alignment.center}) =>
      SizedOverflowBox(key: key, size: size, alignment: alignment, child: this);

  DecoratedBox decoratedBox(
    Decoration decoration, {
    Key? key,
    DecorationPosition position = DecorationPosition.background,
  }) => DecoratedBox(key: key, decoration: decoration, position: position, child: this);

  RotatedBox rotatedBox(int quarterTurns, {Key? key}) => RotatedBox(key: key, quarterTurns: quarterTurns, child: this);

  ConstrainedBox constrainedBox(BoxConstraints constraints, {Key? key}) =>
      ConstrainedBox(key: key, constraints: constraints, child: this);

  UnconstrainedBox unconstrainedBox({
    Key? key,
    TextDirection? textDirection,
    Alignment alignment = Alignment.center,
    Axis? constrainedAxis,
  }) => UnconstrainedBox(
    key: key,
    textDirection: textDirection,
    alignment: alignment,
    constrainedAxis: constrainedAxis,
    child: this,
  );

  GestureDetector onTap(GestureTapCallback? onTap, {Key? key}) => gestureDetector(onTap: onTap, key: key);

  GestureDetector onDoubleTap(GestureTapCallback onDoubleTap, {Key? key}) =>
      gestureDetector(onDoubleTap: onDoubleTap, key: key);

  GestureDetector onLongPress(GestureLongPressCallback onLongPress, {Key? key}) =>
      gestureDetector(onLongPress: onLongPress, key: key);

  GestureDetector gestureDetector({
    Key? key,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCallback? onTap,
    GestureTapCancelCallback? onTapCancel,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    GestureTapCancelCallback? onSecondaryTapCancel,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureDragDownCallback? onVerticalDragDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragDownCallback? onHorizontalDragDown,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureDragDownCallback? onPanDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Set<PointerDeviceKind>? supportedDevices,
    bool trackpadScrollCausesScale = false,
    Offset trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
  }) => GestureDetector(
    key: key,
    onTapDown: onTapDown,
    onTapUp: onTapUp,
    onTap: onTap,
    onTapCancel: onTapCancel,
    onSecondaryTapDown: onSecondaryTapDown,
    onSecondaryTapUp: onSecondaryTapUp,
    onSecondaryTapCancel: onSecondaryTapCancel,
    onDoubleTap: onDoubleTap,
    onLongPress: onLongPress,
    onLongPressStart: onLongPressStart,
    onLongPressMoveUpdate: onLongPressMoveUpdate,
    onLongPressUp: onLongPressUp,
    onLongPressEnd: onLongPressEnd,
    onVerticalDragDown: onVerticalDragDown,
    onVerticalDragStart: onVerticalDragStart,
    onVerticalDragUpdate: onVerticalDragUpdate,
    onVerticalDragEnd: onVerticalDragEnd,
    onVerticalDragCancel: onVerticalDragCancel,
    onHorizontalDragDown: onHorizontalDragDown,
    onHorizontalDragStart: onHorizontalDragStart,
    onHorizontalDragUpdate: onHorizontalDragUpdate,
    onHorizontalDragEnd: onHorizontalDragEnd,
    onHorizontalDragCancel: onHorizontalDragCancel,
    onForcePressStart: onForcePressStart,
    onForcePressPeak: onForcePressPeak,
    onForcePressUpdate: onForcePressUpdate,
    onForcePressEnd: onForcePressEnd,
    onPanDown: onPanDown,
    onPanStart: onPanStart,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    onPanCancel: onPanCancel,
    onScaleStart: onScaleStart,
    onScaleUpdate: onScaleUpdate,
    onScaleEnd: onScaleEnd,
    behavior: behavior,
    excludeFromSemantics: excludeFromSemantics,
    dragStartBehavior: dragStartBehavior,
    supportedDevices: supportedDevices,
    trackpadScrollCausesScale: trackpadScrollCausesScale,
    trackpadScrollToScaleFactor: trackpadScrollToScaleFactor,
    child: this,
  );
}

extension ExtensionBorderRadius on BorderRadius {
  BoxDecoration toBoxDecoration() => BoxDecoration(borderRadius: this);
}

extension ExtensionBorder on BoxBorder {
  BoxDecoration toBoxDecoration() => BoxDecoration(border: this);
}

extension ExtensionBoxShadow on List<BoxShadow> {
  BoxDecoration toBoxDecoration() => BoxDecoration(boxShadow: this);
}

extension ExtensionBoxShape on BoxShape {
  BoxDecoration toBoxDecoration() => BoxDecoration(shape: this);
}

extension ExtensionGradient on Gradient {
  BoxDecoration toBoxDecoration() => BoxDecoration(gradient: this);
}
