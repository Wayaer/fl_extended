## 1.1.1

* Removes some parameters for `ModalOptions`、`ModalBoxOptions`、`LoadingOptions` and `ToastOptions`
* `DoubleChooseWindows` changed to `ActionDialog` and changed the parameters
* The `ToastOptions` and `LoadingOptions` parameters have been modified.

## 1.0.0

* Removed `CustomBuilderContext`,use  `ValueCallbackTV<Widget, BuildContext>?`.
* Migrate some components to the [fl_scroll_view](https://pub.dev/packages/fl_scroll_view)
  package,[`ScrollList`,`EasyRefreshed`,`RefreshScrollView`,`SliverListGrid`,`SliverPinnedToBoxAdapter`,`FlSliverPersistentHeader`(`ExtendedSliverPersistentHeader`)]
* Migrate some components to the [fl_list_wheel](https://pub.dev/packages/fl_list_wheel)
  package,[`FlListWheel`(`ListWheel`),`FlListWheelState`(`ListWheelState`),`WheelOptions`]
* Migrate some components to the [flutter_waya](https://pub.dev/packages/flutter_waya)
  package,[`TextInputLimitFormatter`,`TextFieldWithDecoratorBox`(`ExtendedTextField`),`NumberLimitFormatter`]

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
* Change the name of the `IconBox` `title` parameter to `label`

## 0.1.0

* Split [flutter_waya](https://pub.dev/packages/flutter_waya)'s extension core into the current
  package
