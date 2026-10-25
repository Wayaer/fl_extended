import 'dart:convert';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/services.dart';

/// [String] 扩展
extension ExtensionString on String {
  /// [base64.decode]
  Uint8List base64Decode() => base64.decode(this);

  /// [base64Url.decode]
  Uint8List base64UrlDecode() => base64Url.decode(this);

  /// [base64.normalize]；[start]、[end] 指定需要规范化的区间
  String base64Normalize([int start = 0, int? end]) => base64.normalize(this, start, end);

  /// [base64Url.normalize]；[start]、[end] 指定需要规范化的区间
  String base64UrlNormalize([int start = 0, int? end]) => base64Url.normalize(this, start, end);

  /// [utf8.encode]
  Uint8List utf8Encode() => utf8.encode(this);

  /// [ascii.encode]
  Uint8List asciiEncode() => ascii.encode(this);

  /// [latin1.encode]
  Uint8List latin1Encode() => latin1.encode(this);

  /// [json.decode]
  dynamic jsonDecode({Object? Function(Object? key, Object? value)? reviver}) => json.decode(this, reviver: reviver);

  /// [htmlEscape.convert]
  String htmlEscapeConvert() => htmlEscape.convert(this);

  /// [Uri.decodeComponent]
  String uriDecodeComponent() => Uri.decodeComponent(this);

  /// [Uri.decodeFull]
  String uriDecodeFull() => Uri.decodeFull(this);

  /// [Uri.decodeQueryComponent]
  String uriDecodeQueryComponent({Encoding encoding = utf8}) => Uri.decodeQueryComponent(this, encoding: encoding);

  /// [Uri.encodeComponent]
  String uriEncodeComponent() => Uri.encodeComponent(this);

  /// [Uri.encodeFull]
  String uriEncodeFull() => Uri.encodeFull(this);

  /// [Uri.encodeQueryComponent]
  String uriEncodeQueryComponent({Encoding encoding = utf8}) => Uri.encodeQueryComponent(this, encoding: encoding);

  /// [Uri.parse]
  Uri uriParse() => Uri.parse(this);

  /// [Uri.tryParse]
  Uri? uriTryParse() => Uri.tryParse(this);

  /// [Uri.parseIPv4Address]
  List<int> uriParseIPv4Address() => Uri.parseIPv4Address(this);

  /// [Uri.parseIPv6Address]
  List<int> uriParseIPv6Address([int start = 0, int? end]) => Uri.parseIPv6Address(this, start, end);

  num get parseNum => num.parse(this);

  num? get tryParseNum => num.tryParse(this);

  int get parseInt => int.parse(this);

  int? get tryParseInt => int.tryParse(this);

  double get parseDouble => double.parse(this);

  double? get tryParseDouble => double.tryParse(this);

  DateTime get parseDateTime => DateTime.parse(this);

  DateTime? get tryParseDateTime => DateTime.tryParse(this);

  BigInt get parseBigInt => BigInt.parse(this);

  BigInt? get tryParseBigInt => BigInt.tryParse(this);

  /// 移除首字符
  String get removeFirst => length > 1 ? substring(1, length) : '';

  /// 移除末字符
  String get removeLast => length > 1 ? substring(0, length - 1) : '';

  /// 在 [index] 处插入 [element]
  String insert(int index, String element) => '${substring(0, index)}$element${substring(index, length)}';

  /// 复制到剪贴板
  Future<void> toClipboard() => Clipboard.setData(ClipboardData(text: this));

  /// 是否为邮箱格式
  bool get isEmail => FlRegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(this);

  /// 是否为中国大陆手机号
  bool get isChinaPhone => FlRegExp(r'^1([38]\d|4[579]|5[0-35-9]|66|7[0135678]|9[89])\d{8}$').hasMatch(this);

  /// 按 UTF-8 编码为字节列表
  ///
  /// 与 [ExtensionListInt.toUtf8] 对应。
  List<int> get utf8ToList => utf8.encode(this);

  /// 每隔 [digit] 位插入 [pattern]
  String formatDigitPattern({int digit = 4, String pattern = ' '}) {
    if (digit <= 0 || pattern.isEmpty) return this;
    String text = replaceAllMapped(FlRegExp('(.{$digit})'), (Match match) => '${match.group(0)}$pattern');
    if (text.endsWith(pattern)) text = text.substring(0, text.length - pattern.length);
    return text;
  }

  /// 从末尾起每隔 [digit] 位插入 [pattern]
  String formatDigitPatternEnd({int digit = 4, String pattern = ' '}) {
    final String text = reverse.formatDigitPattern(digit: digit, pattern: pattern);
    return text.reverse;
  }

  /// 字符串反转
  String get reverse {
    final String text = this;
    if (isEmpty) return '';
    final StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  /// 移除头部指定 [prefix]；不匹配则原样返回
  String removePrefix(String prefix) {
    if (!startsWith(prefix)) return this;
    return substring(prefix.length);
  }

  /// 移除尾部指定 [suffix]；不匹配则原样返回
  String removeSuffix(String suffix) {
    if (!endsWith(suffix)) return this;
    return substring(0, length - suffix.length);
  }

  /// 移除头部指定长度；超出长度时返回空字符串
  String removePrefixLength(int i) => substring(i.clamp(0, length).toInt(), length);

  /// 移除尾部指定长度；超出长度时返回空字符串
  String removeSuffixLength(int i) => substring(0, (length - i).clamp(0, length).toInt());

  /// 是否包含数字字符
  ///
  /// 示例：
  /// ```dart
  /// '123'.isNumber; // true
  /// '123.456'.isNumber; // true
  /// 'abc'.isNumber; // false
  /// '123abc'.isNumber; // true（含数字即 true）
  /// ```
  bool get isNumber {
    final isMatch = FlRegExp("[0-9]").hasMatch(this);
    return isMatch;
  }

  /// 是否为单个数字字符
  ///
  /// 示例：
  /// ```dart
  /// '1'.isDigit; // true
  /// '123'.isDigit; // false
  /// '123.456'.isDigit; // false
  /// 'abc'.isDigit; // false
  /// ```
  bool get isDigit {
    final isMatch = FlRegExp(r'\d').hasMatch(this);
    return isMatch && length == 1;
  }

  /// 是否包含中文
  bool get isChinese => FlRegExp('[\u4e00-\u9fa5]').hasMatch(this);

  /// 是否包含字母
  bool get isLetter => FlRegExp("[A-Za-z]").hasMatch(this);

  /// 是否为合法 JSON 字符串
  bool get isJson {
    try {
      jsonDecode();
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  /// 从十六进制字符串解析颜色
  ///
  /// 支持 `#RGB`、`#RGBA`、`#RRGGBB`、`#AARRGGBB`（`#` 可省略）。
  Color get fromHex {
    String hex = startsWith('#') ? substring(1) : this;
    if (hex.length == 3 || hex.length == 4) {
      hex = hex.split('').map((String char) => '$char$char').join();
    }
    if (hex.length == 6) hex = 'ff$hex';
    if (hex.length != 8) throw FormatException('Invalid hex color: $this');
    return Color(int.parse(hex, radix: 16));
  }
}

extension ExtensionStringUnsafe on String? {
  /// null 或 empty 返回 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 非 null 且非 empty 返回 true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}
