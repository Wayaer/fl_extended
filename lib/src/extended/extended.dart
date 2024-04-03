import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fl_extended/fl_extended.dart';

class FlExtended {
  factory FlExtended() => _singleton ??= FlExtended._();

  FlExtended._();

  static FlExtended? _singleton;

  WidgetsBinding widgetsBinding = WidgetsBinding.instance;

  SchedulerBinding schedulerBinding = SchedulerBinding.instance;

  /// 设置全局 [NavigatorKey]
  /// Set the global [NavigatorKey]
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 设置全局 [ScaffoldMessengerKey]
  /// Set the global [ScaffoldMessengerKey]
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// 设置全局路由跳转样式
  /// Set the global route push style
  RoutePushStyle pushStyle = RoutePushStyle.cupertino;

  /// 设置全局 ModalBoxOptions 配置
  /// Set the global [ModalBoxOptions] 配置
  ModalBoxOptions modalOptions = const ModalBoxOptions();

  /// 设置全局 [LoadingOptions] 配置
  /// Set the global [LoadingOptions] configuration
  LoadingOptions loadingOptions =
      const LoadingOptions(style: LoadingStyle.circular);

  /// 设置全局 [ToastOptions] 配置
  /// Set the global [ToastOptions] configuration
  ToastOptions toastOptions = const ToastOptions.extended();

  /// 设置全局 [BottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  BottomSheetOptions bottomSheetOptions = const BottomSheetOptions();

  /// 设置全局 [CupertinoBottomSheet] 配置
  /// Set the global [BottomSheet] configuration
  CupertinoModalPopupOptions cupertinoModalPopupOptions =
      const CupertinoModalPopupOptions();

  /// 设置全局 [DialogOptions] 配置
  /// Set the global [DialogOptions] configuration
  DialogOptions dialogOptions = const DialogOptions();

  bool logCrossLine = true;
}

void addPostFrameCallback(FrameCallback duration) =>
    FlExtended().widgetsBinding.addPostFrameCallback(duration);

void addObserver(WidgetsBindingObserver observer) =>
    FlExtended().widgetsBinding.addObserver(observer);

void removeObserver(WidgetsBindingObserver observer) =>
    FlExtended().widgetsBinding.removeObserver(observer);

void addPersistentFrameCallback(FrameCallback duration) =>
    FlExtended().widgetsBinding.addPersistentFrameCallback(duration);

void addTimingsCallback(TimingsCallback callback) =>
    FlExtended().widgetsBinding.addTimingsCallback(callback);
