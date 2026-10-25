import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// 带可选生命周期回调的 [StatefulWidget] 基类。
///
/// 回调与 [State] 生命周期同步执行，可能在 build / finalizeTree 阶段触发；
/// 在回调中更新其他 Widget 的状态时，请延迟到微任务或帧回调中执行。
abstract class FlStatefulWidget extends StatefulWidget {
  const FlStatefulWidget({
    super.key,
    this.initState,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  /// [State.initState] 回调
  final ValueCallback<BuildContext>? initState;

  /// [State.didChangeDependencies] 回调
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// [State.didUpdateWidget] 回调
  final ValueCallback<BuildContext>? didUpdateWidget;

  /// [State.deactivate] 回调
  final ValueCallback<BuildContext>? deactivate;

  /// [State.dispose] 回调
  final ValueCallback<BuildContext>? dispose;
}

/// [FlStatefulWidget] 对应的 [State]，自动转发生命周期回调
abstract class FlStatefulWidgetState<T extends FlStatefulWidget> extends ExtendedState<T> {
  @override
  void initState() {
    widget.initState?.call(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.didChangeDependencies?.call(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    widget.didUpdateWidget?.call(context);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    widget.deactivate?.call(context);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.dispose?.call(context);
    super.dispose();
  }
}
