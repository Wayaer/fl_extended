import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FlExtended {
  factory FlExtended() => _singleton ??= FlExtended._();

  FlExtended._();

  static FlExtended? _singleton;

  /// 设置全局 [NavigatorKey]
  /// Set the global [NavigatorKey]
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 设置全局 [ScaffoldMessengerKey]
  /// Set the global [ScaffoldMessengerKey]
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// 设置全局路由跳转样式
  /// Set the global route push style
  RoutePushStyle pushStyle = RoutePushStyle.cupertino;

  /// 设置全局 ModalBoxOptions 配置
  /// Set the global [ModalBoxOptions] 配置
  ModalBoxOptions modalOptions = const ModalBoxOptions();

  /// 设置全局 [LoadingOptions] 配置
  /// Set the global [LoadingOptions] configuration
  LoadingOptions loadingOptions = const LoadingOptions();

  /// 设置全局 [ToastOptions] 配置
  /// Set the global [ToastOptions] configuration
  ToastOptions toastOptions = const ToastOptions.extended();

  /// 设置全局 [BottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  BottomSheetOptions bottomSheetOptions = const BottomSheetOptions();

  /// 设置全局 [CupertinoBottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  CupertinoModalPopupOptions cupertinoModalPopupOptions = const CupertinoModalPopupOptions();

  /// 设置全局 [DialogOptions] 配置
  /// Set the global [DialogOptions] configuration
  DialogOptions dialogOptions = const DialogOptions();

  bool logCrossLine = true;
}
