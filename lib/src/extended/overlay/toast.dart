part of 'overlay.dart';

extension ExtensionToast on Toast {
  Future<ExtendedOverlayEntry?> show() => ExtendedOverlay().showToast(this);
}

class Toast extends StatelessWidget {
  const Toast(this.message, {
    super.key,
    this.options,
    this.style,
    this.icon,
  });

  /// 文字
  final String message;

  /// UI配置
  final ToastOptions? options;

  /// icon 样式 不传 仅显示文字
  final ToastStyle? style;

  /// 自定义icon [icon] 优先于 [ToastStyle]
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final currentOptions = FlExtended().toastOptions.merge(options);
    Widget current =
        currentOptions.buildText?.call(message, currentOptions.iconColor) ??
            BText(message,
                textAlign: TextAlign.center,
                color: currentOptions.iconColor,
                maxLines: 5,
                fontSize: 14);
    if ((icon ?? style?.value) != null) {
      current = IconBox(
          icon: icon ?? style?.value,
          direction: currentOptions.direction,
          spacing: currentOptions.spacing,
          size: currentOptions.iconSize,
          color: currentOptions.iconColor,
          label: current);
    }
    current = Universal(
        safeTop: true,
        safeBottom: true,
        safeRight: true,
        safeLeft: true,
        onTap: currentOptions.onToastTap,
        decoration: currentOptions.decoration,
        padding: currentOptions.padding,
        child: current);

    if (currentOptions.animationStyle != null) {
      current = FlAnimation(
          style: currentOptions.animationStyle!,
          stayDuration: currentOptions.duration
              .subtract(kFlAnimationDuration, kFlAnimationDuration),
          child: current);
    }
    return ModalWindows(options: currentOptions, child: current);
  }
}

/// Toast
/// 关闭 closeToast();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<ExtendedOverlayEntry?> showToast(String message,
    {ToastStyle? style, IconData? icon, ToastOptions? options}) =>
    Toast(message, options: options, icon: icon, style: style).show();

bool closeToast() => ExtendedOverlay().closeToast();

/// Toast类型
/// 如果使用custom  请设置 [customIcon]
enum ToastStyle { success, fail, info, warning, smile }

extension ExtensionToastStyle on ToastStyle {
  Future<ExtendedOverlayEntry?> show(String message,
      {IconData? icon, ToastOptions? options}) =>
      Toast(message, options: options, icon: icon, style: this).show();

  IconData get value {
    switch (this) {
      case ToastStyle.success:
        return FlExtendedIcons.success;
      case ToastStyle.fail:
        return FlExtendedIcons.fail;
      case ToastStyle.info:
        return FlExtendedIcons.info;
      case ToastStyle.warning:
        return FlExtendedIcons.warning;
      case ToastStyle.smile:
        return FlExtendedIcons.smile;
    }
  }
}

typedef ToastOptionsBuildText = Widget Function(String text, Color color);

class ToastOptions extends BaseModalOptions {
  const ToastOptions({
    this.iconColor = const Color(0xFFFFFFFF),
    this.decoration = const BoxDecoration(
        color: Color(0xEE000000),
        borderRadius: BorderRadius.all(Radius.circular(6))),
    this.onToastTap,
    this.textStyle,
    this.duration = const Duration(milliseconds: 1500),
    this.animationStyle = FlAnimationStyle.verticalHunting,
    this.iconSize = 18,
    this.spacing = 10,
    this.padding = const EdgeInsets.all(14),
    this.direction = Axis.horizontal,
    this.buildText,
    Color? modalColor,
    super.alignment = Alignment.center,
    super.onModalTap,
    super.gaussian = false,
    super.addMaterial = false,
    super.fuzzyDegree = 4,
    super.blendMode = BlendMode.srcOver,
    super.filter,
    super.ignoring = false,
    super.absorbing = false,
    super.canPop = true,
    super.onPopInvoked,
  }) : super(color: modalColor);

  final FlAnimationStyle? animationStyle;

  final EdgeInsetsGeometry padding;

  /// Toast 装饰器 会替换 [backgroundColor]
  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onToastTap;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// Toast显示时间
  final Duration duration;

  /// icon
  final Color iconColor;

  /// icon size
  final double iconSize;

  /// Toast icon spacing
  final double spacing;

  /// Toast icon direction
  final Axis direction;

  /// 重新 build Text
  final ToastOptionsBuildText? buildText;

  ToastOptions copyWith({
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    GestureTapCallback? onToastTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? iconColor,
    double? iconSize,
    double? spacing,
    Axis? direction,
    ModalWindowsOptions? modalWindowsOptions,
    ToastOptionsBuildText? buildText,
    GestureTapCallback? onModalTap,
    Color? modalColor,
    bool? addMaterial,
    ImageFilter? filter,
    bool? gaussian,
    double? fuzzyDegree,
    bool? ignoring,
    bool? absorbing,
    AlignmentGeometry? alignment,
  }) =>
      ToastOptions(
          padding: padding ?? this.padding,
          decoration: decoration ?? this.decoration,
          onToastTap: onToastTap ?? this.onToastTap,
          textStyle: textStyle ?? this.textStyle,
          duration: duration ?? this.duration,
          iconColor: iconColor ?? this.iconColor,
          iconSize: iconSize ?? this.iconSize,
          spacing: spacing ?? this.spacing,
          buildText: buildText ?? this.buildText,
          direction: direction ?? this.direction,
          ignoring: ignoring ?? this.ignoring,
          absorbing: ignoring ?? this.absorbing,
          alignment: alignment ?? this.alignment,
          onModalTap: onModalTap ?? this.onModalTap,
          modalColor: modalColor ?? color,
          addMaterial: addMaterial ?? this.addMaterial,
          filter: filter ?? this.filter,
          gaussian: gaussian ?? this.gaussian,
          fuzzyDegree: fuzzyDegree ?? this.fuzzyDegree);

  ToastOptions merge([ToastOptions? options]) =>
      copyWith(
          padding: options?.padding,
          decoration: options?.decoration,
          onToastTap: options?.onToastTap,
          textStyle: options?.textStyle,
          duration: options?.duration,
          iconColor: options?.iconColor,
          iconSize: options?.iconSize,
          spacing: options?.spacing,
          buildText: options?.buildText,
          direction: options?.direction,
          alignment: options?.alignment,
          onModalTap: options?.onModalTap,
          modalColor: options?.color,
          ignoring: options?.ignoring,
          absorbing: options?.absorbing,
          addMaterial: options?.addMaterial,
          filter: options?.filter,
          gaussian: options?.gaussian,
          fuzzyDegree: options?.fuzzyDegree);
}
