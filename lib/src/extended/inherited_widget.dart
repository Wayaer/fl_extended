import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class InheritedUpdateShouldNotify extends InheritedWidget {
  const InheritedUpdateShouldNotify(
      {super.key, required super.child, this.onShouldNotify});

  /// 通知依赖的子组件是否更新
  final ValueCallbackTV<bool, Widget>? onShouldNotify;

  @override
  bool updateShouldNotify(covariant InheritedUpdateShouldNotify oldWidget) =>
      onShouldNotify?.call(child) ?? false;
}
