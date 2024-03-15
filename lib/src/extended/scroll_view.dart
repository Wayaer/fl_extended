import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

/// 可刷新的滚动组件
/// 嵌套 sliver 家族组件
class RefreshScrollView extends StatelessWidget {
  const RefreshScrollView(
      {super.key,
      this.refreshConfig,
      this.padding,
      this.slivers = const [],
      this.noScrollBehavior = false,
      this.shrinkWrap = false,
      this.reverse = false,
      this.scrollDirection = Axis.vertical,
      this.anchor = 0.0,
      this.cacheExtent,
      this.controller,
      this.primary,
      this.physics,
      this.center,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.clipBehavior = Clip.hardEdge,
      this.scrollBehavior,
      this.restorationId});

  /// CustomScrollView
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final int? semanticChildCount;
  final double? cacheExtent;
  final double anchor;
  final Key? center;
  final ScrollBehavior? scrollBehavior;
  final ScrollPhysics? physics;
  final bool? primary;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;
  final List<Widget> slivers;

  /// Extra parameters
  final bool noScrollBehavior;
  final EdgeInsetsGeometry? padding;
  final RefreshConfig? refreshConfig;

  bool _shrinkWrap(bool shrinkWrap, ScrollPhysics? physics) {
    if (physics == const NeverScrollableScrollPhysics()) return true;
    return shrinkWrap;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = buildCustomScrollView(physics);
    if (noScrollBehavior) {
      widget = ScrollConfiguration(behavior: NoScrollBehavior(), child: widget);
    }
    if (refreshConfig != null) {
      widget = EasyRefreshed(
          config: refreshConfig!.copyWith(scrollController: controller),
          builder: (_, ScrollPhysics physics) =>
              buildCustomScrollView(physics));
    }
    if (padding != null) widget = Padding(padding: padding!, child: widget);
    return widget;
  }

  List<Widget> buildSlivers() => slivers;

  CustomScrollView buildCustomScrollView(ScrollPhysics? physics) =>
      CustomScrollView(
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: _shrinkWrap(shrinkWrap, physics),
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          scrollDirection: scrollDirection,
          reverse: reverse,
          slivers: buildSlivers(),
          anchor: anchor,
          center: center,
          scrollBehavior: scrollBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          semanticChildCount: semanticChildCount);
}

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}
