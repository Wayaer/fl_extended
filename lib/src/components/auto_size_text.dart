import 'dart:async';

import 'package:flutter/material.dart';

/// 自动缩放字号的配置
///
/// 同时用于 [FlAutoSizeTextBuilder] 与 FlText 的 autoSizeOptions。
class FlAutoSizeOptions {
  const FlAutoSizeOptions({
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.wrapWords = true,
    this.overflowReplacement,
  });

  /// 最小字号；设置 [presetFontSizes] 时忽略
  final double minFontSize;

  /// 最大字号；设置 [presetFontSizes] 时忽略
  final double maxFontSize;

  /// 字号调整步长，通常不小于 1.0；设置 [presetFontSizes] 时忽略
  final double stepGranularity;

  /// 预置字号列表，必须按降序排列
  final List<double>? presetFontSizes;

  /// 同步多个文本的字号，组内统一取最小字号
  final FlAutoSizeGroup? group;

  /// 放不下的单词是否换行；false 时持续缩小字号直到单词能放进一行
  final bool wrapWords;

  /// 文本溢出且无法再缩小时展示的替代组件
  final Widget? overflowReplacement;
}

/// 同步多个 [FlAutoSizeTextBuilder] / FlText 的自动缩放字号；共用同一个实例的文本会统一为其中最小的字号
class FlAutoSizeGroup {
  final Map<_FlAutoSizeTextBuilderState, double> _listeners = <_FlAutoSizeTextBuilderState, double>{};
  bool _notified = false;
  double _fontSize = double.infinity;

  /// 组内当前统一的字号
  double get fontSize => _fontSize;

  void _register(_FlAutoSizeTextBuilderState text) {
    _listeners[text] = double.infinity;
  }

  void _updateFontSize(_FlAutoSizeTextBuilderState text, double maxFontSize) {
    final double oldFontSize = _fontSize;
    if (maxFontSize <= _fontSize) {
      _fontSize = maxFontSize;
      _listeners[text] = maxFontSize;
    } else if (_listeners[text] == _fontSize) {
      _listeners[text] = maxFontSize;
      _fontSize = double.infinity;
      for (final double size in _listeners.values) {
        if (size < _fontSize) {
          _fontSize = size;
        }
      }
    } else {
      _listeners[text] = maxFontSize;
    }

    if (oldFontSize != _fontSize) {
      _notified = false;
      scheduleMicrotask(_notifyListeners);
    }
  }

  void _notifyListeners() {
    if (_notified) {
      return;
    }
    _notified = true;
    for (final _FlAutoSizeTextBuilderState textState in _listeners.keys) {
      if (textState.mounted) {
        textState.notifySync();
      }
    }
  }

  void _remove(_FlAutoSizeTextBuilderState text) {
    _updateFontSize(text, double.infinity);
    _listeners.remove(text);
  }
}

/// 自动缩放文本的布局参数
///
/// 作为 [FlAutoSizeTextBuilder] 的输入时可为 null，表示使用默认值；
/// 作为 [FlAutoSizeTextData] 回传时均为已处理的最终值
class FlAutoSizeTextLayout {
  const FlAutoSizeTextLayout({
    this.textScaler,
    this.maxLines,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.strutStyle,
    this.textHeightBehavior,
  });

  /// 文本缩放器；为 null 时使用 [MediaQuery.textScalerOf]
  final TextScaler? textScaler;

  /// 最大行数；为 null 时使用 [DefaultTextStyle.maxLines]
  final int? maxLines;

  /// 文本方向；为 null 时使用 [Directionality]
  final TextDirection? textDirection;

  /// 字形选择区域；为 null 时使用 `Localizations.maybeLocaleOf`
  final Locale? locale;

  /// 是否软换行；为 null 时使用 [DefaultTextStyle.softWrap]
  final bool? softWrap;

  /// 行高基线，参与尺寸测量
  final StrutStyle? strutStyle;

  /// 升降部行为；为 null 时使用 [DefaultTextStyle] / [DefaultTextHeightBehavior]
  final TextHeightBehavior? textHeightBehavior;
}

/// 自动缩放后交给 [FlAutoSizeTextBuilder.builder] 的渲染数据
///
/// 继承 [FlAutoSizeTextLayout]，回传的布局参数均为最终生效值
class FlAutoSizeTextData extends FlAutoSizeTextLayout {
  const FlAutoSizeTextData({
    required this.textSpan,
    required this.style,
    super.textScaler,
    super.maxLines,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.strutStyle,
    super.textHeightBehavior,
  });

  /// 需要渲染的文本内容，与传入 [FlAutoSizeTextBuilder] 的内容一致
  final InlineSpan textSpan;

  /// 已合并最近的 [DefaultTextStyle]，且 [TextStyle.fontSize] 已按可用空间调整
  ///
  /// 字号只作用于根样式；若 span 内显式指定了 fontSize，则不会被缩放
  final TextStyle style;
}

/// 渲染回调，组件只负责计算字号
typedef FlAutoSizeTextBuilderCallback = Widget Function(BuildContext context, FlAutoSizeTextData data);

