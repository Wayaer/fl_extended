import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_extended/fl_extended.dart';

class Universal extends StatelessWidget {
  const Universal({
    super.key,
    this.isScroll = false,
    this.useSingleChildScrollView = true,
    this.useListView = false,
    this.isStack = false,
    this.isWrap = false,
    this.expanded = false,
    this.flexible = false,
    this.expand = false,
    this.intrinsicHeight = false,
    this.intrinsicWidth = false,
    this.stepWidth,
    this.stepHeight,
    this.isOval = false,
    this.isClipRRect = false,
    this.isClipRect = false,
    this.visible = true,
    this.offstage = false,
    this.reverse = false,
    this.maintainState = false,
    this.transitionOnUserGestures = false,
    this.isCircleAvatar = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    this.excludeFromSemantics = false,
    this.noScrollBehavior = true,
    this.sized = true,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
    this.safeLTRB = false,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.replacement = const SizedBox.shrink(),
    this.stackFit = StackFit.loose,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapAlignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.verticalDirection = VerticalDirection.down,
    this.direction = Axis.vertical,
    this.scrollDirection,
    this.behavior = HitTestBehavior.opaque,
    this.borderRadius,
    this.color,
    this.alignment,
    this.child,
    this.children,
    this.padding,
    this.physics,
    this.scrollController,
    this.primary,
    this.foregroundDecoration,
    this.transform,
    this.origin,
    this.constraints,
    this.width,
    this.height,
    this.size,
    this.aspectRatio,
    this.margin,
    this.decoration,
    this.textBaseline,
    this.textDirection,
    this.onPressed,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.onLongPress,
    this.onLongPressCancel,
    this.onLongPressDown,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.trackpadScrollCausesScale = false,
    this.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
    this.supportedDevices,
    this.radius,
    this.heroTag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.backgroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundImage,
    this.foregroundColor,
    this.minRadius,
    this.maxRadius,
    this.clipper,
    this.onSecondaryTap,
    this.onSecondaryLongPressMoveUpdate,
    this.onSecondaryLongPressUp,
    this.onSecondaryLongPress,
    this.onSecondaryLongPressEnd,
    this.onSecondaryLongPressStart,
    this.onSecondaryLongPressCancel,
    this.onSecondaryLongPressDown,
    this.onTertiaryLongPress,
    this.onTertiaryLongPressCancel,
    this.onTertiaryLongPressDown,
    this.onTertiaryLongPressEnd,
    this.onTertiaryLongPressMoveUpdate,
    this.onTertiaryLongPressStart,
    this.onTertiaryLongPressUp,
    this.onTertiaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.flex = 1,
    this.opacity,
    this.clipBehavior,
    this.widthFactor,
    this.heightFactor,
    this.filter,
    this.fit,
    this.systemOverlayStyle,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.blendMode = BlendMode.srcOver,
    this.unifiedButtonCategory,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
  });

  /// ****** [AnnotatedRegion]  ****** ///
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// [AnnotatedRegion] sized
  final bool sized;

  /// [GestureDetector]、[SingleChildScrollView] 使用
  final DragStartBehavior dragStartBehavior;

  /// ****** [IntrinsicHeight]、[IntrinsicWidth] ****** ///
  final bool intrinsicHeight;
  final bool intrinsicWidth;
  final double? stepWidth;
  final double? stepHeight;

  /// 控制剪辑方式
  /// [Clip.none]没有剪辑        最快
  /// [Clip.hardEdge]不抗锯齿    快
  /// [Clip.antiAlias]抗锯齿     慢
  /// [Clip.antiAliasWithSaveLayer]抗锯齿和saveLayer  很慢
  /// 使用到的组件[Stack]、[ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval]、[Stack]、[Flex]、[SingleChildScrollView]
  final Clip? clipBehavior;

  /// ****** [Align] ****** ///
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  /// [ClipRRect]剪辑半径
  final BorderRadius? borderRadius;

