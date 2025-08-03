part of 'overlay.dart';

extension ExtensionToast on Toast {
  Future<FlOverlayEntry?> show() => FlOverlay().showToast(this);
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
    final options = FlExtended().toastOptions
        .merge(this.options)
        .copyWith(
          duration: duration,
          textStyle: textStyle,
          animationDuration: animationDuration,
          animationStyle: animationStyle,
          onToastTap: onToastTap,
          color: color,
          direction: direction,
          alignment: alignment,
          builder: builder,
        );
    ToastContent content = ToastContent(
      text: text,
      iconStyle: iconStyle,
      color: options.color,
      textStyle: options.textStyle,
      direction: options.direction,
    );
    Widget current = options.builder?.call(context, content) ?? content;
    current = Universal(onTap: options.onToastTap, padding: options.padding, child: current);
    return ModalBox(
      options: options,
      materialBuilder:
          options.animationStyle == null
              ? null
              : (Widget child) => FlAnimation(
                style: options.animationStyle!,
                animationDuration: options.animationDuration ?? kThemeChangeDuration,
                stayDuration: options.duration.subtract(kFlAnimationDuration, kFlAnimationDuration),
                child: child,
              ),
      child: current,
    );
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

  @override
  Widget build(BuildContext context) {
    Widget current = Text(text, textAlign: TextAlign.center, style: textStyle, maxLines: maxLines);
    if (iconStyle != null) {
      current = Flex(
        direction: direction ?? Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconStyle!.icon, size: size, color: color),
          SizedBox(width: direction == Axis.horizontal ? spacing : 0, height: direction == Axis.vertical ? spacing : 0),
          current,
        ],
      );
    }
    return current;
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
/// 关闭 hideToast();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<FlOverlayEntry?> showToast(
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
      duration: duration,
      options: options,
    ).show();

void hideToast() => FlOverlay().hideToast();

typedef ToastBuilder = Widget? Function(BuildContext context, ToastContent content);

class ToastOptions extends ModalOptions {
  const ToastOptions({
    this.color,
    this.onToastTap,
    this.duration = const Duration(milliseconds: 1500),
    this.animationStyle,
    this.direction,
    this.builder,
    this.animationDuration,
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
    super.shape,
    super.constraints,
    super.safeLTRB,
    super.resizeToAvoidBottomInset,
    super.insetAnimationCurve,
    super.insetAnimationDuration,
  });

  const ToastOptions.extended({
    this.color = const Color(0xFFFFFFFF),
    this.onToastTap,
    this.duration = const Duration(milliseconds: 1500),
    this.animationStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.direction = Axis.vertical,
    this.builder,
    this.padding = const EdgeInsets.all(10),
    super.constraints,
    super.backgroundColor,
    super.foregroundColor = const Color(0xFF000000),
    super.alignment = Alignment.center,
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
    super.safeLTRB,
    super.resizeToAvoidBottomInset,
    super.insetAnimationCurve,
    super.insetAnimationDuration,
  });

  /// 动画样式
  final FlAnimationStyle? animationStyle;
  final Duration? animationDuration;

  /// Toast显示时间
  final Duration duration;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 字体颜色和icon颜色
  final Color? color;

  /// Toast icon direction
  final Axis? direction;

  /// builder
  final ToastBuilder? builder;

  /// padding
  final EdgeInsetsGeometry? padding;

  ToastOptions copyWith({
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
    bool? safeLTRB,
    bool? resizeToAvoidBottomInset,
    Duration? insetAnimationDuration,
    Curve? insetAnimationCurve,
  }) => ToastOptions.extended(
    color: color ?? this.color,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    animationDuration: animationDuration ?? this.animationDuration,
    animationStyle: animationStyle ?? this.animationStyle,
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
    safeLTRB: safeLTRB ?? this.safeLTRB,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    insetAnimationDuration: insetAnimationDuration ?? this.insetAnimationDuration,
    insetAnimationCurve: insetAnimationCurve ?? this.insetAnimationCurve,
  );

  ToastOptions merge([ToastOptions? options]) => copyWith(
    animationDuration: options?.animationDuration,
    animationStyle: options?.animationStyle,
    constraints: options?.constraints,
    onToastTap: options?.onToastTap,
    textStyle: options?.textStyle,
    duration: options?.duration,
    color: options?.color,
    builder: options?.builder,
    direction: options?.direction,
    alignment: options?.alignment,
    onModalTap: options?.onModalTap,
    backgroundColor: options?.backgroundColor,
    foregroundColor: options?.foregroundColor,
    ignoring: options?.ignoring,
    absorbing: options?.absorbing,
    gaussian: options?.gaussian,
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
