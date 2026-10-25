import 'package:flutter/material.dart';

/// 可配置 [updateShouldNotify] 的 [InheritedWidget]
class FlInheritedWidget extends InheritedWidget {
  const FlInheritedWidget({super.key, required super.child, this.onShouldNotify});

  /// 是否通知依赖方；参数为旧的 [FlInheritedWidget]。
  /// 未设置时默认比较 [child] 是否变化。
  final bool Function(FlInheritedWidget oldWidget)? onShouldNotify;

  @override
  bool updateShouldNotify(covariant FlInheritedWidget oldWidget) =>
      onShouldNotify?.call(oldWidget) ?? oldWidget.child != child;
}
