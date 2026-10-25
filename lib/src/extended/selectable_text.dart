import 'dart:ui';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlSelectableText extends StatelessWidget {
  const FlSelectableText.custom({
    this.data,
    this.textSpan,
    this.textSpans,
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [SelectableText]
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.locale,

    /// [TextStyle]
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.leadingDistribution,
    this.fontVariations,
  }) : assert(data != null || textSpan != null || textSpans != null);

  const FlSelectableText(
    String this.data, {
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [SelectableText]
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.locale,

    /// [TextStyle]
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.leadingDistribution,
    this.fontVariations,
  }) : textSpan = null,
       textSpans = null;

  const FlSelectableText.rich(
    this.textSpan, {
    super.key,
    this.useStyleFirst = true,

    /// [SelectableText]
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.locale,

    /// [TextStyle]
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.leadingDistribution,
    this.fontVariations,
  }) : data = null,
       textSpans = null,
       recognizer = null,
       mouseCursor = null,
       onEnter = null,
       onExit = null,
       spellOut = null;

  const FlSelectableText.richSpans(
    List<TextSpan> this.textSpans, {
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [SelectableText]
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.locale,

    /// [TextStyle]
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.leadingDistribution,
    this.fontVariations,
  }) : data = null,
       textSpan = null;

  FlSelectableText.richText({
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [TextSpan.children]
    required List<String> texts,
    List<TextStyle?> styles = const [],
    List<GestureRecognizer?> recognizers = const [],
    List<String?> semanticsLabels = const [],
    List<MouseCursor?> mouseCursors = const [],
    List<PointerEnterEventListener?> onEnters = const [],
    List<PointerExitEventListener?> onExits = const [],
    List<Locale?> locales = const [],
    List<bool?> spellOuts = const [],

    /// [SelectableText]
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.scrollBehavior,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.locale,

    /// [TextStyle]
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.shadows,
    this.fontFeatures,
    this.leadingDistribution,
    this.fontVariations,
  }) : data = null,
       textSpans = FlRichText.buildTextSpans(
         texts: texts,
         styles: styles,
         recognizers: recognizers,
         semanticsLabels: semanticsLabels,
         mouseCursors: mouseCursors,
         onEnters: onEnters,
         onExits: onExits,
         locales: locales,
         spellOuts: spellOuts,
       ),
       textSpan = null;

  /// 当 [color]和[style]中都有值
  /// [useStyleFirst]=true 优先使用 [style],
  /// [useStyleFirst]=false 优先使用外层,
  final bool useStyleFirst;

  /// ---------- [TextSpan] ----------
  final GestureRecognizer? recognizer;
  final MouseCursor? mouseCursor;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
  final bool? spellOut;

  /// ---------- [TextStyle] ----------
  /// 默认样式会继承层级最为接近的 DefaultTextStyle，为true 表示继承，false 表示完全重写
  final bool inherit;

  /// 字体颜色，注意： 如果有特殊的foreground，此值必须是null
  final Color? color;

  /// text的前景色，与 [color] 不能同时设置
  final Paint? foreground;

  /// [text]的背景色
  final Paint? background;

  final Color? backgroundColor;
  final String? fontFamily;

  /// 字体大小 默认的是 14
  final double? fontSize;

  /// 字体的粗细程度 FontWeight.w100 -- FontWeight.w900 . 默认是FontWeight.w400，
  final FontWeight? fontWeight;
  final List<String>? fontFamilyFallback;
  final List<FontVariation>? fontVariations;

  final String? package;

  /// [FontStyle.normal]正常 [FontStyle.italic]斜体
  final FontStyle? fontStyle;

  /// 单个字母或者汉字的距离，默认是1.0，负数可以拉近距离
  final double? letterSpacing;

  /// 单词之间添加的空间间隔，负数可以拉近距离
  final double? wordSpacing;

  /// [TextBaseline.ideographic]用来对齐表意文字的水平线
  /// [TextBaseline.alphabetic ]以标准的字母顺序为基线
  final TextBaseline? textBaseline;

  /// 文本的高度 主要用于[TextSpan] 来设置不同的高度
  final double? height;

  /// [text]的划线
  /// [TextDecoration.none] 没有 默认
  /// [TextDecoration.underline] 下划线
  /// [TextDecoration.overline] 上划线
  /// [TextDecoration.lineThrough] 中间的线（删除线）
  final TextDecoration decoration;

  /// [decoration]划线的颜色
  final Color? decorationColor;

  /// [decoration]划线的样式
  /// [TextDecorationStyle.solid]实线
  /// [TextDecorationStyle.double] 画两条线
  /// [TextDecorationStyle.dotted] 点线（一个点一个点的）
  /// [TextDecorationStyle.dashed] 虚线（一个长方形一个长方形的线）
  /// [TextDecorationStyle.wavy] 正弦曲线
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  /// 只在调试的使用
  final String? debugLabel;

  /// 将在[text]下方绘制的阴影列表
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;

  final TextLeadingDistribution? leadingDistribution;

  /// 所有默认样式
  final TextStyle? style;

  /// ---------- [SelectableText] ----------
  /// 水平对齐方式
  final TextAlign? textAlign;

  /// [StrutStyle]，影响文本垂直方向布局
  final StrutStyle? strutStyle;

  /// 文本方向
  final TextDirection? textDirection;

  /// 区域设置；相同 Unicode 在不同地区呈现不同时用于选字体
  final Locale? locale;

  /// 最大展示行数
  final int? maxLines;

  /// 文字缩放
  final TextScaler? textScaler;

  /// 测量一行或多行文本宽度的方式
  final TextWidthBasis? textWidthBasis;

  /// 行高行为
  final TextHeightBehavior? textHeightBehavior;

  /// 选区高亮颜色
  final Color? selectionColor;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 最小行数
  final int? minLines;

  /// 是否显示光标
  final bool showCursor;

  /// 光标宽度
  final double cursorWidth;

  /// 光标高度
  final double? cursorHeight;

  /// 光标圆角
  final Radius? cursorRadius;

  /// 光标颜色（表示当前插入点）。
  /// 为 null 时依次回退 [DefaultSelectionStyle.cursorColor]、
  /// iOS/macOS 的 [CupertinoThemeData.primaryColor]、否则 [ColorScheme.primary]。
  final Color? cursorColor;

  /// 选区高亮框高度计算方式，详见 [BoxHeightStyle]
  final BoxHeightStyle selectionHeightStyle;

  /// 选区高亮框宽度计算方式，详见 [BoxWidthStyle]
  final BoxWidthStyle selectionWidthStyle;

  /// 是否启用交互式选择
  final bool enableInteractiveSelection;

  /// 选择控件
  final TextSelectionControls? selectionControls;

  /// 拖拽起始行为
  final DragStartBehavior dragStartBehavior;

  /// 点击回调。
  /// 组件内部已用 [GestureDetector] 处理点击、焦点、光标与选区等；
  /// 外层再包竞争手势易冲突。需无干扰地处理点击时使用本回调；
  /// 监听焦点请用 [focusNode]；监听指针事件请用 [Listener]。
  final GestureTapCallback? onTap;

  /// 滚动物理效果
  final ScrollPhysics? scrollPhysics;

  /// 滚动行为
  final ScrollBehavior? scrollBehavior;

  /// 语义标签
  final String? semanticsLabel;

  /// 选区变化回调
  final SelectionChangedCallback? onSelectionChanged;

  /// 上下文菜单构建器
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// 放大镜配置
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// 要显示的纯文本；若提供 [textSpan] 则为 null
  final String? data;

  /// 要显示的 [TextSpan]；若提供 [data] 则为 null
  final TextSpan? textSpan;

  /// 多个 [TextSpan]
  final List<TextSpan>? textSpans;

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveTextStyle = TextStyle(
      inherit: inherit,
      color: color,
      foreground: foreground,
      background: background,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontVariations: fontVariations,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      leadingDistribution: leadingDistribution,
      package: package,
    );
    if (useStyleFirst) {
      effectiveTextStyle = effectiveTextStyle.merge(style);
    } else if (style != null) {
      effectiveTextStyle = style!.merge(effectiveTextStyle);
    }
    return SelectableText.rich(
      textSpan ??
          TextSpan(
            text: data,
            recognizer: recognizer,
            mouseCursor: mouseCursor,
            onEnter: onEnter,
            onExit: onExit,
            spellOut: spellOut,
            children: textSpans,
          ),
      style: effectiveTextStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      scrollPhysics: scrollPhysics,
      scrollBehavior: scrollBehavior,
      semanticsLabel: semanticsLabel,
      onSelectionChanged: onSelectionChanged,
      contextMenuBuilder: contextMenuBuilder,
      showCursor: showCursor,
      autofocus: autofocus,
      minLines: minLines,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      magnifierConfiguration: magnifierConfiguration,
      focusNode: focusNode,
    );
  }
}
