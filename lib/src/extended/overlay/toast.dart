part of 'overlay.dart';

/// [Toast] 快捷显示扩展
extension ExtensionToast on Toast {
  /// 显示 Toast
  Future<FlOverlayEntry?> show() => FlOverlay().showToast(this);
}

/// Toast 组件
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

  /// 显示文字
  final String text;

  /// 动画样式
  final FlAnimationStyle? animationStyle;

  /// 动画执行时间
  final Duration? animationDuration;

  /// 文字样式
  final TextStyle? textStyle;

  /// 不传则仅显示文字
  final ToastIconStyle? iconStyle;

  /// 显示时长
  final Duration? duration;

  /// Toast 点击回调
  final GestureTapCallback? onToastTap;

  /// 文字与 icon 颜色
  final Color? color;

  /// icon 与文字排列方向
  final Axis? direction;

  /// 自定义 text / icon 构建
  final ToastBuilder? builder;

  /// 对齐方式
  final AlignmentGeometry? alignment;

  /// Toast 配置
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
    final ToastContent content = ToastContent(
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
      materialBuilder: options.animationStyle == null
          ? null
          : (Widget child) {
              final Duration animationDuration = options.animationDuration ?? kFlAnimationDuration;
              return FlAnimation(
                style: options.animationStyle!,
                animationDuration: animationDuration,
                stayDuration: options.duration.subtract(animationDuration, animationDuration),
                child: child,
              );
            },
      child: current,
    );
  }
}

/// Toast 文字与 icon
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

  /// 显示文字
  final String text;

  /// 文字与 icon 颜色
  final Color? color;

  /// 图标样式
  final ToastIconStyle? iconStyle;

  /// icon 与文字排列方向
  final Axis? direction;

  /// 图标与文字间距
  final double spacing;

  /// 图标尺寸
  final double size;

  /// 文字最大行数
  final int maxLines;

  /// 文字样式
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    Widget current = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color).merge(textStyle),
      maxLines: maxLines,
    );
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

/// Toast 图标类型
enum ToastIconStyle {
  /// 成功
  success(FlIcons.success),

  /// 失败
  fail(FlIcons.fail),

  /// 信息
  info(FlIcons.info),

  /// 警告
  warning(FlIcons.warning),

  /// 笑脸
  smile(FlIcons.smile);

  const ToastIconStyle(this.icon);

  /// 图标数据
  final IconData icon;
}

/// 显示 Toast；关闭请调用 [hideToast]
/// 示例：`await showToast(...)` 可在关闭后继续执行后续逻辑
Future<FlOverlayEntry?> showToast(
  String message, {

  /// 不传则仅显示文字
  ToastIconStyle? iconStyle,
  FlAnimationStyle? animationStyle,
  Duration? animationDuration,
  TextStyle? textStyle,
  Duration? duration,
  GestureTapCallback? onToastTap,

  /// 自定义 text / icon 构建
  ToastBuilder? builder,
  ToastOptions? options,
}) => Toast(
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

/// 关闭 Toast
void hideToast() => FlOverlay().hideToast();

/// Toast 自定义构建回调
typedef ToastBuilder = Widget? Function(BuildContext context, ToastContent content);

/// Toast 配置项
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

  /// 动画执行时间
  final Duration? animationDuration;

  /// 显示时长
  final Duration duration;

  /// Toast 点击回调
  final GestureTapCallback? onToastTap;

  /// 文字与 icon 颜色
  final Color? color;

  /// icon 与文字排列方向
  final Axis? direction;

  /// 自定义 text / icon 构建
  final ToastBuilder? builder;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 拷贝并覆盖部分字段
  ToastOptions copyWith({
    BoxConstraints? constraints,
    GestureTapCallback? onToastTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? color,
    Axis? direction,
    ToastBuilder? builder,
    EdgeInsetsGeometry? padding,
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
  }) => ToastOptions(
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
    padding: padding ?? this.padding,
    ignoring: ignoring ?? this.ignoring,
    alignment: alignment ?? this.alignment,
    onModalTap: onModalTap ?? this.onModalTap,
    absorbing: absorbing ?? this.absorbing,
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

  /// 与另一配置合并
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
    padding: options?.padding,
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
