import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fl_extended/fl_extended.dart';

/// String 扩展
extension ExtensionString on String {
  /// Base64.encode()
  Uint8List base64Decode() => base64.decode(this);

  /// base64url.encode()
  Uint8List base64UrlDecode() => base64Url.decode(this);

  /// base64.normalize()
  String base64Normalize([int start = 0, int? end]) => base64.normalize(this);

  /// base64url.normalize()
  String base64UrlNormalize([int start = 0, int? end]) =>
      base64Url.normalize(this);

  /// utf8.encode()
  Uint8List utf8Encode() => utf8.encode(this);

  /// ascii.encode()
  Uint8List asciiEncode() => ascii.encode(this);

  /// latin1.encode()
  Uint8List latin1Encode() => latin1.encode(this);

  /// jsonDecode
  dynamic jsonDecode({Object? Function(Object? key, Object? value)? reviver}) =>
      json.decode(this, reviver: reviver);

  /// htmlEscape.convert()
  String htmlEscapeConvert() => htmlEscape.convert(this);

  /// Uri.decodeComponent()
  String uriDecodeComponent() => Uri.decodeComponent(this);

  /// Uri.decodeFull()
  String uriDecodeFull() => Uri.decodeFull(this);

  /// Uri.decodeQueryComponent()
  String uriDecodeQueryComponent({Encoding encoding = utf8}) =>
      Uri.decodeQueryComponent(this, encoding: encoding);

  /// Uri.encodeComponent()
  String uriEncodeComponent() => Uri.encodeComponent(this);

  /// Uri.encodeFull()
  String uriEncodeFull() => Uri.encodeFull(this);

  /// Uri.encodeQueryComponent()
  String uriEncodeQueryComponent({Encoding encoding = utf8}) =>
      Uri.encodeQueryComponent(this, encoding: encoding);

  /// Uri.parse()
  Uri uriParse() => Uri.parse(this);

  /// Uri.tryParse()
  Uri? uriTryParse() => Uri.tryParse(this);

  /// Uri.parseIPv4Address()
  List<int> uriParseIPv4Address() => Uri.parseIPv4Address(this);

  /// Uri.parseIPv6Address()
  List<int> uriParseIPv6Address([int start = 0, int? end]) =>
      Uri.parseIPv6Address(this, start, end);

  num get parseNum => num.parse(this);

  num? get tryParseNum => num.tryParse(this);

  int get parseInt => int.parse(this);

  int? get tryParseInt => int.tryParse(this);

  double get parseDouble => double.parse(this);

  double? get tryParseDouble => double.tryParse(this);

  DateTime get parseDateTime => DateTime.parse(this);

  DateTime? get tryParseDateTime => DateTime.tryParse(this);

  ///Removes first element
  String get removeFirst => length > 1 ? substring(1, length) : '';

  ///Removes last element
  String get removeLast => length > 1 ? substring(0, length - 1) : '';

  String insert(int index, String element) =>
      '${substring(0, index)}$element${substring(index, length)}';

  /// 复制到粘贴板
  Future<void> toClipboard() => Clipboard.setData(ClipboardData(text: this));

  /// 验证邮箱
  bool get isEmail =>
      RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(this);

  /// 手机号验证
  bool get isChinaPhone => RegExp(
    r'^1([38]\d|4[579]|5[0-3,5-9]|66|7[0135678]|9[89])\d{8}$',
  ).hasMatch(this);

  /// utf8ToList
  List<int> get utf8ToList {
    final List<int> words = length.generate((_) => 0);
    for (int i = 0; i < length; i++) {
      words[i >> 2] |=
          (codeUnitAt(i) & 0xff).toSigned(32) <<
          (24 - (i % 4) * 8).toSigned(32);
    }
    return words;
  }

  /// 每隔 x位 加 pattern
  String formatDigitPattern({int digit = 4, String pattern = ' '}) {
    String text = this;
    text = text.replaceAllMapped(
      RegExp('(.{$digit})'),
      (Match match) => '${match.group(0)}$pattern',
    );
    if (text.endsWith(pattern)) text = text.substring(0, text.length - 1);
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  String formatDigitPatternEnd(
    String text, {
    int digit = 4,
    String pattern = ' ',
  }) {
    String temp = reverse;
    temp = formatDigitPattern(digit: digit, pattern: pattern);
    temp = reverse;
    return temp;
  }

  /// reverse
  String get reverse {
    final String text = this;
    if (isEmpty) return '';
    final StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  /// 移出头部指定 [prefix] 不包含不移出
  String removePrefix(String prefix) {
    if (!startsWith(prefix)) return this;
    return substring(prefix.length);
  }

  /// 移出尾部指定 [suffix] 不包含不移出
  String removeSuffix(String suffix) {
    if (!endsWith(suffix)) return this;
    return substring(0, length - suffix.length);
  }

  /// 移出头部指定长度
  String removePrefixLength(int i) => substring(i, length);

  /// 移出尾部指定长度
  String removeSuffixLength(int i) => substring(0, length - i);

  /// Check whether a string is a number or not
  /// ```dart
  /// '123'.isNumber(); // true
  /// '123.456'.isNumber(); // true
  /// 'abc'.isNumber(); // false
  /// '123abc'.isNumber(); // false
  /// ```
  bool get isNumber {
    final isMatch = RegExp("[0-9]").hasMatch(this);
    return isMatch;
  }

  /// Check  whether a string is digit or not
  /// ```dart
  /// '123'.isDigit(); // false
  /// '123.456'.isDigit(); // false
  /// 'abc'.isDigit(); // false
  /// '123abc'.isDigit(); // false
  /// ```
  bool get isDigit {
    final isMatch = RegExp(r'\d').hasMatch(this);
    return isMatch && length == 1;
  }

  /// 是否包含中文
  bool get isChinese => RegExp('[\u4e00-\u9fa5]').hasMatch(this);

  /// 是否是小数
  bool get isLetter => RegExp("[A-Za-z]").hasMatch(this);

  /// Check if string is json decode
  bool get isJson {
    try {
      jsonDecode();
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  /// Format: 'aabbcc' or 'ffaabbcc' with an optional leading '#'.
  Color get fromHex {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ExtensionStringUnsafe on String? {
  /// null 或者 empty 返回 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 不为 null 且不为 empty 返回true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}