  /// ****** [child]、[children] ****** ///
  /// child < children
  /// 两个只有一个有效
  final Widget? child;
  final List<Widget>? children;

  /// ****** [Wrap] ****** ///
  final bool isWrap;
  final WrapAlignment wrapAlignment;
  final double spacing;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final WrapCrossAlignment wrapCrossAlignment;

  /// ****** [Flexible] ****** ///
  final int flex;

  /// [expanded]=true 相当于添加[Expanded]组件
  final bool expanded;

  /// [flexible]=true 相当于添加[Flexible]组件
  final bool flexible;

  /// ****** [Transform] ****** ///
  final Matrix4? transform;
  final Offset? origin;

  /// ****** [ConstrainedBox] ****** ///
  final BoxConstraints? constraints;

  /// ****** [ColoredBox] || [DecoratedBox] || [CircleAvatar] ****** ///
  final Color? color;

  /// ****** [Padding] ****** ///
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  /// ****** [DecoratedBox] ****** ///
  final Decoration? decoration;
  final Decoration? foregroundDecoration;

  /// ****** [Positioned] ****** ///
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  /// ****** [FittedBox] ****** ///
  final BoxFit? fit;

  /// ****** [Flex]=[Column]+[Row] ****** ///
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final MainAxisSize mainAxisSize;

  /// ****** [ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval] ****** ///
  /// [RRect]、[Path]、[Rect]
  final CustomClipper<dynamic>? clipper;
  final bool isOval;
  final bool isClipRRect;
  final bool isClipRect;

  /// ****** [CircleAvatar] ****** ///
  final bool isCircleAvatar;
  final double? radius;
  final ImageErrorListener? onBackgroundImageError;
  final ImageErrorListener? onForegroundImageError;

  ///  foregroundImage > foregroundColor > backgroundImage > color
  final ImageProvider? backgroundImage;
  final Color? foregroundColor;
  final ImageProvider? foregroundImage;
  final double? minRadius;
  final double? maxRadius;

  /// ****** 开启滚动 ****** ///
  final bool isScroll;

  /// 是否使用 [SingleChildScrollView]创建滚动组件
  /// 页面逻辑复杂时 设置为 false 以提高滑动性能
  final bool useSingleChildScrollView;

  /// 使用[ListView]加载滚动
  final bool useListView;

  /// 移出头部和底部蓝色阴影
  final bool noScrollBehavior;

  /// ****** [SingleChildScrollView] ****** ///
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final Axis? scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;

  /// ****** [SizedBox] ****** ///
  final bool expand;
  final Size? size;
  final double? width;
  final double? height;

  /// ****** [AspectRatio] ****** ///
  final double? aspectRatio;

  /// ****** [Visibility] ****** ///
  final Widget replacement;
  final bool visible;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;
  final bool offstage;

  /// ****** [Opacity] ****** ///
  final double? opacity;

  /// ****** 点击事件相关 ****** ///

  /// [unifiedButtonCategory]!=null 使用[UnifiedButton]处理点击事件
  /// ****** [UnifiedButton] ****** ///
  final VoidCallback? onPressed;
  final UnifiedButtonCategory? unifiedButtonCategory;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final WidgetStatesController? statesController;

  /// ****** [GestureDetector] ****** ///
  /// [unifiedButtonCategory]==null 使用[GestureDetector]处理点击事件
  ///
  /// 手指点击时的回调函数
  final GestureTapCallback? onTap;

  /// 手指松开时的回调函数
  final GestureTapUpCallback? onTapUp;

  /// 用户在短时间内触摸了屏幕两次
  final GestureTapCallback? onDoubleTap;
  final GestureTapDownCallback? onDoubleTapDown;
  final GestureTapCancelCallback? onDoubleTapCancel;

  /// 用户触摸屏幕时间超过500ms时触发
  final GestureLongPressCallback? onLongPress;

  /// 手指按下时的回调函数
  final GestureTapDownCallback? onTapDown;

