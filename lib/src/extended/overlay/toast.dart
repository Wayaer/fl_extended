part of 'overlay.dart';

extension ExtensionToast on Toast {
  Future<ExtendedOverlayEntry?> show() => ExtendedOverlay().showToast(this);
}

class Toast extends StatelessWidget {
  const Toast(
    this.text, {
    super.key,
    this.iconStyle,
    this.textStyle,
    this.duration,
    this.animationDuration,
    this.animationStyle,
    this.decoration,
    this.onToastTap,
    this.color,
    this.direction,
    this.alignment,
    this.builder,
    this.options,
  });

  /// 文字
  final String text;

  /// 动画样式
  final FlAnimationStyle? animationStyle;

  /// 动画执行时间
  final Duration? animationDuration;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// icon 样式 不传 仅显示文字
  final ToastIconStyle? iconStyle;

  /// Toast显示时间
  final Duration? duration;

  /// Toast 装饰器 会替换 [backgroundColor]
  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 字体颜色和icon颜色
  final Color? color;

  /// Toast icon direction
  final Axis? direction;

  /// 重新 build  text icon
  final ToastBuilder? builder;

  /// alignment
  final AlignmentGeometry? alignment;

  /// ToastOptions
  final ToastOptions? options;

  @override
  Widget build(BuildContext context) {
    final options = FlExtended().toastOptions.merge(this.options).copyWith(
        duration: duration,
        textStyle: textStyle,
        animationDuration: animationDuration,
        animationStyle: animationStyle,
        decoration: decoration,
        onToastTap: onToastTap,
        color: color,
        direction: direction,
        alignment: alignment,
        builder: builder);
    ToastContent content = ToastContent(
        text: text,
        iconStyle: iconStyle,
        color: options.color,
        padding: options.padding,
        textStyle: options.textStyle,
        direction: options.direction);
    Widget current = options.builder?.call(context, content) ?? content;
    current = Universal(
        decoration: options.decoration,
        constraints: options.constraints,
        onTap: options.onToastTap,
        child: current);
    return ModalBox(
        options: options,
        materialBuilder: options.animationStyle == null
            ? null
            : (_) => FlAnimation(
                style: options.animationStyle!,
                animationDuration:
                    options.animationDuration ?? kThemeChangeDuration,
                stayDuration: options.duration
                    .subtract(kFlAnimationDuration, kFlAnimationDuration),
                child: _),
        child: current);
  }
}

/// toast 文字和icon
class ToastContent extends StatelessWidget {
  const ToastContent({
    super.key,
    required this.text,
    this.color,
    this.iconStyle,
    this.direction,
    this.spacing = 6,
    this.size = 18,
    this.maxLines = 5,
    this.textStyle,
    this.padding,
  });

  /// text
  final String text;

  /// text icon color
  final Color? color;

  /// icon style
  final ToastIconStyle? iconStyle;

  /// icon text direction
  final Axis? direction;

  /// spacing
  final double spacing;

  /// icon size
  final double size;

  /// text maxLines
  final int maxLines;

  /// text fontSize
  final TextStyle? textStyle;

  /// content padding
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget current = Text(text,
        textAlign: TextAlign.center, style: textStyle, maxLines: maxLines);
    if (iconStyle != null) {
      current = IconBox(
          icon: iconStyle!.icon,
          direction: direction ?? Axis.vertical,
          spacing: spacing,
          size: size,
          color: color,
          label: current);
    }
    return padding != null
        ? Padding(padding: padding!, child: current)
        : current;
  }
}

/// Toast类型
/// 如果使用custom  请设置 [customIcon]
enum ToastIconStyle {
  /// success
  success(FlExtendedIcons.success),

  /// fail
  fail(FlExtendedIcons.fail),

  /// info
  info(FlExtendedIcons.info),

  /// warning
  warning(FlExtendedIcons.warning),

  /// smile
  smile(FlExtendedIcons.smile);

  const ToastIconStyle(this.icon);

  final IconData icon;
}

/// Toast
/// 关闭 closeToast();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<ExtendedOverlayEntry?> showToast(
  String message, {
  /// icon 样式 不传 仅显示文字
  ToastIconStyle? iconStyle,

  /// 动画样式
  FlAnimationStyle? animationStyle,

  /// 动画执行时间
  Duration? animationDuration,

  /// 显示文字样式
  TextStyle? textStyle,

  /// Toast显示时间
  Duration? duration,

  /// Toast 装饰器 会替换 [backgroundColor]
  BoxDecoration? decoration,

  /// Toast onTap
  GestureTapCallback? onToastTap,

  /// 重新 build  text icon
  ToastBuilder? builder,

  /// ToastOptions
  ToastOptions? options,
}) =>
    Toast(
      message,
      animationStyle: animationStyle,
      animationDuration: animationDuration,
      textStyle: textStyle,
      iconStyle: iconStyle,
      builder: builder,
      onToastTap: onToastTap,
      decoration: decoration,
      duration: duration,
      options: options,
    ).show();

