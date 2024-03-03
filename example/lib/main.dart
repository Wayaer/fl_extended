import 'package:example/module/animation_page.dart';
import 'package:example/module/builder_page.dart';
import 'package:example/module/text_page.dart';
import 'package:example/module/decorator_page.dart';
import 'package:example/module/list_wheel_page.dart';
import 'package:example/module/overlay_page.dart';
import 'package:example/module/popup_page.dart';
import 'package:example/module/refresh_page.dart';
import 'package:example/module/scroll_list_page.dart';
import 'package:example/module/scroll_page.dart';
import 'package:example/module/text_field_page.dart';
import 'package:example/module/universal_page.dart';
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlExtended flExtended = FlExtended();

  flExtended.pushStyle = RoutePushStyle.material;

  /// 设置全局Toast配置
  flExtended.toastOptions = ToastOptions(
      modalColor: Colors.red.withOpacity(0.3), duration: 2.seconds);

  /// 设置全局BottomSheet配置
  flExtended.bottomSheetOptions = const BottomSheetOptions(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))));
  flExtended.dialogOptions =
      const DialogOptions(fromStyle: PopupFromStyle.fromTop);

  /// 设置全局Wheel配置
  flExtended.wheelOptions = const WheelOptions.cupertino();

  flExtended.logCrossLine = true;

  /// 设置全局Loading配置
  flExtended.loadingOptions = LoadingOptions(
      modalColor: Colors.red.withOpacity(0.3),
      custom: const BText('全局设置loading', fontSize: 20),
      onModalTap: closeLoading);

  runApp(DevicePreview(
      enabled: isDesktop || isWeb,
      defaultDevice: Devices.ios.iPhone13Mini,
      builder: (context) => const _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: FlExtended().navigatorKey,
        scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
        locale: DevicePreview.locale(context),
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        title: 'Fl Extended',
        home: ExtendedScaffold(
            enableDoubleClickExit: true,
            appBar: AppBarText('Flutter extended example'),
            child: _Home()),
        builder: DevicePreview.appBuilder);
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Universal(
        padding: const EdgeInsets.all(10),
        isWrap: true,
        isScroll: true,
        wrapAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        scrollDirection: Axis.vertical,
        children: [
          ElevatedText('Text', onTap: () => push(const TextPage())),
          ElevatedText('FlAnimation',
              onTap: () => push(const FlAnimationPage())),
          ElevatedText('Popup', onTap: () => push(const PopupPage())),
          ElevatedText('Overlay', onTap: () => push(const OverlayPage())),
          ElevatedText('Universal', onTap: () => push(const UniversalPage())),
          ElevatedText('ScrollView', onTap: () => push(const ScrollViewPage())),
          ElevatedText('ScrollList', onTap: () => push(const ScrollListPage())),
          ElevatedText('ListWheel', onTap: () => push(const ListWheelPage())),
          ElevatedText('EasyRefreshed',
              onTap: () => push(const EasyRefreshPage())),
          ElevatedText('DecoratorBox',
              onTap: () => push(const DecoratorBoxPage())),
          ElevatedText('ExtendedTextField',
              onTap: () => push(const TextFieldPage())),
          ElevatedText('ExtendedBuilder',
              onTap: () => push(const ExtendedBuilderPage())),
        ]);
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {super.key})
      : super(
            elevation: 0,
            title: BText(text, fontSize: 18, fontWeight: FontWeight.bold),
            centerTitle: true);
}

class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {this.onTap, super.key});

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(onPressed: onTap, child: BText(text)));
  }
}

class Partition extends StatelessWidget {
  const Partition(this.title, {super.key, this.onTap});

  final String title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => Universal(
      onTap: onTap,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: BText(title,
          textAlign: TextAlign.center, fontWeight: FontWeight.bold));
}

const List<Color> colorList = <Color>[
  ...Colors.accents,
  ...Colors.primaries,
];

/// ExtendedScaffold
class ExtendedScaffold extends StatelessWidget {
  const ExtendedScaffold(
      {super.key,
      this.safeLeft = false,
      this.safeTop = false,
      this.safeRight = false,
      this.safeBottom = false,
      this.isStack = false,
      this.isScroll = false,
      this.isCloseOverlay = true,
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
      this.refreshConfig,
      this.enableDoubleClickExit = false});

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

  /// true 点击android实体返回按键先关闭Overlay【toast loading ...】但不pop 当前页面
  /// false 点击android实体返回按键先关闭Overlay【toast loading ...】并pop 当前页面
  final bool isCloseOverlay;

  /// ****** 刷新组件相关 ******  ///
  final RefreshConfig? refreshConfig;

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

  static DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
        key: key,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButton: floatingActionButton,
        appBar: buildAppBar(context),
        bottomNavigationBar: bottomNavigationBar,
        body: universal);
    return isCloseOverlay
        ? ExtendedPopScope(
            isCloseOverlay: isCloseOverlay,
            onPopInvoked: (bool didPop, bool didCloseOverlay) {
              if (didCloseOverlay || didPop) return;
              if (enableDoubleClickExit) {
                final now = DateTime.now();
                if (_dateTime != null &&
                    now.difference(_dateTime!).inMilliseconds < 2500) {
                  SystemNavigator.pop();
                } else {
                  _dateTime = now;
                  showToast('再次点击返回键退出',
                      options: const ToastOptions(
                          duration: Duration(milliseconds: 1500)));
                }
              } else {
                pop();
              }
            },
            child: scaffold)
        : scaffold;
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (appBar is AppBar) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight - 12),
            child: appBar!);
  }

  Universal get universal => Universal(
      expand: true,
      refreshConfig: refreshConfig,
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
      children: children);
}

List<BoxShadow> getBoxShadow(
        {int num = 1,
        Color color = Colors.black12,
        double? radius,
        BlurStyle blurStyle = BlurStyle.normal,
        double blurRadius = 0.05,
        double spreadRadius = 0.05,
        Offset? offset}) =>
    num.generate((index) => BoxShadow(
        color: color,
        blurStyle: blurStyle,
        blurRadius: radius ?? blurRadius,
        spreadRadius: radius ?? spreadRadius,
        offset: offset ?? const Offset(0, 0)));
