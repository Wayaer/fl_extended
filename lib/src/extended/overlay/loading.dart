part of 'overlay.dart';

/// loading 加载框 关闭 closeLoading();
ExtendedOverlayEntry? showLoading({
  /// builder
  LoadingBuilder? builder,

  /// 底层模态框配置
  LoadingOptions? options,

  /// 以下为 ProgressIndicator 配置
  LoadingProgressIndicator? progressIndicator,
  LoadingStyle? style,
}) =>
    Loading(
            builder: builder,
            options: options,
            progressIndicator: progressIndicator,
            style: style)
        .show();

bool closeLoading() => ExtendedOverlay().closeLoading();

enum LoadingStyle {
  /// 圆圈
  circular,

  /// 横条
  linear,

  /// 不常用 下拉刷新圆圈
  refresh,
}

extension ExtensionLoading on Loading {
  ExtendedOverlayEntry? show() => ExtendedOverlay().showLoading(this);
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    this.style,
    this.options,
    this.progressIndicator,
    this.builder,
  });

  final LoadingProgressIndicator? progressIndicator;

  /// 以下为官方三个 ProgressIndicator 配置
  final LoadingStyle? style;

  /// LoadingOptions
  final LoadingOptions? options;

  /// builder
  final LoadingBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final options = FlExtended()
        .loadingOptions
        .merge(this.options)
        .copyWith(builder: builder, style: style);
    LoadingContent content = LoadingContent(
        style: options.style, progressIndicator: progressIndicator);
    Widget current = options.builder?.call(context, content) ?? content;
    current = Universal(onTap: options.onLoadingTap, child: current);
    return ModalBox(options: options, child: current);
  }
}

class LoadingProgressIndicator {
  LoadingProgressIndicator(
      {this.value,
      this.valueColor,
      this.semanticsLabel,
      this.semanticsValue,
      this.backgroundColor,
      this.strokeWidth});

  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? backgroundColor;
  final double? strokeWidth;
}

class LoadingContent extends StatelessWidget {
  const LoadingContent({
    super.key,
    this.style,
    this.progressIndicator,
  });

  final LoadingStyle? style;
  final LoadingProgressIndicator? progressIndicator;

  @override
  Widget build(BuildContext context) {
    double strokeWidth = progressIndicator?.strokeWidth ?? 4.0;
    switch (style ?? LoadingStyle.circular) {
      case LoadingStyle.circular:
        return CircularProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue);
      case LoadingStyle.linear:
        return LinearProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue);
      case LoadingStyle.refresh:
        return RefreshProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue);
    }
  }
}

typedef LoadingBuilder = Widget? Function(
    BuildContext context, LoadingContent content);

class LoadingOptions extends ModalOptions {
  const LoadingOptions({
    this.onLoadingTap,
    this.builder,
    this.style,
    super.alignment = Alignment.center,
    super.gaussian,
    super.ignoring,
    super.absorbing,
    super.onModalTap,
    super.backgroundColor,
    super.textStyle,
    super.foregroundColor,
    super.borderRadius,
    super.borderOnForeground,
    super.shape,
    super.elevation,
    super.shadowColor,
    super.constraints,
    super.padding,
  });

  /// builder
  final LoadingBuilder? builder;

  /// style
  final LoadingStyle? style;

  /// Loading onTap
  final GestureTapCallback? onLoadingTap;

  LoadingOptions copyWith({
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    LoadingBuilder? builder,
    LoadingStyle? style,
    TextStyle? textStyle,
    GestureTapCallback? onLoadingTap,
    bool? ignoring,
    bool? absorbing,
    double? gaussian,
    AlignmentGeometry? alignment,
    GestureTapCallback? onModalTap,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    Color? shadowColor,
    ShapeBorder? shape,
    bool? borderOnForeground,
    BorderRadiusGeometry? borderRadius,
  }) =>
      LoadingOptions(
        padding: padding ?? this.padding,
        constraints: constraints ?? this.constraints,
        onLoadingTap: onLoadingTap ?? this.onLoadingTap,
        builder: builder ?? this.builder,
        style: style ?? this.style,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        ignoring: ignoring ?? this.ignoring,
        absorbing: absorbing ?? this.absorbing,
        gaussian: gaussian ?? this.gaussian,
        alignment: alignment ?? this.alignment,
        onModalTap: onModalTap ?? this.onModalTap,
        textStyle: textStyle ?? this.textStyle,
        elevation: elevation ?? this.elevation,
        shadowColor: shadowColor ?? this.shadowColor,
        borderRadius: borderRadius ?? this.borderRadius,
        borderOnForeground: borderOnForeground ?? this.borderOnForeground,
        shape: shape ?? this.shape,
      );

  LoadingOptions merge([LoadingOptions? options]) => copyWith(
        padding: options?.padding,
        onLoadingTap: options?.onLoadingTap,
        constraints: options?.constraints,
        builder: options?.builder,
        style: options?.style,
        backgroundColor: options?.backgroundColor,
        foregroundColor: options?.foregroundColor,
        ignoring: options?.ignoring,
        absorbing: options?.absorbing,
        gaussian: options?.gaussian,
        alignment: options?.alignment,
        onModalTap: options?.onModalTap,
        textStyle: options?.textStyle,
        elevation: options?.elevation,
        shadowColor: options?.shadowColor,
        borderRadius: options?.borderRadius,
        shape: options?.shape,
        borderOnForeground: options?.borderOnForeground,
      );
}
