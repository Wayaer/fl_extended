import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FlInheritedWidget extends InheritedWidget {
  const FlInheritedWidget(
      {super.key, required super.child, this.onShouldNotify});

  final ValueCallbackTV<bool, Widget>? onShouldNotify;

  @override
  bool updateShouldNotify(covariant FlInheritedWidget oldWidget) =>
      onShouldNotify?.call(child) ?? false;
}
