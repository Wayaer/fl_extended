# fl_extended

为 Flutter 提供常用扩展方法、UI 组件，以及基于全局 `Navigator` 的路由 / Toast / Loading / Popup 快捷能力。

[Web example](https://wayaer.github.io/fl_extended/example/app/web/index.html#/)

## 5.0.0 变更提示

- `sortedBy(Comparator)` 改名为 `sortedWith`；`mapIndexed` 回调顺序改为 `(index, element)`。
- `context.overlay` 统一为 `Overlay.of(context)`，原 `Navigator.overlay` 版本已移除。
- `Iterable.elementAtOrNull` 返回 `T?`；`num.max/min` 返回 `num`，支持 int/double 混合比较。
- `formatDigitPatternEnd` 不再接收无效的 `text` 参数；`uInt8ListFrom32BitList` 改为方法并支持 `byteLength`。
- `num.log` 改名为 `num.ln`（避免与 `log()` 日志方法冲突）；`num.toClipboard()` 现在是方法。
- `FlFutureBuilder` / `FlStreamBuilder` 的 `onNone` / `onWaiting` / `onActive` / `onDone` 回调数据统一为 `T?`。
- 页面销毁时如需取消防抖/节流，请使用 `FlDebouncer` / `FlThrottler` 并调用 `dispose()`。
- `Iterable.pickOne` 返回 `T?`（空集合返回 `null`）；`num.fromMillisecondsSinceEpoch` / `fromMicrosecondsSinceEpoch` 返回非空 `DateTime`，不再按时间戳位数过滤。
- `ActionDialog.actionsMaxHeight` 默认不限制；`FlExtended().navigatorState` 未挂载时抛出 `StateError`，请务必将 `FlExtended().navigatorKey` 交给 `MaterialApp`。
- `CustomStreamBuilder.onDone` 回调数据改为 `T?`；空流完成时传入 `null`，避免非空类型崩溃。
- `FlInheritedWidget.onShouldNotify` 参数改为旧的 `FlInheritedWidget`；未设置时按 `child` 是否变化通知。
- `LogType` 改为 `verbose / debug / info / warn / error / asyncError`，颜色必传；`print` 输出归为 `debug`，Zone 捕获的未处理错误归为 `asyncError`，旧的 `print` / `errorCallback` / `other` 已移除。
- 若与 `package:collection` 同时导入，`firstOrNull` / `lastOrNull` / `elementAtOrNull` / `none` / `forEachIndexed` 同名；请在 import 时 `hide` 其中一侧的扩展，避免歧义。


## 使用前必须接入全局 Key

`push` / `pop`、`showToast` / `showLoading`、`popup*`、自定义 `FlOverlay` 都挂在根 `Navigator` / `ScaffoldMessenger` 上。  
因此需要把 `FlExtended` 的 key 交给 `MaterialApp`（或 `CupertinoApp` / `WidgetsApp`），否则这些能力无法使用——这是设计如此，不是可选优化。

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: FlExtended().navigatorKey,
      scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
      home: const HomePage(),
    );
  }
}
```

也可以使用你自己创建的 Key，再赋给 `FlExtended`：

```dart
final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

FlExtended().navigatorKey = navigatorKey;
FlExtended().scaffoldMessengerKey = scaffoldMessengerKey;
```

可选：在 `main` 里配置全局样式与默认选项。

```dart
final fl = FlExtended();
fl.pushStyle = RoutePushStyle.material;
fl.toastOptions = const ToastOptions.extended(duration: Duration(seconds: 2));
fl.loadingOptions = const LoadingOptions();
```

## 路由

两种等价写法，打开的都是目标页面本身：

```dart
// 顶层方法
push(const DetailPage());
pushReplacement(const DetailPage());
pushAndRemoveUntil(const DetailPage());

// Widget 扩展（推荐语义：页面自己打开自己）
const DetailPage().push();
const DetailPage().pushReplacement();
const DetailPage().pushAndRemoveUntil(predicate: (route) => route.isFirst);

maybePop();
pop();
popUntil((route) => route.isFirst);
```

默认转场样式读取 `FlExtended().pushStyle`，也可在调用时传入 `PageRouteOptions`。

## Overlay：Toast / Loading / 自定义浮层

以下入口等价，按使用场景任选：

```dart
showToast('操作成功', iconStyle: ToastIconStyle.success);
Toast('操作成功').show();
FlOverlay().showToast(Toast('操作成功'));

hideToast();

showLoading();
Loading().show();
hideLoading();

// 自定义 Overlay
final entry = const Text('custom').showOverlay();
entry?.remove();
hideAllOverlay();
```

说明：

- Toast / Loading 同时只展示一个；已有实例时再次 `show` 会直接返回当前实例
- 自定义 Overlay 默认 `isCached: true`，可用 `hide()` / `hideAllOverlay()` 关闭

## FlPopScope（返回键）

有 Toast / Loading / 缓存 Overlay 时，返回键会**先关闭 Overlay**，不会立刻退出页面；Overlay 清空后再返回，才按 `canPop` 处理。

```dart
FlPopScope(
  canPop: true,
  canHideOverlay: true,
  onPopInvokedWithResult: (didPop, result, didHideOverlay) {
    // didHideOverlay == true：本次返回只关了 Overlay
  },
  child: child,
)
```

## Popup

```dart
widget.popupGeneralDialog();
widget.popupModalBottomSheet();
widget.popupCupertinoModal();
```

可配合 `ActionDialog`、`ModalBox` 使用，并在 `FlExtended` 上配置全局 `generalDialogOptions` / `modalBottomSheetOptions` 等。

## 组件与扩展

库内既有 `Fl` 前缀组件（如 `FlText`、`FlButton`），也有无前缀组件（如 `Universal`、`IconLabel`、`Toast`）。  
扩展方法分布在 `String` / `num` / `BuildContext` / `Widget` 等类型上，直接调用即可。

常用示例：

```dart
Universal(
  padding: const EdgeInsets.all(12),
  buttonCategory: FlButtonCategory.elevated,
  onTap: () {},
  child: const FlText('Hello'),
);

CustomFutureBuilder<String>(
  future: () async => 'ok',
  onDone: (context, data, reload) => Text(data),
);

'demo@example.com'.isEmail;
1024.toStorageUnit(); // 1 KB
```

更完整的用法见 `example/`（仅演示，不属于本包 API）。
