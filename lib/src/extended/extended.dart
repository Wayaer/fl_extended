import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// 全局扩展配置单例
class FlExtended {
  FlExtended._();

  static final FlExtended _instance = FlExtended._();

  static FlExtended get instance => _instance;

  factory FlExtended() => _instance;

  /// 全局 [NavigatorKey]
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 全局 [ScaffoldMessengerKey]
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// 当前 [NavigatorState]；未挂载时给出可读错误，避免 release 下的 null check 崩溃
  NavigatorState get navigatorState {
    final NavigatorState? state = navigatorKey.currentState;
    if (state == null) {
      throw StateError(
        'FlExtended().navigatorKey is not attached to a Navigator. '
        'Pass FlExtended().navigatorKey to MaterialApp / CupertinoApp / WidgetsApp.',
      );
    }
    return state;
  }

  /// 当前 [ScaffoldMessengerState]；未挂载时为 null
  ScaffoldMessengerState? get scaffoldMessengerState => scaffoldMessengerKey.currentState;

  /// 全局路由跳转样式
  RoutePushStyle pushStyle = RoutePushStyle.cupertino;

  /// 全局 [ModalBoxOptions] 配置
  ModalBoxOptions modalOptions = const ModalBoxOptions();

  /// 全局 [LoadingOptions] 配置
  LoadingOptions loadingOptions = const LoadingOptions();

  /// 全局 [ToastOptions] 配置
  ToastOptions toastOptions = const ToastOptions.extended();

  /// 全局 [ModalBottomSheetOptions] 配置
  ModalBottomSheetOptions modalBottomSheetOptions = const ModalBottomSheetOptions();

  /// 全局 [CupertinoModalPopupOptions] 配置
  CupertinoModalPopupOptions cupertinoModalPopupOptions = const CupertinoModalPopupOptions();

  /// 全局 [GeneralDialogOptions] 配置
  GeneralDialogOptions generalDialogOptions = const GeneralDialogOptions();

  /// 日志是否打印分隔线
  bool logCrossLine = true;
}
