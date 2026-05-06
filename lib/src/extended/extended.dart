import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FlExtended {
  FlExtended._();

  static final FlExtended _instance = FlExtended._();

  static FlExtended get instance => _instance;

  factory FlExtended() => _instance;

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

  /// 设置全局 [ModalBottomSheetOptions] 配置
  /// Set the global [ModalBottomSheetOptions] configuration
  ModalBottomSheetOptions modalBottomSheetOptions = const ModalBottomSheetOptions();

  /// 设置全局 [CupertinoModalPopupOptions] 配置
  /// Set the global [CupertinoModalPopupOptions] configuration
  CupertinoModalPopupOptions cupertinoModalPopupOptions = const CupertinoModalPopupOptions();

  /// 设置全局 [GeneralDialogOptions] 配置
  /// Set the global [GeneralDialogOptions] configuration
  GeneralDialogOptions generalDialogOptions = const GeneralDialogOptions();

  bool logCrossLine = true;
}