  /// 手指取消点击时的回调函数
  final GestureTapCancelCallback? onTapCancel;

  final bool excludeFromSemantics;

  /// ****** [GestureDetector] ****** ///

  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// 用户触摸屏幕时间超过500ms时触发开始
  final GestureLongPressStartCallback? onLongPressStart;

  /// 用户触摸屏幕时间超过500ms时移动触摸
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// 用户触摸屏幕时间超过500ms时抬起触发
  final GestureLongPressUpCallback? onLongPressUp;

  /// 用户触摸屏幕时间超过500ms时触发结束
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressCancelCallback? onLongPressCancel;
  final GestureLongPressDownCallback? onLongPressDown;

  /// 当一个触摸点开始跟屏幕交互，同时在垂直方向上移动时触发
  final GestureDragDownCallback? onVerticalDragDown;

  /// 当触摸点开始在垂直方向上移动时触发
  final GestureDragStartCallback? onVerticalDragStart;

  /// 屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  /// 当用户停止移动，这个拖拽操作就被认为是完成了，就会触发这个回调
  final GestureDragEndCallback? onVerticalDragEnd;

  /// 用户突然停止拖拽时触发
  final GestureDragCancelCallback? onVerticalDragCancel;

  /// 当一个触摸点开始跟屏幕交互，同时在水平方向上移动时触发
  final GestureDragDownCallback? onHorizontalDragDown;

  /// 当触摸点开始在水平方向上移动时触发
  final GestureDragStartCallback? onHorizontalDragStart;

  /// 屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  /// 水平拖拽结束时触发
  final GestureDragEndCallback? onHorizontalDragEnd;

  /// onHorizontalDragDown没有成功完成时触发
  final GestureDragCancelCallback? onHorizontalDragCancel;

  /// 当触摸点开始跟屏幕交互时触发
  final GestureDragDownCallback? onPanDown;

  /// 当触摸点开始移动时触发
  final GestureDragStartCallback? onPanStart;

  /// 屏幕上的触摸点位置每次改变时，都会触发这个回调
  final GestureDragUpdateCallback? onPanUpdate;

  /// pan操作完成时触发
  final GestureDragEndCallback? onPanEnd;

  /// 用户触摸了屏幕，但是没有完成Tap的动作时触发
  final GestureDragCancelCallback? onPanCancel;

  /// 触摸点开始跟屏幕交互时触发，同时会建立一个焦点为1.0
  final GestureScaleStartCallback? onScaleStart;

  /// 跟屏幕交互时触发，同时会标示一个新的焦点
  final GestureScaleUpdateCallback? onScaleUpdate;

  /// 触摸点不再跟屏幕有任何交互，同时也表示这个scale手势完成
  final GestureScaleEndCallback? onScaleEnd;
  final GestureForcePressStartCallback? onForcePressStart;
  final GestureForcePressPeakCallback? onForcePressPeak;
  final GestureForcePressUpdateCallback? onForcePressUpdate;
  final GestureForcePressEndCallback? onForcePressEnd;
  final GestureLongPressCallback? onTertiaryLongPress;
  final GestureLongPressCancelCallback? onTertiaryLongPressCancel;
  final GestureLongPressDownCallback? onTertiaryLongPressDown;
  final GestureLongPressEndCallback? onTertiaryLongPressEnd;
  final GestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate;
  final GestureLongPressStartCallback? onTertiaryLongPressStart;
  final GestureLongPressUpCallback? onTertiaryLongPressUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCallback? onSecondaryTap;
  final GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;
  final GestureLongPressCallback? onSecondaryLongPressUp;
  final GestureLongPressCallback? onSecondaryLongPress;
  final GestureLongPressEndCallback? onSecondaryLongPressEnd;
  final GestureLongPressStartCallback? onSecondaryLongPressStart;
  final GestureLongPressCancelCallback? onSecondaryLongPressCancel;
  final GestureLongPressDownCallback? onSecondaryLongPressDown;
  final Set<PointerDeviceKind>? supportedDevices;
  final bool trackpadScrollCausesScale;
  final Offset trackpadScrollToScaleFactor;

