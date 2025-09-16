## 1.9.4

* Add `isHarmonyOS`

## 1.9.1

* Add `BigInt` extension
* Add a file `global_key_extension`
* Remove `FlExtended().widgetsBinding` and `FlExtended().schedulerBinding`
* Add `widgetsBinding` 、 `schedulerBinding` 、 `gestureBinding` 、 `paintingBinding` 、
  `semanticsBinding` 、 `rendererBinding` 、 `servicesBinding`
* Add `focusManager` and `primaryFocus`
* `UnifiedButton()` renamed as `FlButton()`
* `ExtendedFutureBuilder()` renamed as `FlFutureBuilder()`
* `ExtendedListenableBuilder()` renamed as `FlListenableBuilder()`
* `ExtendedStatefulBuilder()` renamed as `FlStatefulBuilder()`
* `ExtendedStreamBuilder()` renamed as `FlStreamBuilder()`
* `RText()` renamed as `FlRichText()`
* `BText()` renamed as `FlText()`, `BText.rich()` renamed as `FlText.richText()`, add `FlText.rich()`、
  `FlText.richSpans()`、`FlText.custom()`,
* Add `FlSelectableText()`、`FlSelectableText.rich()`,`FlSelectableText.richText()`、`FlSelectableText.richSpans()`、
  `FlSelectableText.custom()`,
* Add a typedef for FutureOr callback
* `ExtendedOverlay` renamed as `FlOverlay`
* `ExtendedOverlayEntry` renamed as `FlOverlayEntry`,`autoOff` was removed, and `isCached` was added
  with a default value of true
* `ExtendedPopScope` renamed as `FlPopScope`, and removed `onPopInvoked`, and `canHideOverlay` was
  added with a default value of true
* Remove the `removeEntry` from `FlOverlayEntry` using `remove()`
* `closeLoading()` renamed as `hideLoading()`
* `closeToast()` renamed as `hideToast()`
* `closeOverlay()` renamed as `hideOverlay()`
* Add `flexible` and `aspectRatio` to `Universal`. And Removed `enable`
* Add `.flexible` and `.aspectRatio()` to `ExtensionWidget`
* Add `iconAlignment` to `UnifiedButton`
* Modify or add extension methods for String and List<int>, including `base64`, `base64URL`, `UTF8`,
  `ASCII`, `Latin1`, `JSON`, and `URI`
* Fix the `foregroundColor` issue of `ActionDialog`

## 1.6.3

* Add multiple extensions to `num` type, such as `EdgeInsets`,`EdgeInsetsDirectional`,
  `BorderRadius`,`Offset`
* Change the extension method `toClipboard` to `toClipboard()`
* Add `toBoxDecoration()` extension method to `BorderRadius` `BoxBorder` `BoxShadow` `BoxShape`
  `Gradient`

## 1.6.2

* Change the `wrapSpacing` in `Universal` to `spacing` and support `Row`, `Column`, and `Flex`
* Change `IconBox` to `IconLabel`, Change `reverse` to `reverse`
* Add `slice` extension to `List`

## 1.6.0

* Migrate to 3.27

## 1.5.3

* Add `FlLogcat()`

## 1.5.0

* Remove `LoadingProgressIndicator` and `LoadingContent`
* Added `ProgressIndicatorOptions` and `FlProgressIndicator`,
* Change the callback parameter of the builder parameter in LoadingOptions to ProgressIndicator
  Options
* `LoadingStyle` changed to `ProgressIndicatorStyle`

## 1.4.0

* Migrate to 3.24
* `ExtendedPopScope` adds `onPopInvokedWithResult`

## 1.3.1

* Add new extension methods for `List` and `Map`
* Change `[].firstOrNull()` to `[].firstOrNull`
* Change `[].lastOrNull()` to `[].lastOrNull`
* Change `[].withoutFirst()` to `[].withoutFirst`
* Change `[].withoutLast()` to `[].withoutLast`
* Change `[].withoutLast()` to `[].withoutLast`
* `BText.rich` adds multiple parameters

## 1.3.0

* Added `FlInheritedWidget`
* Modify the parameters of `push` `pushReplacement` `pushAndRemoveUntil`

## 1.2.0

* Migrate to 3.22

## 1.1.2

* Add a PreferredSize extension to the Widget
* Removed `BTextStyle`

## 1.1.1

* Removes some parameters for `ModalOptions`、`ModalBoxOptions`、`LoadingOptions` and `ToastOptions`
* `DoubleChooseWindows` changed to `ActionDialog` and changed the parameters
* The `ToastOptions` and `LoadingOptions` parameters have been modified.

## 1.0.0

* Removed `CustomBuilderContext`,use  `ValueCallbackTV<Widget, BuildContext>?`.
* Migrate some components to the [fl_scroll_view](https://pub.dev/packages/fl_scroll_view)
  package,[`ScrollList`,`EasyRefreshed`,`RefreshScrollView`,`SliverListGrid`,
  `SliverPinnedToBoxAdapter`,`FlSliverPersistentHeader`(`ExtendedSliverPersistentHeader`)]
* Migrate some components to the [fl_list_wheel](https://pub.dev/packages/fl_list_wheel)
  package,[`FlListWheel`(`ListWheel`),`FlListWheelState`(`ListWheelState`),`WheelOptions`]
* Migrate some components to the [flutter_waya](https://pub.dev/packages/flutter_waya)
  package,[`TextInputLimitFormatter`,`TextFieldWithDecoratorBox`(`ExtendedTextField`),
  `NumberLimitFormatter`]

## 0.5.1

* `ModalWindowsOptions` Name changed to `ModalBoxOptions`
* `ModalWindows` Name changed to `ModalBox`
* `ModalBoxOptions` removes `addMaterial`, `filter` ,`rect`
* `Toast` and `Loading` are also optimized and adjusted,Global configuration is now perfectly
  supported, and single custom configuration is supported

## 0.4.2

* Fixed `Toast` animation not working,and add `animationDuration`
* `Toast` changes a lot. See example
* Change `modalColor` to `backgroundColor`
* `ModalWindowsOptions` 的 `color` 修改为 `backgroundColor`

## 0.3.2

* Improved generics for popup and route related methods
* Modified `pageRoute` method parameter for enumeration `RoutePushStyle`

## 0.3.1

* Add `ExtendedListenableBuilder()`
* Change some `initialData` and `initialValue` to initial
* `BText` adds `fontVariations`、`useStyleFirst`

## 0.2.0

* Added the `UnifiedButton()`,It is based on several subclasses of `ButtonStyleButton`
* Add the `unifiedButtonCategory` parameter to `Universal()`
* Add some examples
* Add a `marge` extension to `ThemeData`
* Change the name of the `IconLabel` `title` parameter to `label`

## 0.1.0

* Split [flutter_waya](https://pub.dev/packages/flutter_waya)'s extension core into the current
  package