/// 自动缩放文本的构建器
///
/// 在父级给出的可用空间内二分查找能放下的最大字号，需要有限约束
/// （如 [SizedBox]、[Expanded]）。FlText 的 autoSizeOptions 内部同样使用该组件。
///
/// 组件只负责计算字号，样式和所有参与测量的参数都通过 [FlAutoSizeTextData] 回传给 [builder]。
///
/// 内容包含 [WidgetSpan] 时显式不支持自动缩放：跳过测量，按原始样式直接渲染，不会抛出异常。
class FlAutoSizeTextBuilder extends StatefulWidget {
  const FlAutoSizeTextBuilder(
    this.textSpan, {
    super.key,
    required this.builder,
    this.options = const FlAutoSizeOptions(),
    this.style,
    this.layout = const FlAutoSizeTextLayout(),
  });

  /// 用于测量的文本内容，可携带局部样式；包含 [WidgetSpan] 时不做自动缩放
  final InlineSpan textSpan;

  /// 自动缩放配置
  final FlAutoSizeOptions options;

  /// 根样式；为 null 时仅使用最近的 [DefaultTextStyle]
  final TextStyle? style;

  /// 参与尺寸测量的布局参数
  ///
  /// 组件解析后通过 [FlAutoSizeTextData] 原样回传，渲染时设置上即可
  final FlAutoSizeTextLayout layout;

  /// 渲染回调，组件计算完字号后通过 [FlAutoSizeTextData] 回传
  ///
  /// 需要渲染与 [textSpan] 相同的内容，并设置回传的布局参数，否则测量结果和实际展示会不一致
  final FlAutoSizeTextBuilderCallback builder;

  @override
  State<FlAutoSizeTextBuilder> createState() => _FlAutoSizeTextBuilderState();
}

class _FlAutoSizeTextBuilderState extends State<FlAutoSizeTextBuilder> {
  /// 未指定字号时的默认字号
  static const double defaultFontSize = 14;

  /// wrapWords 为 false 时拆分单词使用的分隔符
  static final RegExp wordSeparator = RegExp(r'\s+');

  @override
  void initState() {
    super.initState();
    widget.options.group?._register(this);
  }

