import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

abstract class FlStatefulWidget extends StatefulWidget {
  const FlStatefulWidget({
    super.key,
    this.initState,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.deactivate,
    this.dispose,
  });

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  /// deactivate
  final ValueCallback<BuildContext>? deactivate;

  /// dispose
  final ValueCallback<BuildContext>? dispose;
}

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
