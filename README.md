# fl_extended

## 为Flutter添加了一些扩展组件和方法，并简化了路由功能

## 运行[Example](https://wayaer.github.io/fl_extended/example/app/web/index.html#/)查看UI组件

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

- 使用 `ExtendedPopScope` 可自动管理 android 物理返回键 关闭 `loading` 等 `Overlay` 弹窗