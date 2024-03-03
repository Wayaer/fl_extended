part of 'overlay.dart';

/// loading 加载框 关闭 closeLoading();
ExtendedOverlayEntry? showLoading({
  /// 通常使用自定义的
  Widget? custom,

  /// 底层模态框配置
  LoadingOptions? options,

  /// 官方 ProgressIndicator 底部加个组件
  Widget? extra,

  /// 以下为官方三个 ProgressIndicator 配置
  double? value,
  Color? backgroundColor,
  Animation<Color>? valueColor,
  double strokeWidth = 4.0,
  String? semanticsLabel,
  String? semanticsValue,
  LoadingStyle? style,
}) =>
    Loading(
            custom: custom,
            extra: extra,
            options: options,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue,
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
    this.strokeWidth = 4.0,
    this.style,
    this.custom,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.backgroundColor,
    this.options,
    this.extra,
  });

  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? backgroundColor;
  final double strokeWidth;

  /// 官方 ProgressIndicator 底部加个组件
  final Widget? extra;

  /// 以下为官方三个 ProgressIndicator 配置
  final LoadingStyle? style;

  /// 通常使用自定义的
  final Widget? custom;

  /// LoadingOptions
  final LoadingOptions? options;

  @override
  Widget build(BuildContext context) {
    final loadingOptions = FlExtended()
        .loadingOptions
        .merge(options)
        .copyWith(custom: custom, style: style);
    Widget current = custom ??
        buildLoadingStyle(style) ??
        loadingOptions.custom ??
        buildLoadingStyle(loadingOptions.style) ??
        const SizedBox();
    if (loadingOptions.onLoadingTap != null) {
      current = current.onTap(loadingOptions.onLoadingTap);
    }
    return ModalWindows(options: loadingOptions, child: current);
  }

  Widget? buildLoadingStyle(LoadingStyle? style) {
    final List<Widget> children = [];
    switch (style) {
      case LoadingStyle.circular:
        children.add(CircularProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingStyle.linear:
        children.add(LinearProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingStyle.refresh:
        children.add(RefreshProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      default:
        return null;
    }
    if (extra != null) children.add(extra!);
    return Universal(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children);
  }
}

class LoadingOptions extends BaseModalOptions {
  const LoadingOptions({
    this.onLoadingTap,
    this.custom,
    this.style = LoadingStyle.circular,
    Color? modalColor,
    super.alignment = Alignment.center,
    super.gaussian = false,
    super.addMaterial = false,
    super.ignoring = false,
    super.absorbing = false,
    super.fuzzyDegree = 4,
    super.blendMode = BlendMode.srcOver,
    super.filter,
    super.onModalTap,
  }) : super(color: modalColor);

  final Widget? custom;

  /// style
  final LoadingStyle style;

  /// Loading onTap
  final GestureTapCallback? onLoadingTap;

  LoadingOptions copyWith({
    GestureTapCallback? onLoadingTap,
    Widget? custom,
    LoadingStyle? style,
    GestureTapCallback? onTap,
    Color? modalColor,
    bool? ignoring,
    bool? absorbing,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    AlignmentGeometry? alignment,
    GestureTapCallback? onModalTap,
  }) =>
      LoadingOptions(
          onLoadingTap: onLoadingTap ?? this.onLoadingTap,
          custom: custom ?? this.custom,
          style: style ?? this.style,
          modalColor: modalColor ?? color,
          ignoring: ignoring ?? this.ignoring,
          absorbing: absorbing ?? this.absorbing,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree,
          alignment: alignment ?? this.alignment,
          onModalTap: onModalTap ?? this.onModalTap);

  LoadingOptions merge([LoadingOptions? options]) => LoadingOptions(
      onLoadingTap: options?.onLoadingTap ?? onLoadingTap,
      custom: options?.custom ?? custom,
      style: options?.style ?? style,
      modalColor: options?.color ?? color,
      ignoring: options?.ignoring ?? ignoring,
      absorbing: options?.absorbing ?? absorbing,
      addMaterial: options?.addMaterial ?? addMaterial,
      filter: options?.filter ?? filter,
      gaussian: options?.gaussian ?? gaussian,
      fuzzyDegree: options?.fuzzyDegree ?? fuzzyDegree,
      alignment: options?.alignment ?? alignment,
      onModalTap: options?.onModalTap ?? onModalTap);
}
