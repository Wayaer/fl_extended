part of 'overlay.dart';

extension ExtensionToast on Toast {
  Future<ExtendedOverlayEntry?> show() => ExtendedOverlay().showToast(this);
}

class Toast extends StatelessWidget {
  const Toast(
    this.message, {
    super.key,
    this.iconStyle,
    this.textStyle,
    this.duration,
    this.animationDuration,
    this.animationStyle,
    this.decoration,
    this.onToastTap,
    this.color = Colors.white,
    this.direction = Axis.horizontal,
    this.builder,
    this.options,
  });

  /// 文字
  final String message;

  /// 动画样式
  final FlAnimationStyle? animationStyle;

  /// 动画执行时间
  final Duration? animationDuration;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// Toast显示时间
  final Duration? duration;

  /// Toast 装饰器 会替换 [backgroundColor]
  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 字体颜色和icon颜色
  final Color color;

  /// Toast icon direction
  final Axis direction;

  /// 重新 build  text icon
  final ToastOptionsBuilder? builder;

  /// icon 样式 不传 仅显示文字
  final ToastIconStyle? iconStyle;

  /// ToastOptions
  final ToastOptions? options;

  @override
  Widget build(BuildContext context) {
    final currentOptions = FlExtended().toastOptions.merge(options).copyWith(
        duration: duration,
        textStyle: textStyle,
        animationDuration: animationDuration,
        animationStyle: animationStyle,
        decoration: decoration,
        onToastTap: onToastTap,
        color: color,
        direction: direction,
        builder: this.builder);

    final builder = currentOptions.builder
        ?.call(message, iconStyle?.icon, currentOptions.color);
    Widget current = builder ?? const SizedBox();
    if (builder == null) {
      current = BText(message,
          textAlign: TextAlign.center,
          color: currentOptions.color,
          maxLines: 5,
          fontSize: 14);
      if (iconStyle != null) {
        current = IconBox(
            icon: iconStyle!.icon,
            direction: currentOptions.direction,
            spacing: 10,
            size: 18,
            color: currentOptions.color,
            label: current);
      }
      current = Padding(padding: const EdgeInsets.all(14), child: current);
    }
    current = Universal(
        safeTop: true,
        safeBottom: true,
        safeRight: true,
        safeLeft: true,
        onTap: currentOptions.onToastTap,
        decoration: currentOptions.decoration,
        child: current);
    if (currentOptions.animationStyle != null) {
      current = FlAnimation(
          style: currentOptions.animationStyle!,
          animationDuration: currentOptions.animationDuration,
          stayDuration: currentOptions.duration
              .subtract(kFlAnimationDuration, kFlAnimationDuration),
          child: current);
    }
    return ModalWindows(options: currentOptions, child: current);
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
  ToastOptionsBuilder? builder,

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

typedef ToastOptionsBuilder = Widget Function(
    String text, IconData? icon, Color? color);

class ToastOptions extends BaseModalOptions {
  const ToastOptions({
    this.color = const Color(0xFFFFFFFF),
    this.decoration = const BoxDecoration(
        color: Color(0xEE000000),
        borderRadius: BorderRadius.all(Radius.circular(6))),
    this.onToastTap,
    this.textStyle,
    this.duration = const Duration(milliseconds: 1500),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationStyle = FlAnimationStyle.verticalHunting,
    this.direction = Axis.horizontal,
    this.builder,
    super.backgroundColor,
    super.alignment = Alignment.center,
    super.onModalTap,
    super.gaussian = false,
    super.addMaterial = false,
    super.fuzzyDegree = 4,
    super.blendMode = BlendMode.srcOver,
    super.filter,
    super.ignoring = false,
    super.absorbing = false,
  });

  /// 动画样式
  final FlAnimationStyle? animationStyle;

  /// 动画执行时间
  final Duration animationDuration;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// Toast显示时间
  final Duration duration;

  /// Toast 装饰器 会替换 [backgroundColor]
  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 字体颜色和icon颜色
  final Color color;

  /// Toast icon direction
  final Axis direction;

  /// 重新 build  text icon
  final ToastOptionsBuilder? builder;

  ToastOptions copyWith({
    BoxDecoration? decoration,
    GestureTapCallback? onToastTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? color,
    Axis? direction,
    ToastOptionsBuilder? builder,
    GestureTapCallback? onModalTap,
    Color? backgroundColor,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    bool? ignoring,
    bool? absorbing,
    AlignmentGeometry? alignment,
    FlAnimationStyle? animationStyle,
    Duration? animationDuration,
  }) =>
      ToastOptions(
          animationDuration: animationDuration ?? this.animationDuration,
          animationStyle: animationStyle ?? this.animationStyle,
          decoration: decoration ?? this.decoration,
          onToastTap: onToastTap ?? this.onToastTap,
          textStyle: textStyle ?? this.textStyle,
          duration: duration ?? this.duration,
          color: color ?? this.color,
          builder: builder ?? this.builder,
          direction: direction ?? this.direction,
          ignoring: ignoring ?? this.ignoring,
          absorbing: ignoring ?? this.absorbing,
          alignment: alignment ?? this.alignment,
          onModalTap: onModalTap ?? this.onModalTap,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree);

  ToastOptions merge([ToastOptions? options]) => copyWith(
      animationDuration: options?.animationDuration,
      animationStyle: options?.animationStyle,
      decoration: options?.decoration,
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
      addMaterial: options?.addMaterial,
      filter: options?.filter,
      gaussian: options?.gaussian,
      fuzzyDegree: options?.fuzzyDegree);
}
