import 'package:flutter/material.dart';

enum ProgressIndicatorStyle {
  /// [LinearProgressIndicator]
  linear,

  /// [CircularProgressIndicator]
  circular,

  /// [RefreshProgressIndicator]
  refresh;

  ProgressIndicatorOptions get options => switch (this) {
    ProgressIndicatorStyle.linear => const ProgressIndicatorOptions.linear(),
    ProgressIndicatorStyle.circular =>
      const ProgressIndicatorOptions.circular(),
    ProgressIndicatorStyle.refresh => const ProgressIndicatorOptions.refresh(),
  };
}

class ProgressIndicatorOptions {
  const ProgressIndicatorOptions({
    this.width,
    this.height,
    required this.style,
    this.value,
    this.color,
    this.valueColor,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,

    /// [ProgressIndicatorOptions.linear]
    this.minHeight,
    this.borderRadius = BorderRadius.zero,

    /// [ProgressIndicatorOptions.circular]
    this.strokeWidth = 4,
    this.strokeAlign = 0,
    this.strokeCap,

    /// [ProgressIndicatorOptions.refresh]
    this.elevation = 2.0,
    this.indicatorMargin = const EdgeInsets.all(4.0),
    this.indicatorPadding = const EdgeInsets.all(12.0),
  });

  const ProgressIndicatorOptions.linear({
    this.width,
    this.height,
    this.value,
    this.color,
    this.valueColor,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.minHeight,
    this.borderRadius = BorderRadius.zero,
  }) : style = ProgressIndicatorStyle.linear,
       strokeWidth = 4,
       strokeAlign = 0,
       strokeCap = null,
       elevation = 2.0,
       indicatorMargin = const EdgeInsets.all(4.0),
       indicatorPadding = const EdgeInsets.all(12.0);

  const ProgressIndicatorOptions.circular({
    this.width,
    this.height,
    this.value,
    this.color,
    this.valueColor,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 4,
    this.strokeAlign = 0,
    this.strokeCap,
  }) : style = ProgressIndicatorStyle.circular,
       minHeight = null,
       borderRadius = BorderRadius.zero,
       elevation = 2.0,
       indicatorMargin = const EdgeInsets.all(4.0),
       indicatorPadding = const EdgeInsets.all(12.0);

  const ProgressIndicatorOptions.refresh({
    this.width,
    this.height,
    this.value,
    this.color,
    this.valueColor,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 4,
    this.strokeAlign = 0,
    this.strokeCap,
    this.elevation = 2.0,
    this.indicatorMargin = const EdgeInsets.all(4.0),
    this.indicatorPadding = const EdgeInsets.all(12.0),
  }) : style = ProgressIndicatorStyle.refresh,
       minHeight = null,
       borderRadius = BorderRadius.zero;

  /// [ProgressIndicator]
  final double? value;
  final Color? color;
  final Animation<Color?>? valueColor;
  final Color? backgroundColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  /// [LinearProgressIndicator]
  final double? minHeight;
  final BorderRadiusGeometry borderRadius;

  /// [CircularProgressIndicator]
  final double strokeWidth;
  final double strokeAlign;
  final StrokeCap? strokeCap;

  /// [RefreshProgressIndicator]
  final double elevation;
  final EdgeInsetsGeometry indicatorMargin;
  final EdgeInsetsGeometry indicatorPadding;

  /// [ProgressIndicatorStyle]
  final ProgressIndicatorStyle style;

  /// [SizedBox]
  final double? width;
  final double? height;

  FlProgressIndicator get widget => FlProgressIndicator(this);
}

/// ProgressIndicatorOptions 实现
class FlProgressIndicator extends StatelessWidget {
  const FlProgressIndicator(this.options, {super.key});

  final ProgressIndicatorOptions options;

  @override
  Widget build(BuildContext context) {
    Widget current = switch (options.style) {
      ProgressIndicatorStyle.linear => LinearProgressIndicator(
        value: options.value,
        backgroundColor: options.backgroundColor,
        color: options.color,
        valueColor: options.valueColor,
        minHeight: options.minHeight,
        borderRadius: options.borderRadius,
        semanticsLabel: options.semanticsLabel,
        semanticsValue: options.semanticsValue,
      ),
      ProgressIndicatorStyle.circular => CircularProgressIndicator(
        value: options.value,
        backgroundColor: options.backgroundColor,
        color: options.color,
        valueColor: options.valueColor,
        strokeWidth: options.strokeWidth,
        strokeAlign: options.strokeAlign,
        semanticsLabel: options.semanticsLabel,
        semanticsValue: options.semanticsValue,
        strokeCap: options.strokeCap,
      ),
      ProgressIndicatorStyle.refresh => RefreshProgressIndicator(
        value: options.value,
        backgroundColor: options.backgroundColor,
        color: options.color,
        valueColor: options.valueColor,
        strokeWidth: options.strokeWidth,
        strokeAlign: options.strokeAlign,
        semanticsLabel: options.semanticsLabel,
        semanticsValue: options.semanticsValue,
        strokeCap: options.strokeCap,
        elevation: options.elevation,
        indicatorMargin: options.indicatorMargin,
        indicatorPadding: options.indicatorPadding,
      ),
    };

    if (options.width == null && options.height == null) return current;
    return SizedBox(
      width: options.width,
      height: options.height,
      child: current,
    );
  }
}
