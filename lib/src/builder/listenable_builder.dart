import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

/// Example:
/// ```
///      ValueListenBuilder<bool>(
///         initial: false,
///         builder: (BuildContext context,
///             ValueNotifier<bool> valueListenable) {
///             /// 赋值即刷新
///             valueListenable.value = true;
///             return (你需要局部刷新的组件)
///          }),
/// ```

class ValueListenBuilder<T> extends FlStatefulWidget {
  const ValueListenBuilder({
    super.key,
    this.initial,
    required this.builder,
    this.onUpdate,
    super.initState,
    super.didChangeDependencies,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });

  final T? initial;

  /// builder
  final ValueTwoCallbackT<Widget, BuildContext, ValueNotifier<T?>> builder;

  /// onUpdate
  final ValueCallback<T?>? onUpdate;

  @override
  State<ValueListenBuilder<T>> createState() => _ValueListenBuilderState<T>();
}

class _ValueListenBuilderState<T> extends FlStatefulWidgetState<ValueListenBuilder<T>> {
  late ValueNotifier<T?> valueNotifier;

  @override
  void initState() {
    widget.initState?.call(context);
    valueNotifier = ValueNotifier<T?>(widget.initial);
    valueNotifier.addListener(listener);
    super.initState();
  }

  @override
  void didUpdateWidget(ValueListenBuilder<T> oldWidget) {
    if (widget.initial != null && widget.initial != valueNotifier.value) {
      valueNotifier.value = widget.initial;
    }
    super.didUpdateWidget(oldWidget);
  }

  void listener() {
    widget.onUpdate?.call(valueNotifier.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, valueNotifier);

  @override
  void dispose() {
    valueNotifier.removeListener(listener);
    valueNotifier.dispose();
    super.dispose();
  }
}

/// Example:
/// ```
///      FlListenableBuilder<TabController>(
///         listenable: TabController(),
///         builder: (BuildContext context,
///             TabController controller) {
///             /// 赋值即刷新
///             return (你需要局部刷新的组件)
///          }),
/// ```
class FlListenableBuilder<T extends Listenable> extends FlStatefulWidget {
  const FlListenableBuilder({
    super.key,
    required this.listenable,
    required this.builder,
    this.onUpdate,
    super.initState,
    super.didChangeDependencies,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });

  final T listenable;

  /// builder
  final ValueTwoCallbackT<Widget, BuildContext, T> builder;

  /// onUpdate
  final ValueCallback<T?>? onUpdate;

  @override
  State<FlListenableBuilder<T>> createState() => _FlListenableBuilderState<T>();
}

class _FlListenableBuilderState<T extends Listenable> extends FlStatefulWidgetState<FlListenableBuilder<T>> {
  @override
  void initState() {
    widget.listenable.addListener(listener);
    super.initState();
  }

  @override
  void didUpdateWidget(FlListenableBuilder<T> oldWidget) {
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(listener);
      widget.listenable.addListener(listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  void listener() {
    widget.onUpdate?.call(widget.listenable);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.listenable);

  @override
  void dispose() {
    widget.listenable.removeListener(listener);
    super.dispose();
  }
}
