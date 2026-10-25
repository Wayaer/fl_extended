import 'dart:convert';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/foundation.dart';

extension ExtensionUint8List on Uint8List {
  /// 按大端序每 4 字节打包为 32 位整数列表
  List<int> bit32ListFromUInt8List() {
    final Uint8List bytes = this;
    final int wordCount = (bytes.length + 3) ~/ 4;
    final List<int> result = List<int>.filled(wordCount, 0);
    for (int i = 0; i < bytes.length; i++) {
      result[i ~/ 4] |= (bytes[i] & 0xff) << (24 - (i % 4) * 8);
    }
    return result;
  }
}

extension ExtensionListUnsafe on List? {
  /// null 或 empty 为 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 非 null 且非 empty 为 true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}

extension ExtensionList<T> on List<T> {
  /// 对应 [List.generate]
  List<E> generate<E>(E Function(int index) generator, {bool growable = true}) =>
      length.generate<E>((int index) => generator(index), growable: growable);

  /// [map] 后转为 [List]
  List<E> mapToList<E>(E Function(T) builder) => map<E>((T e) => builder(e)).toList();

  /// 按元素构建新列表
  List<E> builder<E>(E Function(T) builder) => generate((int index) => builder(this[index]));

  /// [asMap].entries.map 后转为 [List]
  List<E> asMapEntriesMapToList<E>(E Function(MapEntry<int, T>) builder) =>
      asMap().entries.map((MapEntry<int, T> entry) => builder(entry)).toList();

  /// [asMap].entries.map
  Iterable<E> asMapEntriesMap<E>(E Function(MapEntry<int, T>) builder) =>
      asMap().entries.map((MapEntry<int, T> entry) => builder(entry));

  /// 按索引与元素构建新列表
  List<E> builderIV<E>(E Function(int, T) builder) => generate((int index) => builder(index, this[index]));

  /// 按 [MapEntry] 构建新列表
  List<E> builderEntry<E>(E Function(MapEntry<int, T>) builder) =>
      generate((int index) => builder(MapEntry(index, this[index])));

  /// 添加元素后返回自身
  List<T> addT(T value, {bool isAdd = true}) {
    if (isAdd) add(value);
    return this;
  }

  /// 添加数组后返回自身
  List<T> addAllT(List<T> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// 插入元素后返回自身
  List<T> insertT(int index, T value, {bool isInsert = true}) {
    if (isInsert) insert(index, value);
    return this;
  }

  /// 插入数组后返回自身
  List<T> insertAllT(int index, List<T> iterable, {bool isInsert = true}) {
    if (isInsert) insertAll(index, iterable);
    return this;
  }

  /// 替换指定区间后返回自身
  List<T> replaceRangeT(int start, int end, Iterable<T> replacement, {bool isReplace = true}) {
    if (isReplace) replaceRange(start, end, replacement);
    return this;
  }

  /// 切片；[start]、[end] 会被收敛到合法范围
  List<T> slice(int start, [int? end]) {
    final int from = start.clamp(0, length).toInt();
    final int to = (end ?? length).clamp(from, length).toInt();
    return sublist(from, to);
  }

  /// 遍历中按条件移除元素
  void removeElement(bool Function(T element) test) {
    removeWhere(test);
  }

  /// 按索引安全取元素，越界返回 null
  T? getElementOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// 安全取元素：空返回 null；越界取末项；负索引取首项
  T? getElementSafe(int index) {
    if (isEmpty) return null;
    if (index >= length) {
      return last;
    } else if (index < 0) {
      return first;
    } else {
      return this[index];
    }
  }
}

extension ExtensionListString on List<String> {
  /// 去掉首尾括号后转为字符串
  String get toStringRemoveBracket => toString().removeSuffix(']').removePrefix('[').replaceAll(' ', '');
}

extension ExtensionListInt on List<int> {
  /// 对应 [base64.encode]
  String base64Encode() => base64.encode(this);

  /// 对应 [base64Url.encode]
  String base64UrlEncode() => base64Url.encode(this);

  /// 对应 [utf8.decode]
  String utf8Decode({bool? allowMalformed}) => utf8.decode(this, allowMalformed: allowMalformed);

  /// 对应 [ascii.decode]
  String asciiDecode({bool? allowInvalid}) => ascii.decode(this, allowInvalid: allowInvalid);

  /// 对应 [latin1.decode]
  String latin1Decode({bool? allowInvalid}) => latin1.decode(this, allowInvalid: allowInvalid);

  /// 将大端序 32 位整数列表还原为字节（与 [bit32ListFromUInt8List] 对应）
  ///
  /// [byteLength] 为原始字节长度；省略时按 `length * 4` 返回（可能包含补齐的 0 字节）。
  Uint8List uInt8ListFrom32BitList([int? byteLength]) {
    final int maxLength = length * 4;
    if (byteLength != null && (byteLength < 0 || byteLength > maxLength)) {
      throw ArgumentError.value(byteLength, 'byteLength', 'must be between 0 and $maxLength');
    }
    final int resultLength = byteLength ?? maxLength;
    final Uint8List result = Uint8List(resultLength);
    for (int i = 0; i < length && i * 4 < resultLength; i++) {
      for (int j = 0; j < 4; j++) {
        final int index = i * 4 + j;
        if (index >= resultLength) break;
        result[index] = (this[i] >> (24 - j * 8)) & 0xff;
      }
    }
    return result;
  }

  /// 按 UTF-8 解码为字符串
  String get toUtf8 => utf8.decode(this, allowMalformed: true);
}
