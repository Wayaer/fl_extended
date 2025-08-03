import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [RichText] 魔改版
/// 建议使用 [FlText.rich],动态配置字体颜色
class FlRichText extends RichText {
  FlRichText({
    super.key,

    /// [TextSpan]
    TextStyle? style,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    String? semanticsIdentifier,
    bool? spellOut,

    /// `List<String>`
    required List<String> texts,

    /// [texts]内样式
    List<TextStyle?> styles = const [],

    /// [texts]内手势
    List<GestureRecognizer?> recognizers = const [],

    /// [texts]内语义 - 语义描述标签，相当于此text的别名
    List<String?> semanticsLabels = const [],

    /// [mouseCursors]
    List<MouseCursor?> mouseCursors = const [],

    /// [onEnters]
    List<PointerEnterEventListener?> onEnters = const [],

    /// [onExits]
    List<PointerExitEventListener?> onExits = const [],

    /// [locales]
    List<Locale?> locales = const [],

    /// [spellOuts]
    List<bool?> spellOuts = const [],

    /// StrutStyle,影响Text在垂直方向上的布局
    super.strutStyle,

    /// TextAlign,内容对齐方式
    super.textAlign = TextAlign.center,

    /// TextDirection,内容的走向方式
    super.textDirection,

    /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
    super.locale,

    /// bool 文本是否应在软换行时断行
    super.softWrap = true,

    /// TextOverflow，内容溢出时的处理方式
    super.overflow = TextOverflow.clip,

    /// double 设置文字的放大缩小，例如，fontSize=10，最终得到的文字大小为10*2.0
    super.textScaler = TextScaler.noScaling,

    /// int 设置文字的最大展示行数
    super.maxLines,

    /// TextWidthBasis 测量一行或多行文本宽度
    super.textWidthBasis = TextWidthBasis.parent,
    super.textHeightBehavior,
    super.selectionRegistrar,
    super.selectionColor,
  }) : super(
         text: TextSpan(
           style: style,
           recognizer: recognizer,
           mouseCursor: mouseCursor,
           onEnter: onEnter,
           onExit: onExit,
           semanticsLabel: semanticsLabel,
           semanticsIdentifier: semanticsIdentifier,
           spellOut: spellOut,
           locale: locale,
           children: buildTextSpans(
             texts: texts,
             styles: styles,
             semanticsLabels: semanticsLabels,
             recognizers: recognizers,
             mouseCursors: mouseCursors,
             onEnters: onEnters,
             onExits: onExits,
             locales: locales,
             spellOuts: spellOuts,
           ),
         ),
       );

  static List<TextSpan> buildTextSpans({
    required List<String> texts,
    List<TextStyle?> styles = const [],
    List<GestureRecognizer?> recognizers = const [],
    List<String?> semanticsLabels = const [],
    List<MouseCursor?> mouseCursors = const [],
    List<PointerEnterEventListener?> onEnters = const [],
    List<PointerExitEventListener?> onExits = const [],
    List<Locale?> locales = const [],
    List<bool?> spellOuts = const [],
  }) => texts.builderIV(
    (int index, String value) => TextSpan(
      text: value,
      semanticsLabel: semanticsLabels.getElementOrNull(index),
      mouseCursor: mouseCursors.getElementOrNull(index),
      onEnter: onEnters.getElementOrNull(index),
      onExit: onExits.getElementOrNull(index),
      spellOut: spellOuts.getElementOrNull(index),
      locale: locales.getElementOrNull(index),
      recognizer: recognizers.getElementOrNull(index),
      style: styles.getElementOrNull(index),
    ),
  );
}

/// 扩展 [Text]、[Text.rich]
class FlText extends StatelessWidget {
  const FlText.custom({
    this.data,
    this.inlineSpan,
    this.inlineSpans,
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [Text]
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,

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
  }) : assert(data != null || inlineSpan != null || inlineSpans != null);

  const FlText(
    String this.data, {
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [Text]
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,

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
  }) : inlineSpan = null,
       inlineSpans = null;

  const FlText.rich(
    InlineSpan this.inlineSpan, {
    super.key,
    this.useStyleFirst = true,

    /// [Text]
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,

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
       inlineSpans = null,
       recognizer = null,
       mouseCursor = null,
       onEnter = null,
       onExit = null,
       spellOut = null;

  const FlText.richSpans(
    List<InlineSpan> this.inlineSpans, {
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [Text]
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,

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
       inlineSpan = null;

  FlText.richText({
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

    /// [Text]
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,

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
       inlineSpans = FlRichText.buildTextSpans(
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
       inlineSpan = null;

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
  /// [TextDecorationStyle.wavy] 正玄曲线
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  /// 只在调试的使用
  final String? debugLabel;

  /// 将在[text]下方绘制的阴影列表
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;

  final TextLeadingDistribution? leadingDistribution;

  /// 所有[texts]默认样式
  final TextStyle? style;

  /// ---------- [Text] ----------
  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// StrutStyle,影响Text在垂直方向上的布局
  final StrutStyle? strutStyle;

  /// TextDirection,内容的走向方式
  final TextDirection? textDirection;

  /// Locale，当相同的Unicode字符可以根据不同的地区以不同的方式呈现时，用于选择字体
  final Locale? locale;

  /// bool 文本是否应在软换行时断行
  final bool? softWrap;

  /// TextOverflow，内容溢出时的处理方式
  final TextOverflow? overflow;

  /// int 设置文字的最大展示行数
  final int? maxLines;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// TextWidthBasis 测量一行或多行文本宽度
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  final Color? selectionColor;
  final String? semanticsLabel;
  final String? semanticsIdentifier;

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String? data;

  /// The text to display as a [InlineSpan].
  ///
  /// This will be null if [data] is provided instead.
  final InlineSpan? inlineSpan;

  /// 多个[InlineSpan]
  final List<InlineSpan>? inlineSpans;

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
    return Text.rich(
      inlineSpan ??
          TextSpan(
            text: data,
            recognizer: recognizer,
            mouseCursor: mouseCursor,
            onEnter: onEnter,
            onExit: onExit,
            spellOut: spellOut,
            children: inlineSpans,
          ),
      style: effectiveTextStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      strutStyle: strutStyle,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

class FlTextSpan extends TextSpan {
  FlTextSpan({
    super.text,
    super.children,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.locale,
    super.spellOut,

    /// [TextStyle]
    bool inherit = true,
    Color? color,
    Paint? foreground,
    Paint? background,
    Color? backgroundColor,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    List<String>? fontFamilyFallback,
    List<FontVariation>? fontVariations,
    String? package,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextLeadingDistribution? leadingDistribution,
    TextOverflow? overflow,
  }) : super(
         style: TextStyle(
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
           overflow: overflow,
         ),
       );
}
