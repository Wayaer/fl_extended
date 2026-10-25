import 'package:flutter/material.dart';

/// 进度指示器样式
enum ProgressIndicatorStyle {
  /// [LinearProgressIndicator]
  linear,

  /// [CircularProgressIndicator]
  circular,

  /// [RefreshProgressIndicator]
  refresh;

  ProgressIndicatorOptions get options => switch (this) {
    ProgressIndicatorStyle.linear => const ProgressIndicatorOptions.linear(),
    ProgressIndicatorStyle.circular => const ProgressIndicatorOptions.circular(),
    ProgressIndicatorStyle.refresh => const ProgressIndicatorOptions.refresh(),
  };
}

/// 进度指示器配置
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

  /// [ProgressIndicator] 进度值
  final double? value;

  /// [ProgressIndicator] 颜色
  final Color? color;

  /// [ProgressIndicator] 动画颜色
  final Animation<Color?>? valueColor;

  /// [ProgressIndicator] 背景色
  final Color? backgroundColor;

  /// 语义标签
  final String? semanticsLabel;

  /// 语义值
  final String? semanticsValue;

  /// [LinearProgressIndicator] 最小高度
  final double? minHeight;

  /// [LinearProgressIndicator] 圆角
  final BorderRadiusGeometry borderRadius;

  /// [CircularProgressIndicator] 描边宽度
  final double strokeWidth;

  /// [CircularProgressIndicator] 描边对齐
  final double strokeAlign;

  /// [CircularProgressIndicator] 线帽样式
  final StrokeCap? strokeCap;

  /// [RefreshProgressIndicator] 海拔
  final double elevation;

  /// [RefreshProgressIndicator] 外边距
  final EdgeInsetsGeometry indicatorMargin;

  /// [RefreshProgressIndicator] 内边距
  final EdgeInsetsGeometry indicatorPadding;

  /// 进度指示器样式
  final ProgressIndicatorStyle style;

  /// [SizedBox] 宽度
  final double? width;

  /// [SizedBox] 高度
  final double? height;

  /// 根据配置构建组件
  FlProgressIndicator get widget => FlProgressIndicator(this);
}

/// 基于 [ProgressIndicatorOptions] 的进度指示器
class FlProgressIndicator extends StatelessWidget {
  const FlProgressIndicator(this.options, {super.key});

  /// 配置
  final ProgressIndicatorOptions options;

  @override
  Widget build(BuildContext context) {
    final Widget current = switch (options.style) {
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

    // CircularProgressIndicator 的尺寸由父约束决定；遇到 minWidth 这类非正方形
    // 约束时会被拉成椭圆。Center 配合宽高因子为 1 既保持正方形，又保留原尺寸。
    if (options.style == ProgressIndicatorStyle.circular) {
      final double? width = options.width;
      final double? height = options.height;
      if (width == null && height == null) {
        return Center(widthFactor: 1, heightFactor: 1, child: current);
      }
      assert(
        width == null || height == null || width == height,
        'CircularProgressIndicator requires width == height (square).',
      );
      return Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SizedBox.square(dimension: width ?? height!, child: current),
      );
    }

    // RefreshProgressIndicator 要求画布为正方形；Center 会把父级 tight 宽度转成 loose，
    // 避免组件被拉成椭圆触发其 paintArrowhead 断言。
    // widthFactor / heightFactor 为 1 时保持原有紧凑尺寸，不会撑满父级。
    if (options.style == ProgressIndicatorStyle.refresh) {
      final double? width = options.width;
      final double? height = options.height;
      if (width == null && height == null) {
        return Center(widthFactor: 1, heightFactor: 1, child: current);
      }
      assert(
        width == null || height == null || width == height,
        'RefreshProgressIndicator requires width == height (square).',
      );
      // 显式尺寸放在 Center 内部，既保持正方形，又真正放大指示器。
      return Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SizedBox.square(dimension: width ?? height!, child: current),
      );
    }

    if (options.width == null && options.height == null) return current;
    return SizedBox(width: options.width, height: options.height, child: current);
  }
}
