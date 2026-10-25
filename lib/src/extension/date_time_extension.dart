import 'dart:async';

import 'package:fl_extended/fl_extended.dart';

/// 日期时间格式化精度
enum DateTimeDist {
  /// 2020-01-01 00:00:00.000
  yearMillisecond,

  /// 2020-01-01 00:00:00
  yearSecond,

  /// 2020-01-01 00:00
  yearMinute,

  /// 2020-01-01 00
  yearHour,

  /// 2020-01-01
  yearDay,

  /// 2020-01
  yearMonth,

  /// 01-01 00:00:00.00
  monthMillisecond,

  /// 01-01 00:00:00
  monthSecond,

  /// 01-01 00:00
  monthMinute,

  /// 01-01 00
  monthHour,

  /// 01-01
  monthDay,

  /// 01 00:00:00.000
  dayMillisecond,

  /// 01 00:00:00
  daySecond,

  /// 01 00:00
  dayMinute,

  /// 01 00
  dayHour,

  /// 00:00:00.000
  hourMillisecond,

  /// 00:00:00
  hourSecond,

  /// 00:00
  hourMinute,
}

/// [DateTime] 扩展
extension ExtensionDateTime on DateTime {
  /// 按 [dist] 格式化为字符串；[dual] 为 true 时月日时分等补零
  String format([DateTimeDist? dist, bool dual = true]) {
    final DateTime date = this;
    dist ??= DateTimeDist.yearSecond;
    final String year = date.year.toString();
    final String month = dual ? date.month.padLeft(2, '0') : date.month.toString();
    final String day = dual ? date.day.padLeft(2, '0') : date.day.toString();
    final String hour = dual ? date.hour.padLeft(2, '0') : date.hour.toString();
    final String minute = dual ? date.minute.padLeft(2, '0') : date.minute.toString();
    final String second = dual ? date.second.padLeft(2, '0') : date.second.toString();
    final String millisecond = dual ? date.millisecond.toString().padLeft(3, '0') : date.millisecond.toString();
    // final String microsecond =
    //     dual ? date.microsecond.padLeft(2, '0') : date.microsecond.toString();
    switch (dist) {
      case DateTimeDist.yearMillisecond:
        return '$year-$month-$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.yearSecond:
        return '$year-$month-$day $hour:$minute:$second';
      case DateTimeDist.yearMinute:
        return '$year-$month-$day $hour:$minute';
      case DateTimeDist.yearHour:
        return '$year-$month-$day $hour';
      case DateTimeDist.yearDay:
        return '$year-$month-$day';
      case DateTimeDist.yearMonth:
        return '$year-$month';
      case DateTimeDist.monthMillisecond:
        return '$month-$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.monthSecond:
        return '$month-$day $hour:$minute:$second';
      case DateTimeDist.monthMinute:
        return '$month-$day $hour:$minute';
      case DateTimeDist.monthHour:
        return '$month-$day $hour';
      case DateTimeDist.monthDay:
        return '$month-$day';
      case DateTimeDist.dayMillisecond:
        return '$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.daySecond:
        return '$day $hour:$minute:$second';
      case DateTimeDist.dayMinute:
        return '$day $hour:$minute';
      case DateTimeDist.dayHour:
        return '$day $hour';
      case DateTimeDist.hourMillisecond:
        return '$hour:$minute:$second.$millisecond';
      case DateTimeDist.hourSecond:
        return '$hour:$minute:$second';
      case DateTimeDist.hourMinute:
        return '$hour:$minute';
    }
  }

  /// 是否为闰年
  bool get isLeapYearByYear => year % 4 == 0 && year % 100 != 0 || year % 400 == 0;

  /// 获取从当前日期到 [endDate]（含）的所有日期
  ///
  /// 只比较年月日，返回的每一项时间部分均为 00:00:00；按自然日递增，避免 DST 导致的 23/25 小时问题。
  List<DateTime> getDaysForRange(DateTime endDate) {
    final List<DateTime> result = <DateTime>[];
    final DateTime end = DateTime(endDate.year, endDate.month, endDate.day);
    DateTime date = DateTime(year, month, day);
    while (!date.isAfter(end)) {
      result.add(date);
      date = DateTime(date.year, date.month, date.day + 1);
    }
    return result;
  }
}

extension ExtensionDuration on Duration {
  /// 延迟执行；可选回调
  ///
  /// 示例：
  /// ```dart
  /// final delay = 3.seconds;
  /// await delay.delayed();
  /// ```
  Future<T> delayed<T>([FutureOr<T> Function()? callback]) => Future<T>.delayed(this, callback);

  /// 创建一次性 [Timer]
  Timer timer([void Function()? function]) {
    late Timer timer;
    timer = Timer(this, () {
      if (function != null) function();
      timer.cancel();
    });
    return timer;
  }

  /// 创建周期性 [Timer]（需手动取消）
  Timer timerPeriodic(void Function(Timer timer) callback) => Timer.periodic(this, (Timer time) => callback(time));

  /// 格式化为以毫秒结尾的字符串
  String get toEndMilliseconds => toString().removeSuffixLength(3);

  /// 格式化为以秒结尾的字符串
  String get toEndSeconds => toString().removeSuffixLength(7);

  /// 格式化为以分结尾的字符串
  String get toEndMinutes => toString().removeSuffixLength(10);

  /// 格式化为以时结尾的字符串
  String get toEndHours => toString().removeSuffixLength(13);

  /// 加上时长，返回新 [Duration]
  Duration add(Duration duration, [Duration? secondDuration]) =>
      Duration(microseconds: inMicroseconds + duration.inMicroseconds + (secondDuration?.inMicroseconds ?? 0));

  /// 减去时长，结果不小于 0
  Duration subtract(Duration duration, [Duration? secondDuration]) {
    int s = inMicroseconds - duration.inMicroseconds - (secondDuration?.inMicroseconds ?? 0);
    if (s < 0) s = 0;
    return Duration(microseconds: s);
  }
}
