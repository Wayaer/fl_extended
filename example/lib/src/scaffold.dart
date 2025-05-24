import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ExtendedScaffold
class ExtendedScaffold<T> extends StatelessWidget {
  const ExtendedScaffold({
    super.key,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
    this.isStack = false,
    this.isScroll = false,
    this.appBar,
    this.child,
    this.padding,
    this.floatingActionButton,
    this.bottomNavigationBar,

    /// 类似于 Android 中的 android:windowSoftInputMode=”adjustResize”，
    /// 控制界面内容 body 是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，
    /// 重新布局避免被键盘盖住内容。默认值为 true。
    this.resizeToAvoidBottomInset,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.enableDoubleClickExit = false,
    this.onPopInvokedWithResult,
    this.canPop = true,
    this.canHideOverlay = true,
  });

  /// 相当于给[body] 套用 [Column]、[Row]、[Stack]
  final List<Widget>? children;

  /// [children].length > 0 && [isStack]=false 有效;
  final MainAxisAlignment mainAxisAlignment;

  /// [children].length > 0 && [isStack]=false 有效;
  final CrossAxisAlignment crossAxisAlignment;

  /// [children].length > 0有效;
  /// 添加 [Stack]组件
  final bool isStack;

  /// 是否添加滚动组件
  final bool isScroll;

  final EdgeInsetsGeometry? padding;

  /// Scaffold相关属性
  final Widget? child;

  final Widget? appBar;
  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final bool? resizeToAvoidBottomInset;

  /// ****** [SafeArea] ****** ///
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;
  final bool enableDoubleClickExit;

  /// [FlPopScope] 相关属性
  final bool canPop;
  final bool canHideOverlay;
  final PopInvokedWithResultAndOverlayCallback<T>? onPopInvokedWithResult;

  static DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
      key: key,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      appBar: buildAppBar(context),
      bottomNavigationBar: bottomNavigationBar,
      body: universal,
    );
    return buildPopScope(scaffold);
  }

  Widget buildPopScope(Widget current) {
    return FlPopScope<T>(
      canPop: canPop,
      canHideOverlay: canHideOverlay,
      onPopInvokedWithResult: (bool didPop, T? result, bool didCloseOverlay) {
        onPopInvokedWithResult?.call(didPop, result, didCloseOverlay);
        if (enableDoubleClickExit) {
          final now = DateTime.now();
          if (_dateTime != null &&
              now.difference(_dateTime!).inMilliseconds < 2500) {
            SystemNavigator.pop();
          } else {
            _dateTime = now;
            showToast(
              '再次点击返回键退出',
              duration: const Duration(milliseconds: 1500),
            );
          }
        }
      },
      child: current,
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (appBar is AppBar) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight - 12),
          child: appBar!,
        );
  }

  Universal get universal => Universal(
    expand: true,
    padding: padding,
    isScroll: isScroll,
    safeLeft: safeLeft,
    safeTop: safeTop,
    safeRight: safeRight,
    safeBottom: safeBottom,
    isStack: isStack,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    child: child,
    children: children,
  );
}
