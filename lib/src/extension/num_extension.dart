import 'dart:math' as math;
import 'dart:math';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// num 扩展
extension ExtensionNum on num {
  /// 取与 [value] 的较大值
  ///
  /// 返回 [num]，同时支持 int 与 double 混合比较。
  num max(num value) => math.max(this, value);

  /// 取与 [value] 的较小值
  ///
  /// 返回 [num]，同时支持 int 与 double 混合比较。
  num min(num value) => math.min(this, value);

  /// 转为 [BigInt]
  BigInt get toBigInt => BigInt.from(this);

  /// 余弦
  double get cos => math.cos(this);

  /// 正切
  double get tan => math.tan(this);

  /// 反余弦
  double get acos => math.acos(this);

  /// 反正弦
  double get asin => math.asin(this);

  /// 平方根
  double get sqrt => math.sqrt(this);

  /// e 的幂
  double get exp => math.exp(this);

  /// 自然对数
  double get ln => math.log(this);

  /// 反正切（二元）
  double atan2(num value) => math.atan2(this, value);

  /// 复制到剪贴板
  Future<void> toClipboard() => Clipboard.setData(ClipboardData(text: toString()));

  /// 生成指定长度的 List
  List<T> generate<T>(T Function(int index) generator, {bool growable = true}) =>
      List<T>.generate(toInt(), (int index) => generator(index), growable: growable);

  /// 左侧填充至指定宽度
  String padLeft(int width, [String padding = ' ']) => toString().padLeft(width, padding);

  /// 数字字符串长度
  int get length => toString().length;

  /// 微秒时间戳转 [DateTime]
  DateTime fromMicrosecondsSinceEpoch({bool isUtc = false}) =>
      DateTime.fromMicrosecondsSinceEpoch(toInt(), isUtc: isUtc);

  /// 毫秒时间戳转 [DateTime]
  DateTime fromMillisecondsSinceEpoch({bool isUtc = false}) =>
      DateTime.fromMillisecondsSinceEpoch(toInt(), isUtc: isUtc);

  /// 在指定位置插入；[element] 为 String 时返回 String，为 num 时保持原 num 类型
  dynamic insert(int index, dynamic element) {
    if (element is! num && element is! String) return this;
    if (element is String) {
      return toString().insert(index, element);
    } else {
      final String data = toString().insert(index, (element as num).toInt().toString());
      if (this is int) return num.parse(data).toInt();
      if (this is double) return num.parse(data).toDouble();
    }
    return this;
  }

  /// 是否包含 [other]（按字符串匹配；从 [startIndex] 开始）
  bool contains(Pattern other, [int startIndex = 0]) => toString().contains(other, startIndex);

  /// 微秒
  Duration get microseconds => Duration(microseconds: round());

  /// 毫秒
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  /// 秒
  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  /// 分
  Duration get minutes => Duration(seconds: (this * Duration.secondsPerMinute).round());

  /// 时
  Duration get hours => Duration(minutes: (this * Duration.minutesPerHour).round());