  @override
  void didUpdateWidget(FlAutoSizeTextBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options.group != widget.options.group) {
      oldWidget.options.group?._remove(this);
      widget.options.group?._register(this);
    }
  }

  @override
  void dispose() {
    widget.options.group?._remove(this);
    super.dispose();
  }

  void notifySync() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
        TextStyle style = widget.style ?? const TextStyle();
        if (style.inherit) {
          style = defaultTextStyle.style.merge(style);
        }
        if (style.fontSize == null) {
          style = style.copyWith(fontSize: defaultFontSize);
        }
        final FlAutoSizeTextLayout layout = widget.layout;
        final int? maxLines = layout.maxLines ?? defaultTextStyle.maxLines;
        validateProperties(maxLines);

        final TextScaler textScaler = layout.textScaler ?? MediaQuery.textScalerOf(context);
        final _TextLayoutConfig config = _TextLayoutConfig(
          textDirection: layout.textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr,
          locale: layout.locale ?? Localizations.maybeLocaleOf(context),
          softWrap: layout.softWrap ?? defaultTextStyle.softWrap,
          textHeightBehavior:
              layout.textHeightBehavior ??
              defaultTextStyle.textHeightBehavior ??
              DefaultTextHeightBehavior.maybeOf(context),
          strutStyle: layout.strutStyle,
        );
        // WidgetSpan 无法参与 TextPainter 测量，含 WidgetSpan 时显式不支持自动缩放，按原始字号渲染
        final bool hasWidgetSpan = containsWidgetSpan(widget.textSpan);
        final (double fontSize, bool textFits) = hasWidgetSpan
            ? (style.fontSize!, true)
            : calculateFontSize(constraints, style, maxLines, textScaler, config);

        final FlAutoSizeGroup? group = widget.options.group;
        if (!hasWidgetSpan) {
          group?._updateFontSize(this, fontSize);
        }
        if (widget.options.overflowReplacement != null && !textFits) {
          return widget.options.overflowReplacement!;
        }

        final FlAutoSizeTextData data = FlAutoSizeTextData(
          textSpan: widget.textSpan,
          style: style.copyWith(fontSize: hasWidgetSpan ? fontSize : (group?.fontSize ?? fontSize)),
          textScaler: textScaler,
          maxLines: maxLines,
          textDirection: config.textDirection,
          locale: config.locale,
          softWrap: config.softWrap,
          strutStyle: config.strutStyle,
          textHeightBehavior: config.textHeightBehavior,
        );
        return widget.builder(context, data);
      },
    );
  }

  /// 内容中是否嵌套 [WidgetSpan]
  bool containsWidgetSpan(InlineSpan span) {
    if (span is WidgetSpan) {
      return true;
    }
    if (span is TextSpan) {
      return span.children?.any(containsWidgetSpan) ?? false;
    }
    return false;
  }

  void validateProperties(int? maxLines) {
    final FlAutoSizeOptions options = widget.options;
    assert(maxLines == null || maxLines > 0, 'MaxLines must be greater than or equal to 1.');
    if (options.presetFontSizes == null) {
      assert(options.stepGranularity >= 0.1, 'StepGranularity must be greater than or equal to 0.1.');
      assert(options.minFontSize >= 0, 'MinFontSize must be greater than or equal to 0.');
      assert(options.maxFontSize > 0, 'MaxFontSize has to be greater than 0.');
      assert(options.minFontSize <= options.maxFontSize, 'MinFontSize must be smaller or equal than maxFontSize.');
      assert(
        options.minFontSize / options.stepGranularity % 1 == 0,
        'MinFontSize must be a multiple of stepGranularity.',
      );
      if (options.maxFontSize != double.infinity) {
        assert(
          options.maxFontSize / options.stepGranularity % 1 == 0,
          'MaxFontSize must be a multiple of stepGranularity.',
        );
      }
    } else {
      final List<double> presetFontSizes = options.presetFontSizes!;
      assert(presetFontSizes.isNotEmpty, 'PresetFontSizes must not be empty.');
      for (int index = 1; index < presetFontSizes.length; index++) {
        assert(presetFontSizes[index - 1] > presetFontSizes[index], 'PresetFontSizes must be in descending order.');
      }
    }
  }

  /// 二分查找可用空间内能放下的最大字号，返回 (字号, 文本是否完整放下)
  (double, bool) calculateFontSize(
    BoxConstraints constraints,
    TextStyle style,
    int? maxLines,
    TextScaler textScaler,
    _TextLayoutConfig config,
  ) {
    final double baseFontSize = style.fontSize!;
    final List<double>? presetFontSizes = widget.options.presetFontSizes?.reversed.toList();

    int left;
    int right;
    if (presetFontSizes == null) {
      final double defaultSize = baseFontSize.clamp(widget.options.minFontSize, widget.options.maxFontSize);
      if (checkTextFits(style, defaultSize, maxLines, constraints, textScaler, config)) {
        return (defaultSize, true);
      }
      left = (widget.options.minFontSize / widget.options.stepGranularity).floor();
      right = (defaultSize / widget.options.stepGranularity).ceil();
    } else {
      left = 0;
      right = presetFontSizes.length - 1;
    }

    bool lastValueFits = false;
    while (left <= right) {
      final int mid = (left + (right - left) / 2).floor();
      final double size = presetFontSizes == null ? mid * widget.options.stepGranularity : presetFontSizes[mid];
      if (checkTextFits(style, size, maxLines, constraints, textScaler, config)) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
      }
    }
    if (!lastValueFits) {
      right += 1;
    }

    final double fontSize = presetFontSizes == null ? right * widget.options.stepGranularity : presetFontSizes[right];
    return (fontSize, lastValueFits);
  }

  bool checkTextFits(
    TextStyle style,
    double fontSize,
    int? maxLines,
    BoxConstraints constraints,
    TextScaler textScaler,
    _TextLayoutConfig config,
  ) {
    final TextSpan span = TextSpan(
      style: style.copyWith(fontSize: fontSize),
      children: <InlineSpan>[widget.textSpan],
    );
    if (!widget.options.wrapWords) {
      final List<String> words = span.toPlainText().split(wordSeparator);
      final TextPainter wordWrapTextPainter = TextPainter(
        text: TextSpan(style: span.style, text: words.join('\n')),
        textDirection: config.textDirection,
        textScaler: textScaler,
        maxLines: words.length,
        locale: config.locale,
        strutStyle: config.strutStyle,
        textHeightBehavior: config.textHeightBehavior,
      )..layout(maxWidth: constraints.maxWidth);
      final bool wordsFit =
          !(wordWrapTextPainter.didExceedMaxLines || wordWrapTextPainter.width > constraints.maxWidth);
      wordWrapTextPainter.dispose();
      if (!wordsFit) {
        return false;
      }
    }

    final TextPainter textPainter = TextPainter(
      text: span,
      textDirection: config.textDirection,
      textScaler: textScaler,
      maxLines: maxLines,
      locale: config.locale,
      strutStyle: config.strutStyle,
      textHeightBehavior: config.textHeightBehavior,
    )..layout(maxWidth: config.softWrap ? constraints.maxWidth : double.infinity);
    final bool textFits =
        !(textPainter.didExceedMaxLines ||
            textPainter.height > constraints.maxHeight ||
            textPainter.width > constraints.maxWidth);
    textPainter.dispose();
    return textFits;
  }
}

/// 单次测量使用的文本布局配置，只保留会影响文本尺寸的项
class _TextLayoutConfig {
  const _TextLayoutConfig({
    required this.textDirection,
    required this.locale,
    required this.softWrap,
    required this.textHeightBehavior,
    required this.strutStyle,
  });

  final TextDirection textDirection;
  final Locale? locale;
  final bool softWrap;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;
}
