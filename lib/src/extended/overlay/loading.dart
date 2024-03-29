part of 'overlay.dart';

/// loading 加载框 关闭 closeLoading();
ExtendedOverlayEntry? showLoading({
  /// 通常使用自定义的
  Widget? custom,

  /// builder
  LoadingBuilder? builder,

  /// 底层模态框配置
  LoadingOptions? options,

  /// 以下为 ProgressIndicator 配置
  /// 官方 ProgressIndicator 底部加个组件
  Widget? extra,
  LoadingProgressIndicator? progressIndicator,
  LoadingStyle? style,
}) =>
    Loading(
            builder: builder,
            custom: custom,
            extra: extra,
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
    this.extra,
    this.progressIndicator,
    this.builder,
    this.custom,
  });

  final LoadingProgressIndicator? progressIndicator;

  /// 官方 ProgressIndicator 底部加个组件
  final Widget? extra;

  /// 以下为官方三个 ProgressIndicator 配置
  final LoadingStyle? style;

  /// LoadingOptions
  final LoadingOptions? options;

  /// builder
  final LoadingBuilder? builder;

  /// custom
  final Widget? custom;

  @override
  Widget build(BuildContext context) {
    final options = FlExtended().loadingOptions.merge(this.options).copyWith(
        extra: extra,
        builder: custom?.toLoadingBuilder ?? builder,
        style: style);
    LoadingContent content = LoadingContent(
        padding: options.padding,
        style: options.style,
        extra: options.extra,
        progressIndicator: progressIndicator);
    Widget current = options.builder?.call(context, content) ?? content;
    current = Universal(
        decoration: options.decoration,
        constraints: options.constraints,
        onTap: options.onLoadingTap,
        child: current);
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
    this.extra,
    this.progressIndicator,
    this.padding,
  });

  final LoadingStyle? style;
  final Widget? extra;
  final LoadingProgressIndicator? progressIndicator;

  /// content padding
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    double strokeWidth = progressIndicator?.strokeWidth ?? 4.0;
    List<Widget> children = [];
    switch (style) {
      case LoadingStyle.circular:
        children.add(CircularProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue));
        break;
      case LoadingStyle.linear:
        children.add(LinearProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue));
        break;
      case LoadingStyle.refresh:
        children.add(RefreshProgressIndicator(
            value: progressIndicator?.value,
            backgroundColor: progressIndicator?.backgroundColor,
            valueColor: progressIndicator?.valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: progressIndicator?.semanticsLabel,
            semanticsValue: progressIndicator?.semanticsValue));
        break;
      case null:
        break;
    }
    if (extra != null) children.add(extra!);
    return Universal(
        padding: padding, mainAxisSize: MainAxisSize.min, children: children);
  }
}

typedef LoadingBuilder = Widget? Function(
    BuildContext context, LoadingContent content);

class LoadingOptions extends ModalOptions {
  const LoadingOptions({
    this.onLoadingTap,
    this.extra,
    this.builder,
    this.style,
    this.constraints,
    this.decoration,
    this.padding,
    super.alignment,
    super.gaussian,
    super.ignoring,
    super.absorbing,
    super.onModalTap,
    super.backgroundColor,
    super.foregroundColor,
    super.elevation,
    super.shadowColor,
    super.textStyle,
    super.borderRadius,
    super.borderOnForeground,
    super.animationDuration,
  });

  final Widget? extra;

  /// Loading 装饰器
  final BoxDecoration? decoration;

  /// Loading constraints
  final BoxConstraints? constraints;

  /// builder
  final LoadingBuilder? builder;

  /// Toast padding
  final EdgeInsetsGeometry? padding;

  /// style
  final LoadingStyle? style;

  /// Loading onTap
  final GestureTapCallback? onLoadingTap;

  LoadingOptions copyWith({
    BoxDecoration? decoration,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    Widget? extra,
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
        decoration: decoration ?? this.decoration,
        constraints: constraints ?? this.constraints,
        onLoadingTap: onLoadingTap ?? this.onLoadingTap,
        builder: builder ?? this.builder,
        extra: extra ?? this.extra,
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
      );

  LoadingOptions merge([LoadingOptions? options]) => copyWith(
        padding: options?.padding,
        onLoadingTap: options?.onLoadingTap,
        decoration: options?.decoration,
        constraints: options?.constraints,
        extra: options?.extra,
        builder: options?.builder,
        style: options?.style,
        backgroundColor: options?.backgroundColor,
        ignoring: options?.ignoring,
        absorbing: options?.absorbing,
        gaussian: options?.gaussian,
        alignment: options?.alignment,
        onModalTap: options?.onModalTap,
        textStyle: options?.textStyle,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        shape: shape,
        borderOnForeground: borderOnForeground,
      );
}
