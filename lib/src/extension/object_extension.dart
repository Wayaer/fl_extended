import 'dart:convert';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// 可主动 [notify] 的 [ValueNotifier]
class ValueNotifiers<T> extends ValueNotifier<T> {
  ValueNotifiers(super.value);

  void notify() {
    notifyListeners();
  }
}

/// 打印日志
void log<T>(T msg) => msg.log();

extension ExtensionT<T> on T {
  /// 非 null 时执行 [operation] 并返回结果，否则返回 null
  E? let<E>(E Function(T it) operation) {
    if (this != null) {
      return operation(this);
    }
    return null;
  }

  /// 非 null 时执行 [operation]，并返回自身
  T also(void Function(T it) operation) {
    if (this != null) {
      operation(this!);
    }
    return this;
  }

  /// 是否为 null
  bool get isNull => this == null;

  /// 是否非 null
  bool get isNotNull => this != null;

  /// 转为 [ValueNotifier]
  ValueNotifier<T> get notifier => ValueNotifier<T>(this);

  /// 包装为单元素 List
  List<T> get toList => [this];

  /// Debug/Profile 下打印日志；[crossLine] 控制是否打印分隔线
  void log({bool? crossLine}) {
    if (!(kDebugMode || kProfileMode)) return;
    final dynamic msg = this;
    crossLine ??= FlExtended().logCrossLine;
    final String message = msg.toString();
    if (crossLine) {
      debugPrint('┌------------------------------------------------------------------------------');
    }
    const int limitLength = 800;
    for (int start = 0; start < message.length; start += limitLength) {
      final int end = start + limitLength > message.length ? message.length : start + limitLength;
      debugPrint(message.substring(start, end));
    }
    if (crossLine) {
      debugPrint('└------------------------------------------------------------------------------');
    }
  }
}

extension ExtensionObject on Object {
  /// [json.encode]
  String jsonEncode({Object? Function(Object? nonEncodable)? toEncodable}) =>
      json.encode(this, toEncodable: toEncodable);
}

extension ExtensionSize on Size {
  /// 按 [p] 缩放宽高
  Size scaling({double p = 1}) => Size(width / p, height / p);
}

extension ExtensionBool on bool {
  /// 取反
  bool get toggle => !this;

  /// 转为 int（true→1，false→0）
  int get toInt => this ? 1 : 0;
}