  /// 天
  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());

  /// 字节数格式化为 B/KB/MB/GB/TB/PB
  ///
  /// 示例：
  /// ```dart
  /// 1024.toFileSize();        // 1KB
  /// 1536.toFileSize();        // 1.5KB
  /// 1099511627776.toFileSize(); // 1TB
  /// ```
  String toFileSize() {
    const List<String> units = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    if (this < 0) return '${this}B';
    double size = toDouble();
    int unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    if (unit == 0) return '${this}B';
    final String text = size.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
    return '$text${units[unit]}';
  }

  /// 数字转中文（简/繁）；[isWeek] 时 7 显示为「日」
  String toChineseNumbers({bool isSimplify = true, bool isWeek = false}) {
    switch (toInt()) {
      case 0:
        return isSimplify ? '〇' : '零';
      case 1:
        return isSimplify ? '一' : '壹';
      case 2:
        return isSimplify ? '二' : '贰';
      case 3:
        return isSimplify ? '三' : '叁';
      case 4:
        return isSimplify ? '四' : '肆';
      case 5:
        return isSimplify ? '五' : '伍';
      case 6:
        return isSimplify ? '六' : '陆';
      case 7:
        return isSimplify
            ? isWeek
                  ? '日'
                  : '七'
            : '柒';
      case 8:
        return isSimplify ? '八' : '捌';
      case 9:
        return isSimplify ? '九' : '玖';
      case 10:
        return isSimplify ? '十' : '拾';
    }
    return toString();
  }

  /// 是否为偶数
  bool get isEven => this % 2 == 0;

  /// 是否为奇数
  bool get isOdd => this % 2 != 0;

  /// 是否为正数
  bool get isPositive => this > 0;

  /// 是否为负数
  bool get isNegative => this < 0;

  /// 转为宽为该值的 [SizedBox]
  Widget get widthBox => SizedBox(width: toDouble());

  /// 转为高为该值的 [SizedBox]
  Widget get heightBox => SizedBox(height: toDouble());

  /// 转为宽高均为该值的 [SizedBox]
  Widget get squareBox => SizedBox(height: toDouble(), width: toDouble());

  /// 转为 [Offset]
  Offset get offsetX => Offset(toDouble(), 0);

  /// 转为 [Offset]
  Offset get offsetY => Offset(0, toDouble());

  /// 转为 [Offset]
  Offset get offset => Offset(toDouble(), toDouble());

  /// 转为 [EdgeInsets.all]
  EdgeInsets get edgeInsetsAll => EdgeInsets.all(toDouble());

  /// 转为仅左侧的 [EdgeInsets]
  EdgeInsets get edgeInsetsLeft => EdgeInsets.only(left: toDouble());

  /// 转为仅右侧的 [EdgeInsets]
  EdgeInsets get edgeInsetsRight => EdgeInsets.only(right: toDouble());

  /// 转为仅顶部的 [EdgeInsets]
  EdgeInsets get edgeInsetsTop => EdgeInsets.only(top: toDouble());

  /// 转为仅底部的 [EdgeInsets]
  EdgeInsets get edgeInsetsBottom => EdgeInsets.only(bottom: toDouble());

  /// 转为对称 [EdgeInsets]
  EdgeInsets get edgeInsetsSymmetric => EdgeInsets.symmetric(horizontal: toDouble(), vertical: toDouble());

  /// 转为水平对称 [EdgeInsets]
  EdgeInsets get edgeInsetsHorizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromL => EdgeInsets.fromLTRB(toDouble(), 0, 0, 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromT => EdgeInsets.fromLTRB(0, toDouble(), 0, 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromR => EdgeInsets.fromLTRB(0, 0, toDouble(), 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromB => EdgeInsets.fromLTRB(0, 0, 0, toDouble());

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromLR => EdgeInsets.fromLTRB(toDouble(), 0, toDouble(), 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromTB => EdgeInsets.fromLTRB(0, toDouble(), 0, toDouble());

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromLT => EdgeInsets.fromLTRB(toDouble(), toDouble(), 0, 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromLB => EdgeInsets.fromLTRB(toDouble(), 0, 0, toDouble());

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromRT => EdgeInsets.fromLTRB(0, toDouble(), toDouble(), 0);

  /// 转为 [EdgeInsets.fromLTRB]
  EdgeInsets get fromRB => EdgeInsets.fromLTRB(0, 0, toDouble(), toDouble());

  /// 转为垂直对称 [EdgeInsets]
  EdgeInsets get edgeInsetsVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectional => EdgeInsetsDirectional.all(toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalStart => EdgeInsetsDirectional.only(start: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalEnd => EdgeInsetsDirectional.only(end: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalTop => EdgeInsetsDirectional.only(top: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalBottom => EdgeInsetsDirectional.only(bottom: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalHorizontal => EdgeInsetsDirectional.symmetric(horizontal: toDouble());

  /// 转为 [EdgeInsetsDirectional]
  EdgeInsetsDirectional get edgeInsetsDirectionalVertical => EdgeInsetsDirectional.symmetric(vertical: toDouble());

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusAll => BorderRadius.all(Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusTopLeft => BorderRadius.only(topLeft: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusTopRight => BorderRadius.only(topRight: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusBottomLeft => BorderRadius.only(bottomLeft: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusBottomRight => BorderRadius.only(bottomRight: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusLeft => BorderRadius.horizontal(left: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusRight => BorderRadius.horizontal(right: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusTop => BorderRadius.vertical(top: Radius.circular(toDouble()));

  /// 转为 [BorderRadius]
  BorderRadius get borderRadiusBottom => BorderRadius.vertical(bottom: Radius.circular(toDouble()));
}

/// int 扩展
extension ExtensionInt on int {
  /// 字节数格式化为 B/KB/MB/GB/TB/PB
  ///
  /// 四舍五入后若达到下一单位边界会自动进位，避免出现 `1024.00 KB`。
  ///
  /// 示例：
  /// ```dart
  /// 1024.toStorageUnit();      // 1 KB
  /// 1536.toStorageUnit();      // 1.5 KB
  /// 1048575.toStorageUnit();   // 1 MB
  /// ```
  String toStorageUnit([int round = 2]) {
    const int divider = 1024;
    const List<String> units = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final bool negative = this < 0;
    double size = abs().toDouble();
    int unit = 0;
    while (size >= divider && unit < units.length - 1) {
      size /= divider;
      unit++;
    }
    if (unit == 0) return '$this B';

    String text = size.toStringAsFixed(round);
    if (double.parse(text) >= divider && unit < units.length - 1) {
      size /= divider;
      unit++;
      text = size.toStringAsFixed(round);
    }
    final String value = text.contains('.') ? text.replaceFirst(RegExp(r'\.?0+$'), '') : text;
    return '${negative ? '-' : ''}$value ${units[unit]}';
  }

  /// `[0, this)` 的随机整数；`this <= 0` 时返回 0
  int get random {
    if (this <= 0) return 0;
    return _random.nextInt(this);
  }
}

final Random _random = Random();
