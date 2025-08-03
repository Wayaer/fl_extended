part of 'overlay.dart';

typedef LoadingBuilder = Widget? Function(BuildContext context, ProgressIndicatorOptions? progressIndicator);

class LoadingOptions extends ModalOptions {
  const LoadingOptions({
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
    super.safeLTRB,
    super.resizeToAvoidBottomInset,
    super.insetAnimationCurve,
    super.insetAnimationDuration,
    this.onLoadingTap,
    this.builder,
    this.progressIndicator,
    this.padding,
  });

  /// builder
  final LoadingBuilder? builder;

  /// progressIndicator
  final ProgressIndicatorOptions? progressIndicator;

  /// Loading onTap
  final GestureTapCallback? onLoadingTap;

  /// padding
  final EdgeInsetsGeometry? padding;

  LoadingOptions copyWith({
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    LoadingBuilder? builder,
    ProgressIndicatorOptions? progressIndicator,
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
    bool? safeLTRB,
    bool? resizeToAvoidBottomInset,
    Duration? insetAnimationDuration,
    Curve? insetAnimationCurve,
  }) => LoadingOptions(
    padding: padding ?? this.padding,
    constraints: constraints ?? this.constraints,
    onLoadingTap: onLoadingTap ?? this.onLoadingTap,
    builder: builder ?? this.builder,
    progressIndicator: progressIndicator ?? this.progressIndicator,
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
    safeLTRB: safeLTRB ?? this.safeLTRB,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    insetAnimationDuration: insetAnimationDuration ?? this.insetAnimationDuration,
    insetAnimationCurve: insetAnimationCurve ?? this.insetAnimationCurve,
  );

  LoadingOptions merge([LoadingOptions? options]) => copyWith(
    padding: options?.padding,
    onLoadingTap: options?.onLoadingTap,
    constraints: options?.constraints,
    builder: options?.builder,
    progressIndicator: options?.progressIndicator,
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
    safeLTRB: options?.safeLTRB,
    resizeToAvoidBottomInset: options?.resizeToAvoidBottomInset,
    insetAnimationDuration: options?.insetAnimationDuration,
    insetAnimationCurve: options?.insetAnimationCurve,
  );
}

/// loading 加载框 关闭 hideLoading();
FlOverlayEntry? showLoading({
  /// builder
  LoadingBuilder? builder,

  /// 底层模态框配置
  LoadingOptions? options,
}) => Loading(builder: builder, options: options).show();

void hideLoading() => FlOverlay().hideLoading();

extension ExtensionLoading on Loading {
  FlOverlayEntry? show() => FlOverlay().showLoading(this);
}

class Loading extends StatelessWidget {
  const Loading({super.key, this.options, this.builder});

  /// LoadingOptions
  final LoadingOptions? options;

  /// builder
  final LoadingBuilder? builder;

  /// use global loading
  final bool useGlobal = true;

  @override
  Widget build(BuildContext context) {
    final options = FlExtended().loadingOptions.merge(this.options).copyWith(builder: builder);
    Widget current = FlProgressIndicator(options.progressIndicator ?? ProgressIndicatorStyle.circular.options);
    current = options.builder?.call(context, options.progressIndicator) ?? current;
    current = Universal(onTap: options.onLoadingTap, padding: options.padding, child: current);
    return ModalBox(options: options, child: current);
  }
}