  /// HitTestBehavior.opaque 自己处理事件
  /// HitTestBehavior.deferToChild child处理事件
  /// HitTestBehavior.translucent 自己和child都可以接收事件
  final HitTestBehavior behavior;

  /// ****** [Hero] ****** ///
  final Object? heroTag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final bool transitionOnUserGestures;
  final HeroPlaceholderBuilder? placeholderBuilder;

  /// ****** [Stack] ****** ///
  final bool isStack;
  final StackFit stackFit;

  /// ****** [ImageFilter] ****** ///
  final ImageFilter? filter;
  final BlendMode blendMode;

  /// ****** [SafeArea] ****** ///
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;
  final bool safeLTRB;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    if (decoration == null) return padding;
    final EdgeInsetsGeometry decorationPadding = decoration!.padding;
    if (padding == null) return decorationPadding;
    return padding!.add(decorationPadding);
  }

  @override
  Widget build(BuildContext context) {
    Widget current = const SizedBox();
    if (children != null && children!.isNotEmpty) {
      if (child != null) children!.insert(0, child!);
      if (isStack) {
        current = buildStack(children!);
      } else if (isWrap) {
        current = buildWrap(children!);
      } else {
        current = buildFlex(children!);
      }
      if (intrinsicWidth) {
        current = IntrinsicWidth(
          stepWidth: stepWidth,
          stepHeight: stepHeight,
          child: current,
        );
      }
    } else if (child != null) {
      current = child!;
    }

    if (intrinsicHeight) current = IntrinsicHeight(child: current);
    if (isScroll) {
      if (useListView) {
        if (children != null && children!.isNotEmpty && !isStack && !isWrap) {
          current = buildListView(children!);
        } else {
          current = buildListView([current]);
        }
      } else if (useSingleChildScrollView) {
        if (padding != null) {
          current = Padding(padding: padding!, child: current);
        }
        current = buildSingleChildScrollView(current);
      } else {
        if (children != null && children!.isNotEmpty && !isStack && !isWrap) {
          current = buildCustomScrollView(
            children!.builder((Widget item) => SliverToBoxAdapter(child: item)),
          );
        } else {
          current = buildCustomScrollView([SliverToBoxAdapter(child: current)]);
        }
        if (padding != null) {
          current = buildPadding(current);
        }
      }
    } else {
      current = buildPadding(current);
    }
    if (alignment != null) {
      current = Align(
        alignment: alignment!,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: current,
      );
    }

    if (color != null && decoration == null) {
      current = ColoredBox(color: color!, child: current);
    }

    if (decoration != null &&
        clipBehavior != null &&
        clipBehavior != Clip.none) {
      current = buildClip(
        current,
        clipper: _DecorationClipper(
          textDirection: Directionality.of(context),
          decoration: decoration!,
        ),
      );
    }
    if (decoration != null) {
      if (decoration is BoxDecoration) {
        final boxDecoration = (decoration as BoxDecoration);
        current = DecoratedBox(
          decoration: boxDecoration.copyWith(
            color: boxDecoration.color ?? color,
            borderRadius: boxDecoration.borderRadius ?? borderRadius,
          ),
          child: current,
        );
      } else {
        current = DecoratedBox(decoration: decoration!, child: current);
      }
    }
    if (foregroundDecoration != null) {
      current = DecoratedBox(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        child: current,
      );
    }
    if (transform != null) {
      current = Transform(
        transform: transform!,
        origin: origin,
        child: current,
      );
    }

    if (unifiedButtonCategory != null &&
        (onTap != null ||
            onPressed != null ||
            onLongPress != null ||
            onHover != null)) {
      current = buildUnifiedButtonCategory(current);
    }
    if (enabledGestureDetector) {
      current = buildGestureDetector(current);
    }
    if (filter != null) current = buildBackdropFilter(current);
    if (expand) current = SizedBox.expand(child: current);
    if (width != null || height != null) {
      current = SizedBox(width: width, height: height, child: current);
    }
    if (size != null) current = SizedBox.fromSize(size: size, child: current);
    if (aspectRatio != null) {
      current = AspectRatio(aspectRatio: aspectRatio!, child: current);
    }
    if (heroTag != null) current = buildHero(current);
    if (isCircleAvatar) current = buildCircleAvatar(current);
    if (clipper != null || isOval || isClipRRect) {
      current = buildClip(current, clipper: clipper);
    }
    if (constraints != null) {
      current = ConstrainedBox(constraints: constraints!, child: current);
    }
    if (margin != null) current = Padding(padding: margin!, child: current);
    if (flexible) {
      current = buildFlexible(current, FlexFit.loose);
    } else if (expanded) {
      current = buildFlexible(current, FlexFit.tight);
    }
    if (left != null || top != null || right != null || bottom != null) {
      current = Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: current,
      );
    }
    if (fit != null) current = buildFittedBox(current);
    if (opacity != null) current = Opacity(opacity: opacity!, child: current);
    if (systemOverlayStyle != null) current = buildAnnotatedRegion(current);
    if (offstage) current = buildOffstage(current);
    if (!visible) current = buildVisibility(current);
    if (safeLeft || safeTop || safeRight || safeBottom || safeLTRB) {
      current = SafeArea(
        left: safeLTRB ? true : safeLeft,
        top: safeLTRB ? true : safeTop,
        right: safeLTRB ? true : safeRight,
        bottom: safeLTRB ? true : safeBottom,
        child: current,
      );
    }
    return current;
  }

  Widget buildAnnotatedRegion(Widget current) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        sized: sized,
        value: systemOverlayStyle!,
        child: current,
      );

  Widget buildFittedBox(Widget current) => FittedBox(
    fit: fit!,
    alignment: alignment ?? Alignment.center,
    clipBehavior: clipBehavior ?? Clip.none,
    child: current,
  );

  Widget buildPadding(Widget current) =>
      _paddingIncludingDecoration == null
          ? current
          : Padding(padding: _paddingIncludingDecoration!, child: current);

  Widget buildBackdropFilter(Widget current) =>
      BackdropFilter(blendMode: blendMode, filter: filter!, child: current);

  Widget buildOffstage(Widget current) =>
      Offstage(offstage: offstage, child: current);

  /// 裁剪组件
  Widget buildClip(Widget current, {CustomClipper<dynamic>? clipper}) {
    if (isOval) {
      return ClipOval(
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    } else if (clipper is CustomClipper<Rect> || isClipRect) {
      return ClipRect(
        clipper: clipper is CustomClipper<Rect> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        child: current,
      );
    } else if (clipper is CustomClipper<Path>) {
      return ClipPath(
        clipper: clipper,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    } else if (clipper is CustomClipper<RRect> || isClipRRect) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipper: clipper is CustomClipper<RRect> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    }
    return current;
  }

  Widget buildCircleAvatar(Widget current) => CircleAvatar(
    backgroundColor: color,
    backgroundImage: backgroundImage,
    onBackgroundImageError: onBackgroundImageError,
    onForegroundImageError: onForegroundImageError,
    foregroundColor: foregroundColor,
    foregroundImage: foregroundImage,
    radius: radius,
    minRadius: minRadius,
    maxRadius: maxRadius,
    child: current,
  );

  Widget buildHero(Widget current) => Hero(
    tag: heroTag!,
    createRectTween: createRectTween,
    flightShuttleBuilder: flightShuttleBuilder,
    placeholderBuilder: placeholderBuilder,
    transitionOnUserGestures: transitionOnUserGestures,
    child: current,
  );

  Widget buildVisibility(Widget current) => Visibility(
    replacement: replacement,
    visible: visible,
    maintainState: maintainState,
    maintainAnimation: maintainAnimation,
    maintainSize: maintainSize,
    maintainSemantics: maintainSemantics,
    maintainInteractivity: maintainInteractivity,
    child: current,
  );

  Widget buildFlexible(Widget current, FlexFit fit) =>
      Flexible(flex: flex, fit: fit, child: current);

  Widget buildListView(List<Widget> children) => ListView(
    physics: physics,
    reverse: reverse,
    padding: padding,
    primary: primary,
    dragStartBehavior: dragStartBehavior,
    controller: scrollController,
    scrollDirection: scrollDirection ?? direction,
    clipBehavior: clipBehavior ?? Clip.hardEdge,
    restorationId: restorationId,
    keyboardDismissBehavior: keyboardDismissBehavior,
    children: children,
  );

  Widget buildSingleChildScrollView(Widget current) => SingleChildScrollView(
    physics: physics,
    reverse: reverse,
    primary: primary,
    dragStartBehavior: dragStartBehavior,
    controller: scrollController,
    scrollDirection: scrollDirection ?? direction,
    clipBehavior: clipBehavior ?? Clip.hardEdge,
    restorationId: restorationId,
    keyboardDismissBehavior: keyboardDismissBehavior,
    child: current,
  );

  Widget buildCustomScrollView(List<Widget> slivers) => CustomScrollView(
    controller: scrollController,
    slivers: slivers,
    dragStartBehavior: dragStartBehavior,
    reverse: reverse,
    primary: primary,
    physics: physics,
    clipBehavior: clipBehavior ?? Clip.hardEdge,
    scrollDirection: scrollDirection ?? direction,
  );

  Widget buildFlex(List<Widget> children) => Flex(
    spacing: spacing,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    textBaseline: textBaseline,
    verticalDirection: verticalDirection,
    textDirection: textDirection,
    mainAxisSize: mainAxisSize,
    clipBehavior: clipBehavior ?? Clip.none,
    children: children,
  );

  Widget buildWrap(List<Widget> children) => Wrap(
    direction: direction,
    alignment: wrapAlignment,
    spacing: spacing,
    runAlignment: runAlignment,
    runSpacing: runSpacing,
    crossAxisAlignment: wrapCrossAlignment,
    clipBehavior: clipBehavior ?? Clip.none,
    verticalDirection: verticalDirection,
    textDirection: textDirection,
    children: children,
  );

  Widget buildStack(List<Widget> children) => Stack(
    alignment: alignment ?? AlignmentDirectional.topStart,
    textDirection: textDirection,
    fit: stackFit,
    clipBehavior: clipBehavior ?? Clip.hardEdge,
    children: children,
  );

  Widget buildUnifiedButtonCategory(Widget current) => UnifiedButton(
    category: unifiedButtonCategory!,
    onPressed: onTap ?? onPressed,
    onLongPress: onLongPress,
    onHover: onHover,
    onFocusChange: onFocusChange,
    style: style,
    clipBehavior: clipBehavior ?? Clip.none,
    focusNode: focusNode,
    autofocus: autofocus,
    statesController: statesController,
    child: current,
  );

  Widget buildGestureDetector(Widget current) => GestureDetector(
    onTap: onTap ?? onPressed,
    onTapDown: onTapDown,
    onTapUp: onTapUp,
    onTapCancel: onTapCancel,
    onDoubleTap: onDoubleTap,
    onDoubleTapDown: onDoubleTapDown,
    onDoubleTapCancel: onDoubleTapCancel,
    onLongPress: onLongPress,
    onLongPressStart: onLongPressStart,
    onLongPressMoveUpdate: onLongPressMoveUpdate,
    onLongPressUp: onLongPressUp,
    onLongPressEnd: onLongPressEnd,
    onLongPressCancel: onLongPressCancel,
    onLongPressDown: onLongPressDown,
    onSecondaryTapDown: onSecondaryTapDown,
    onSecondaryTapUp: onSecondaryTapUp,
    onSecondaryTapCancel: onSecondaryTapCancel,
    onSecondaryTap: onSecondaryTap,
    onSecondaryLongPressMoveUpdate: onSecondaryLongPressMoveUpdate,
    onSecondaryLongPressUp: onSecondaryLongPressUp,
    onSecondaryLongPress: onSecondaryLongPress,
    onSecondaryLongPressEnd: onSecondaryLongPressEnd,
    onSecondaryLongPressStart: onSecondaryLongPressStart,
    onSecondaryLongPressCancel: onSecondaryLongPressCancel,
    onSecondaryLongPressDown: onSecondaryLongPressDown,
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
    onTertiaryLongPress: onTertiaryLongPress,
    onTertiaryLongPressCancel: onTertiaryLongPressCancel,
    onTertiaryLongPressDown: onTertiaryLongPressDown,
    onTertiaryLongPressEnd: onTertiaryLongPressEnd,
    onTertiaryLongPressMoveUpdate: onTertiaryLongPressMoveUpdate,
    onTertiaryLongPressStart: onTertiaryLongPressStart,
    onTertiaryLongPressUp: onTertiaryLongPressUp,
    onTertiaryTapCancel: onTertiaryTapCancel,
    onTertiaryTapDown: onTertiaryTapDown,
    onTertiaryTapUp: onTertiaryTapUp,
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
    child: current,
  );

  bool get enabledGestureDetector =>
      onTap != null ||
      onPressed != null ||
      onDoubleTap != null ||
      onLongPress != null ||
      onHover != null ||
      onTapDown != null ||
      onTapUp != null ||
      onTapCancel != null ||
      onDoubleTapDown != null ||
      onDoubleTapCancel != null ||
      onLongPressStart != null ||
      onLongPressMoveUpdate != null ||
      onLongPressUp != null ||
      onLongPressEnd != null ||
      onLongPressCancel != null ||
      onLongPressDown != null ||
      onSecondaryTapDown != null ||
      onSecondaryTapUp != null ||
      onSecondaryTapCancel != null ||
      onSecondaryTap != null ||
      onSecondaryLongPressMoveUpdate != null ||
      onSecondaryLongPressUp != null ||
      onSecondaryLongPress != null ||
      onSecondaryLongPressEnd != null ||
      onSecondaryLongPressStart != null ||
      onSecondaryLongPressCancel != null ||
      onSecondaryLongPressDown != null ||
      onVerticalDragDown != null ||
      onVerticalDragStart != null ||
      onVerticalDragUpdate != null ||
      onVerticalDragEnd != null ||
      onVerticalDragCancel != null ||
      onHorizontalDragDown != null ||
      onHorizontalDragStart != null ||
      onHorizontalDragUpdate != null ||
      onHorizontalDragEnd != null ||
      onHorizontalDragCancel != null ||
      onForcePressStart != null ||
      onForcePressPeak != null ||
      onForcePressUpdate != null ||
      onForcePressEnd != null ||
      onTertiaryLongPress != null ||
      onTertiaryLongPressCancel != null ||
      onTertiaryLongPressDown != null ||
      onTertiaryLongPressEnd != null ||
      onTertiaryLongPressMoveUpdate != null ||
      onTertiaryLongPressStart != null ||
      onTertiaryLongPressUp != null ||
      onTertiaryTapCancel != null ||
      onTertiaryTapDown != null ||
      onTertiaryTapUp != null ||
      onPanDown != null ||
      onPanStart != null ||
      onPanUpdate != null ||
      onPanEnd != null ||
      onPanCancel != null ||
      onScaleStart != null ||
      onScaleUpdate != null ||
      onScaleEnd != null;
}

/// A clipper that uses [Decoration.getClipPath] to clip.
class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection? textDirection, required this.decoration})
    : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) =>
      decoration.getClipPath(Offset.zero & size, textDirection);

  @override
  bool shouldReclip(_DecorationClipper oldClipper) =>
      oldClipper.decoration != decoration ||
      oldClipper.textDirection != textDirection;
}
