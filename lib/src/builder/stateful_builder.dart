import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// [StatefulBuilder] 扩展，支持注入生命周期回调。
///
/// 回调与 [State] 生命周期同步执行，可能在 build / finalizeTree 阶段触发；
/// 在回调中更新其他 Widget 的状态时，请延迟到微任务或帧回调中执行。
class FlStatefulBuilder extends StatefulWidget {
  const FlStatefulBuilder({
    super.key,
    required this.builder,
    this.initState,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  /// [State.initState] 回调
  final ValueTwoCallback<BuildContext, StateSetter>? initState;

  /// [State.didChangeDependencies] 回调
  final ValueTwoCallback<BuildContext, StateSetter>? didChangeDependencies;

  /// 构建子组件
  final ValueTwoCallbackT<Widget, BuildContext, StateSetter> builder;

  /// [State.didUpdateWidget] 回调
  final ValueTwoCallback<BuildContext, StateSetter>? didUpdateWidget;

  /// [State.deactivate] 回调
  final ValueCallback<BuildContext>? deactivate;

  /// [State.dispose] 回调
  final ValueCallback<BuildContext>? dispose;

  @override
  State<FlStatefulBuilder> createState() => _FlStatefulBuilderState();
}

class _FlStatefulBuilderState extends ExtendedState<FlStatefulBuilder> {
  @override
  void initState() {
    widget.initState?.call(context, setState);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.didChangeDependencies?.call(context, setState);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void didUpdateWidget(covariant FlStatefulBuilder oldWidget) {
    widget.didUpdateWidget?.call(context, setState);
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
