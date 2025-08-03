import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// StatefulBuilder 扩展
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

  /// initState
  final ValueTwoCallback<BuildContext, StateSetter>? initState;

  /// didChangeDependencies
  final ValueTwoCallback<BuildContext, StateSetter>? didChangeDependencies;

  /// builder
  final ValueTwoCallbackT<Widget, BuildContext, StateSetter> builder;

  /// didUpdateWidget
  final ValueTwoCallback<BuildContext, StateSetter>? didUpdateWidget;

  /// deactivate
  final ValueCallback<BuildContext>? deactivate;

  /// dispose
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
