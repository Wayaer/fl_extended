# fl_extended

## 为Flutter添加了一些扩展组件和方法，并简化了路由功能.

## 运行[Example](https://wayaer.github.io/fl_extended/example/app/web/index.html#/)查看UI

### 初始化 navigatorKey 两种方式

```dart
/// 设置你自己的 navigatorKey
void setGlobalNavigatorKey() {
  FlExtended().scaffoldMessengerKey = scaffoldMessengerKey;
  FlExtended().navigatorKey = navigatorKey;
}

/// 使用自己的 MaterialApp
class _AppState extends ExtendedState<_App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: FlExtended().globalNavigatorKey,
        scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
        title: 'Fl Extended',
        home: _Home());
  }
}

```

- 使用 `ExtendedPopScope` 可自动管理 android 物理返回键 关闭 `loading` 等 `Overlay` 弹

## 路由使用

```dart
void func() {
  /// push
  push(Widget());
  Widget().push();

  /// pushReplacement
  pushReplacement(Widget());
  Widget().pushReplacement();

  /// pushAndRemoveUntil
  pushAndRemoveUntil(Widget());
  Widget().pushAndRemoveUntil();

  /// maybePop
  maybePop();

  /// pop
  pop();

  /// popUntil
  popUntil();
}
```

## overlay

```dart
void func() {


  /// ******** overlay ******** ///
  ExtendedOverlayEntry? overlay = Widget().showOverlay();
  overlay?.remove();

  /// ******** toast ******** ///
  /// 设置全局Toast配置
  FlExtended().toastOptions = ToastOptions.extended(
      animationStyle: FlAnimationStyle.verticalHunting,
      textStyle: const TextStyle(color: Colors.white),
      onModalTap: () {
        log('onModalTap');
      },
      onToastTap: () {
        log('onToastTap');
      },
      foregroundColor: Colors.grey,
      backgroundColor: Colors.red.withOpacity(0.3),
      constraints: const BoxConstraints(maxWidth: 250),
      color: Colors.amber,
      builder: (BuildContext context, ToastContent content) {
        return Universal(mainAxisSize: MainAxisSize.min, children: [
          if (content.iconStyle != null)
            Icon(content.iconStyle!.icon, color: content.color),
          Text(content.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: content.color))
        ]);
      });

  /// toast
  showToast();
  Toast().show();

  /// ******** loading ******** ///
  /// 设置全局Loading配置
  FlExtended().loadingOptions = LoadingOptions(
      backgroundColor: Colors.red.withOpacity(0.1),
      foregroundColor: Colors.yellow,
      elevation: 2,
      padding: const EdgeInsets.all(10),
      builder: (_, LoadingContent content) {
        if (content.style != null) return null;
        return const Padding(
            padding: EdgeInsets.all(10),
            child: BText('全局设置loading', fontSize: 20));
      },
      onLoadingTap: () {
        log('onLoadingTap');
        closeLoading();
      },
      constraints: const BoxConstraints(maxWidth: 250),
      borderRadius: BorderRadius.circular(10),
      onModalTap: () {
        log('onModalTap');
        closeLoading();
      });

  /// loading
  showLoading();

  /// close
  closeLoading();
}

```

## popup

```dart
void func() {
  FlExtended().dialogOptions =
  const DialogOptions(fromStyle: PopupFromStyle.fromTop);

  /// showGeneralDialog
  Widget().popupDialog();

  /// showCupertinoDialog
  Widget().popupCupertinoDialog();

  /// showDialog
  Widget().popupMaterialDialog();

  /// showModalBottomSheet
  Widget().popupBottomSheet();

  /// showCupertinoModalPopup
  Widget().popupCupertinoModal();
}

```