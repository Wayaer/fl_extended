import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

typedef ValueBuilderCallback<T> =
    Widget Function(BuildContext context, T? value, ValueCallback<T> updater);

/// Example:
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
class ValueBuilder<T> extends ExtendedStatefulWidget {
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

  final T? initial;

  /// builder
  final ValueBuilderCallback<T> builder;

  /// onUpdate
  final ValueCallback<T?>? onUpdate;

  @override
  State<ValueBuilder<T>> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T>
    extends ExtendedStatefulWidgetState<ValueBuilder<T>> {
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

/// Example:
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

  final T value;

  final ValueTwoCallbackT<Widget, T, ValueCallback<T>> builder;

  final ValueCallback<T>? onChanged;

  final ValueCallbackFutureT<T>? onWaitChanged;

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// deactivate
  final ValueCallback<BuildContext>? deactivate;

  /// dispose
  final ValueCallback<BuildContext>? dispose;

  @override
  Widget build(BuildContext context) => ValueBuilder<T>(
    initial: value,
    initState: initState,
    didUpdateWidget: didUpdateWidget,
    didChangeDependencies: didChangeDependencies,
    deactivate: deactivate,
    dispose: dispose,
    builder:
        (_, T? value, Function update) => builder(value as T, (T v) {
          onChanged?.call(v);
          if (onWaitChanged != null) {
            onWaitChanged!(v).then((result) => update(result));
          } else {
            update(v);
          }
        }),
  );
}
