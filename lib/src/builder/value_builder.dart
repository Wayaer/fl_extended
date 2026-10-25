import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

typedef ValueBuilderCallback<T> = Widget Function(BuildContext context, T? value, ValueCallback<T> updater);

/// 持有可变值并提供局部刷新的构建器
///
/// 示例：
/// ```
/// ValueBuilder<T>(
///   initial: T,
///   builder: (BuildContext context, T value, ValueCallback<T> update) {
///
///   return (你需要局部刷新的组件)
///
///   }),
///   onUpdate: (value) => print("Value updated: $value"),
/// ),
/// ```
class ValueBuilder<T> extends FlStatefulWidget {
  const ValueBuilder({
    super.key,
    required this.builder,
    this.initial,
    this.onUpdate,
    super.initState,
    super.didChangeDependencies,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });

  /// 初始值
  final T? initial;

  /// 构建子组件；[updater] 用于更新内部值并触发重建
  final ValueBuilderCallback<T> builder;

  /// 值更新时的回调
  final ValueCallback<T?>? onUpdate;

  @override
  State<ValueBuilder<T>> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends FlStatefulWidgetState<ValueBuilder<T>> {
  T? value;

  @override
  void initState() {
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value, updater);

  void updater(T? value) {
    widget.onUpdate?.call(value);
    this.value = value;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ValueBuilder<T> oldWidget) {
    if (widget.initial != null && widget.initial != value) {
      value = widget.initial;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}

/// 基于值变更的构建器，支持同步/异步变更
///
/// 示例：
/// ```
/// ChangedBuilder<bool>(
///   initial: false,
///   onChanged:(bool value){
///   return
///   },
///   onWaitChanged:(bool value)async{
///   return !value;
///   },
///   builder: (bool value, ValueCallback<T> onChanged) {
///
///     return Switch.adaptive(value: value, onChanged: onChanged)
///
///   })
/// ),
/// ```
class ChangedBuilder<T> extends StatelessWidget {
  const ChangedBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.onChanged,
    this.onWaitChanged,
    this.initState,
    this.didUpdateWidget,
    this.didChangeDependencies,
    this.deactivate,
    this.dispose,
  });

  /// 当前值
  final T value;

  /// 构建子组件
  final ValueTwoCallbackT<Widget, T, ValueCallback<T>> builder;

  /// 同步变更回调
  final ValueCallback<T>? onChanged;

  /// 异步变更回调；返回值将作为新值写入
  final ValueCallbackFutureT<T>? onWaitChanged;

  /// [State.initState] 回调
  final ValueCallback<BuildContext>? initState;

  /// [State.didUpdateWidget] 回调
  final ValueCallback<BuildContext>? didUpdateWidget;

  /// [State.didChangeDependencies] 回调
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// [State.deactivate] 回调
  final ValueCallback<BuildContext>? deactivate;

  /// [State.dispose] 回调
  final ValueCallback<BuildContext>? dispose;

  @override
  Widget build(BuildContext context) => ValueBuilder<T>(
    initial: value,
    initState: initState,
    didUpdateWidget: didUpdateWidget,
    didChangeDependencies: didChangeDependencies,
    deactivate: deactivate,
    dispose: dispose,
    builder: (_, T? value, Function update) => builder(value as T, (T v) {
      onChanged?.call(v);
      if (onWaitChanged != null) {
        onWaitChanged!(v).then((result) => update(result));
      } else {
        update(v);
      }
    }),
  );
}
