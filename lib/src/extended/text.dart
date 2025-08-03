import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_extended/fl_extended.dart';

/// [RichText] 魔改版
/// 建议使用 [BText.rich],动态配置字体颜色
class RText extends RichText {
  RText({
    super.key,

    /// 文本
    required List<String> texts,

    /// 所有[texts]默认样式
    TextStyle? style,

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
         text: buildTextSpan(
           buildTextSpans(
             texts: texts,
             style: style,
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

  static TextSpan buildTextSpan(List<TextSpan> textSpans) => TextSpan(
    text: textSpans.firstOrNull?.text,
    style: textSpans.firstOrNull?.style,
    semanticsLabel: textSpans.firstOrNull?.semanticsLabel,
    recognizer: textSpans.firstOrNull?.recognizer,
    mouseCursor: textSpans.firstOrNull?.mouseCursor,
    onEnter: textSpans.firstOrNull?.onEnter,
    onExit: textSpans.firstOrNull?.onExit,
    locale: textSpans.firstOrNull?.locale,
    spellOut: textSpans.firstOrNull?.spellOut,
    children: textSpans.length > 1 ? textSpans.sublist(1, textSpans.length) : null,
  );

  static List<TextSpan> buildTextSpans({
    TextStyle? style,
    required List<String> texts,
    required List<TextStyle?> styles,
    required List<GestureRecognizer?> recognizers,
    required List<String?> semanticsLabels,
    required List<MouseCursor?> mouseCursors,
    required List<PointerEnterEventListener?> onEnters,
    required List<PointerExitEventListener?> onExits,
    required List<Locale?> locales,
    required List<bool?> spellOuts,
  }) => texts.builderEntry(
    (MapEntry<int, String> entry) => TextSpan(
      text: entry.value,
      semanticsLabel:
          semanticsLabels.isEmpty || (semanticsLabels.length - 1) < entry.key ? null : semanticsLabels[entry.key],
      mouseCursor: mouseCursors.isEmpty || (mouseCursors.length - 1) < entry.key ? null : mouseCursors[entry.key],
      onEnter: onEnters.isEmpty || (onEnters.length - 1) < entry.key ? null : onEnters[entry.key],
      onExit: onExits.isEmpty || (onExits.length - 1) < entry.key ? null : onExits[entry.key],
      spellOut: spellOuts.isEmpty || (spellOuts.length - 1) < entry.key ? null : spellOuts[entry.key],
      locale: locales.isEmpty || (locales.length - 1) < entry.key ? null : locales[entry.key],
      recognizer: recognizers.isEmpty || (recognizers.length - 1) < entry.key ? null : recognizers[entry.key],
      style:
          styles.isEmpty || (styles.length - 1) < entry.key
              ? style
              : style == null
              ? styles[entry.key]
              : style.merge(styles[entry.key]),
    ),
  );
}

/// 扩展 [Text]、[Text.rich]
class BText extends StatelessWidget {
  const BText(
    this.text, {
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.style,
    this.recognizer,
    this.semanticsLabel,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.spellOut,

    /// [Text]
    this.locale,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.textScaler = TextScaler.noScaling,

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
  }) : texts = const [],
       styles = const [],
       recognizers = const [],
       semanticsLabels = const [],
       mouseCursors = const [],
       onEnters = const [],
       onExits = const [],
       locales = const [],
       spellOuts = const [];

  /// 与 [RText] 一致，仅增加 主题适配
  /// [text]、[style]、[recognizer]、[semanticsLabel]、[mouseCursor]、[onEnter]、[onExit]、[locale]、[spellOut]
  /// 这几个如果有值默认应用于 [texts][0]
  const BText.rich({
    super.key,
    this.useStyleFirst = true,

    /// [TextSpan]
    this.text = '',
    this.texts = const [],
    this.style,
    this.styles = const [],
    this.recognizer,
    this.recognizers = const [],
    this.semanticsLabel,
    this.semanticsLabels = const [],
    this.mouseCursor,
    this.mouseCursors = const [],
    this.onEnter,
    this.onEnters = const [],
    this.onExit,
    this.onExits = const [],
    this.locale,
    this.locales = const [],
    this.spellOut,
    this.spellOuts = const [],

    /// [Text]
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.textScaler = TextScaler.noScaling,

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
  });

  /// 当 [color]和[style]中都有值
  /// [useStyleFirst]=true 优先使用 [style],
  /// [useStyleFirst]=false 优先使用外层,
  final bool useStyleFirst;

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

  /// ---------- [TextSpan] ----------

  final String? text;

  /// 所有[texts]默认样式
  final TextStyle? style;

  /// [text]手势
  final GestureRecognizer? recognizer;

  /// [text]语义 - 语义描述标签，相当于此text的别名
  final String? semanticsLabel;

  /// [mouseCursor]
  final MouseCursor? mouseCursor;

  /// [onEnter]
  final PointerEnterEventListener? onEnter;

  /// [onExit]
  final PointerExitEventListener? onExit;

  /// [spellOut]
  final bool? spellOut;

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

  /// ---------- [BText.rich] ----------
  /// 排在第一个[text]后面
  final List<String> texts;

  /// [texts]内样式
  final List<TextStyle> styles;

  /// [texts]内手势
  final List<GestureRecognizer?> recognizers;

  /// [texts]内语义 - 语义描述标签，相当于此text的别名
  final List<String> semanticsLabels;

  /// [mouseCursors]
  final List<MouseCursor?> mouseCursors;

  /// [onEnters]
  final List<PointerEnterEventListener?> onEnters;

  /// [onExits]
  final List<PointerExitEventListener?> onExits;

  /// [locales]
  final List<Locale?> locales;

  /// [spellOuts]
  final List<bool?> spellOuts;

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
      RText.buildTextSpan(
        RText.buildTextSpans(
          style: effectiveTextStyle,
          texts: [if (text != null) text!, ...texts],
          styles: [effectiveTextStyle, ...styles],
          recognizers: [if (recognizer != null) recognizer!, ...recognizers],
          semanticsLabels: [if (semanticsLabel != null) semanticsLabel!, ...semanticsLabels],
          mouseCursors: [if (mouseCursor != null) mouseCursor!, ...mouseCursors],
          onEnters: [if (onEnter != null) onEnter!, ...onEnters],
          onExits: [if (onExit != null) onExit!, ...onExits],
          locales: [if (locale != null) locale!, ...locales],
          spellOuts: [if (spellOut != null) spellOut!, ...spellOuts],
        ),
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
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
