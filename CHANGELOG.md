## 5.0.0

* 迁移至 Flutter 3.47 / Dart 3.13
* `FlRegExp` 改为对 `RegExp` 的可用封装
* Overlay：`hideAll` 同步关闭 Toast / Loading；单例按 `mounted` 校验
* `FlPopScope`：有 Overlay 时拦截返回，先 `hideAll` 再允许退出页面
* `Widget.push` / `pushReplacement` / `pushAndRemoveUntil`：改为打开 **自身**，默认样式跟随 `FlExtended().pushStyle`
* 修复 `ToastOptions.copyWith`、`Universal` children 突变、`primaryFocus` 快照、`throttle`、存储单位与字节打包等若干问题
* 修复：`elementAtOrNull` 越界抛 `TypeError`、`num.max/min` 混合 int/double 崩溃、`context.maybePop` 丢失 result、`requestFocus()` 抢占焦点、`TextEditingController` 未设置选区时插入崩溃
* 修复：`FlLogcat.runZone` 自定义 `ZoneSpecification` 递归、`zoneValues` 失效；日志最多保留 500 条
* 修复：`CustomStreamBuilder` 流变化不重新订阅；`Widget.padding` / `statusBarStyle` 重复 `GlobalKey`；`screenshots` 类型崩溃与 `ui.Image` 泄漏
* 修复：`DateTime` 毫秒补零与 `getDaysForRange` 边界；`base64.normalize` 区间；`formatDigitPattern` 多字符 pattern；UTF-8 编解码；存储单位进位；手机号正则逗号
* 修复：`ToastOptions.copyWith` 配置漂移、`ToastContent` 文字颜色；BottomSheet 的 `constraints` / `useSafeArea`；`fromCenter` 改为淡入；Loading 默认拦截背景点击
* 修复：`FlProgressIndicator` 在宽约束下把圆形 / refresh 拉成椭圆并触发 `RefreshProgressIndicator` 正方形断言；显式宽高现在会居中生效
* 优化：`chunked` / `firstOrNull` / `lastOrNull` / `count` 改为单次遍历，`containsAny` 改为惰性短路；节流状态改为实例内；新增可取消的 `FlDebouncer` / `FlThrottler`
* 调整：`sortedBy` → `sortedWith`；`mapIndexed` 参数顺序对齐 `package:collection`；移除 `ExtensionNavigatorStateContext.overlay`；`clipOval` / `clipPath` 移除无效 `borderRadius`；`formatDigitPatternEnd` 移除无效 `text` 参数；`uInt8ListFrom32BitList` 改为方法并支持 `byteLength`
* 调整：`num.log` → `num.ln`（避免与 `log()` 日志方法冲突）；`num.toClipboard` 改为方法；`FlFutureBuilder` / `FlStreamBuilder` 回调数据改为 `T?`
* 代码规范：`analysis_options.yaml` 行宽为 120；`popBack` 现在会等待 pop 完成
* 修复：`ActionDialog.actionsMaxHeight` 不再默认限制为 45；`ModalBox` 高斯模糊增加 `ClipRect`，避免模糊溢出父级
* 修复：`FlExtended().navigatorState` 未挂载时给出明确 `StateError`，替换所有 `currentState!`；`FlOverlay.show` 未挂载时返回 null，显式传入相同 `id` 的缓存项自动替换，未传 `id` 时允许同类组件叠加
* 修复：`FlOverlay.hide()` 按实际插入顺序关闭最顶层，不再固定优先关闭 Toast / Loading
* 修复：`showToast` 返回的 Future 在手动关闭时也会完成，关闭时取消自动隐藏定时器，显式 `duration` 不再被静默延长
* 修复：`FlListenableBinder` 绑定第二个不同 key 时抛出 `ArgumentError`；`keyToString` 检测循环引用；`containsAny` 恢复惰性遍历，避免无限迭代器卡死
* 调整（破坏性）：`pickOne` 返回 `T?`（空集合为 null）；`num.fromMillisecondsSinceEpoch` / `fromMicrosecondsSinceEpoch` 不再按位数过滤并返回非空 `DateTime`；`ActionDialog.actionsMaxHeight` 改为可空
* 调整（破坏性）：`FlInheritedWidget.onShouldNotify` 参数改为旧组件实例，未设置时按 `child` 是否变化通知
* 修复：`uInt8ListFrom32BitList` 校验 `byteLength` 范围；`withBrightness` 在深色模式使用更亮的 shade 200
* 修复：`CustomStreamBuilder` 空流完成时停留在 waiting、向非空 `onDone` 传 null 崩溃（`onDone` 改为 `T?`）；`CustomFutureBuilder` 同步抛错时停留在 waiting
* 修复：`Widget.setPreferredSize` 丢失 `key`；`String.fromHex` 仅移除开头的 `#`；`FlLogcat` 悬浮入口状态异常时未复位
* 调整（破坏性）：`LogType` 改为 `verbose / debug / info / warn / error / asyncError`，颜色改为必传；`print` 输出归为 `debug`，Zone 捕获的未处理错误归为 `asyncError`，移除 `print / errorCallback / other`
* 修复：`FlLogcat` 仅在未处理错误时记录 `asyncError`，不再记录后续已被处理的 Future 错误；`FlOverlay` 自动移除已卸载的缓存条目，挂载前调用 `remove()` 也会真正移除；`FlAnimation` 在 `dispose` 时取消 `delayDuration` 定时器
* 修复：`Universal` 的 `noScrollBehavior` 未生效；`widthFactor` / `heightFactor` 在未设置 `alignment` 时被忽略；修正 `dragStartBehavior` / `stepHeight` 文档
* 代码规范：移除 `lib` / `example` 中剩余的 `var` 声明，统一强类型与 `final`
* Example 全面重做：统一 DemoPage 主题、首页分类与搜索、23 个页面覆盖全部组件与扩展方法，每个示例附带说明、可复制代码与结果；支持白天 / 黑夜切换；新增手机 / 平板尺寸的页面渲染 smoke 测试
* 优化：`FlOverlay.show` / `popupGeneralDialog` / `popupCupertinoModal` 自动提供主题 `DefaultTextStyle`，原始内容不再落入 Flutter 调试兜底样式
* 修复：`FlProgressIndicator` 的 circular 在 `minWidth` 等非正方形约束下被拉成椭圆，现在保持 36×36 或按显式正方形尺寸缩放
* 修复：`ActionDialog` 同时设置 `dividerColor` 与 `actions` 时，竖向分隔线使用无限高度导致 `BoxConstraints forces an infinite height`；操作区现在通过 `IntrinsicHeight` 约束高度
* Example：自定义 Overlay、GeneralDialog、CupertinoModal 内容使用 `Material` 包裹以继承主题文字样式；`showOverlay` 为 null 时不再强制解包
* Example：添加 `cupertino_icons` 依赖，修复 CupertinoNavigationBar 返回图标缺失；Cupertino 页面补充主题 `DefaultTextStyle`，消除文字黄色下划线与兜底大字号
* Example：GeneralDialog / CupertinoModal 原始卡片使用 `Center` 包裹，按内容高度居中显示，不再被全屏约束撑满
* Example：Hero `flightShuttleBuilder` 中的文字改为显式样式，转场时不再显示调试兜底红字
* Example：`Universal` 手势示例按 tap / longPress / drag / pan / scale / forcePress / secondary / tertiary 每个家族分别显示最近触发的手势提示
* Example：`Universal` 页面按参数分组补齐全部 143 个构造参数，并新增超高视口下整页渲染测试
* Example：Navigator 的 Cupertino 路由改为打开 `CupertinoPageScaffold` 页面；iOS 上 MaterialPageRoute 本身也使用 Cupertino 转场，页面样式差异现在可直观看到