bool closeToast() => ExtendedOverlay().closeToast();

typedef ToastBuilder = Widget? Function(
    BuildContext context, ToastContent content);

class ToastOptions extends ModalOptions {
  const ToastOptions({
    this.color,
    this.decoration,
    this.onToastTap,
    this.duration = const Duration(milliseconds: 1500),
    this.animationStyle,
    this.direction,
    this.builder,
    this.constraints,
    this.padding,
    super.backgroundColor,
    super.foregroundColor,
    super.alignment,
    super.onModalTap,
    super.gaussian,
    super.ignoring,
    super.absorbing,
    super.elevation,
    super.shadowColor,
    super.textStyle,
    super.borderRadius,
    super.borderOnForeground,
    super.animationDuration,
  });

  const ToastOptions.extended({
    this.color = const Color(0xFFFFFFFF),
    this.decoration,
    this.onToastTap,
    this.duration = const Duration(milliseconds: 1500),
    this.animationStyle,
    this.direction = Axis.vertical,
    this.builder,
    this.constraints,
    this.padding = const EdgeInsets.all(10),
    super.animationDuration = const Duration(milliseconds: 300),
    super.backgroundColor,
    super.foregroundColor = const Color(0xFF000000),
    super.alignment,
    super.onModalTap,
    super.gaussian,
    super.ignoring,
    super.absorbing,
    super.elevation,
    super.shadowColor,
    super.textStyle = const TextStyle(color: Color(0xFFFFFFFF)),
    super.borderRadius = const BorderRadius.all(Radius.circular(4)),
    super.shape,
    super.borderOnForeground,
  });

  /// 动画样式
  final FlAnimationStyle? animationStyle;

  /// Toast显示时间
  final Duration duration;

  /// Toast 装饰器
  final BoxDecoration? decoration;

  /// Toast constraints
  final BoxConstraints? constraints;

  /// Toast padding
  final EdgeInsetsGeometry? padding;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 字体颜色和icon颜色
  final Color? color;

  /// Toast icon direction
  final Axis? direction;

  /// builder
  final ToastBuilder? builder;

  ToastOptions copyWith({
    BoxDecoration? decoration,
    BoxConstraints? constraints,
    GestureTapCallback? onToastTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? color,
    Axis? direction,
    ToastBuilder? builder,
    GestureTapCallback? onModalTap,
    Color? backgroundColor,
    Color? foregroundColor,
    double? gaussian,
    bool? ignoring,
    bool? absorbing,
    AlignmentGeometry? alignment,
    FlAnimationStyle? animationStyle,
    Duration? animationDuration,
    double? elevation,
    Color? shadowColor,
    ShapeBorder? shape,
    bool? borderOnForeground,
    BorderRadiusGeometry? borderRadius,
  }) =>
      ToastOptions.extended(
        color: color ?? this.color,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        animationDuration: animationDuration ?? this.animationDuration,
        animationStyle: animationStyle ?? this.animationStyle,
        decoration: decoration ?? this.decoration,
        constraints: constraints ?? this.constraints,
        onToastTap: onToastTap ?? this.onToastTap,
        textStyle: textStyle ?? this.textStyle,
        duration: duration ?? this.duration,
        builder: builder ?? this.builder,
        direction: direction ?? this.direction,
        ignoring: ignoring ?? this.ignoring,
        alignment: alignment ?? this.alignment,
        onModalTap: onModalTap ?? this.onModalTap,
        absorbing: ignoring ?? this.absorbing,
        gaussian: gaussian ?? this.gaussian,
        elevation: elevation ?? this.elevation,
        shadowColor: shadowColor ?? this.shadowColor,
        borderRadius: borderRadius ?? this.borderRadius,
        shape: shape ?? this.shape,
        borderOnForeground: borderOnForeground ?? this.borderOnForeground,
      );

  ToastOptions merge([ToastOptions? options]) => copyWith(
        animationDuration: options?.animationDuration,
        animationStyle: options?.animationStyle,
        decoration: options?.decoration,
        constraints: options?.constraints,
        onToastTap: options?.onToastTap,
        textStyle: options?.textStyle,
        duration: options?.duration,
        color: options?.color,
        builder: options?.builder,
        direction: options?.direction,
        alignment: options?.alignment,
        onModalTap: options?.onModalTap,
        backgroundColor: options?.color,
        ignoring: options?.ignoring,
        absorbing: options?.absorbing,
        gaussian: options?.gaussian,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        shape: shape,
        borderOnForeground: borderOnForeground,
      );
}
