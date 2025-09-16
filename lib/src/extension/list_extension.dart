import 'dart:convert';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/foundation.dart';

extension ExtensionUint8List on Uint8List {
  List<int> bit32ListFromUInt8List() {
    final Uint8List bytes = this;
    final int additionalLength = bytes.length % 4 > 0 ? 4 : 0;
    final List<int> result = (bytes.length ~/ 4 + additionalLength).generate((_) => 0);
    for (int i = 0; i < bytes.length; i++) {
      final int resultIdx = i ~/ 4;
      final int bitShiftAmount = (3 - i % 4).toInt();
      result[resultIdx] |= bytes[i] << bitShiftAmount;
    }
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i] << 24;
    }
    return result;
  }
}

extension ExtensionListUnsafe on List? {
  /// null 或者 Empty 返回 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 不为 null 且不为 empty 返回true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}

extension ExtensionList<T> on List<T> {
  /// List.generate((index)=>E);
  List<E> generate<E>(E Function(int index) generator, {bool growable = true}) =>
      length.generate<E>((int index) => generator(index), growable: growable);

  /// list.map.toList()
  List<E> mapToList<E>(E Function(T) builder) => map<E>((T e) => builder(e)).toList();

  /// List.generate((index)=>E);
  List<E> builder<E>(E Function(T) builder) => generate((int index) => builder(this[index]));

  /// list.asMap().entries.map.toList()
  List<E> asMapEntriesMapToList<E>(E Function(MapEntry<int, T>) builder) =>
      asMap().entries.map((MapEntry<int, T> entry) => builder(entry)).toList();

  /// list.asMap().entries.map
  Iterable<E> asMapEntriesMap<E>(E Function(MapEntry<int, T>) builder) =>
      asMap().entries.map((MapEntry<int, T> entry) => builder(entry));

  /// `List.generate((index)=>MapEntry<int,T>)`;
  List<E> builderIV<E>(E Function(int, T) builder) => generate((int index) => builder(index, this[index]));

  /// `List.generate((index)=>MapEntry<int,T>)`;
  List<E> builderEntry<E>(E Function(MapEntry<int, T>) builder) =>
      generate((int index) => builder(MapEntry(index, this[index])));

  /// 添加子元素 并返回 新数组
  List<T> addT(T value, {bool isAdd = true}) {
    if (isAdd) add(value);
    return this;
  }

  /// 添加数组 并返回 新数组
  List<T> addAllT(List<T> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// 插入子元素 并返回 新数组
  List<T> insertT(int index, T value, {bool isInsert = true}) {
    if (isInsert) insert(index, value);
    return this;
  }

  /// 插入数组 并返回 新数组
  List<T> insertAllT(int index, List<T> iterable, {bool isInsert = true}) {
    if (isInsert) insertAll(index, iterable);
    return this;
  }

  /// 替换指定区域 返回 新数组
  List<T> replaceRangeT(int start, int end, Iterable<T> replacement, {bool isReplace = true}) {
    if (isReplace) replaceRange(start, end, replacement);
    return this;
  }

  /// list 切片
  List<T> slice(int start, [int? end]) {
    if (end != null && end > length) end = length;
    return sublist(start, end);
  }

  /// 创建一个新的 List，并在遍历过程中移除元素
  void removeElement(bool Function(T element) test) {
    final list = List.from(this);
    for (final element in list) {
      final result = test(element);
      if (result) remove(element);
    }
    list.clear();
  }

  /// 根据索引安全获取元素，索引无效时返回null
  T? getElementOrNull(int index) {
    /// 检查索引是否在有效范围内
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// 安全获取元素
  /// 数组为空时返回null
  /// 索引 >= 数组长度时返回最后一个元素
  /// 索引 < 0 时返回第一个元素
  T? getElementSafe(int index) {
    /// 数组为空时返回null
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
  /// 移出首尾的括号 转换为字符串
  String get toStringRemoveBracket => toString().removeSuffix(']').removePrefix('[').replaceAll(' ', '');
}

extension ExtensionListInt on List<int> {
  /// base64.encode()
  String base64Encode() => base64.encode(this);

  /// base64Url.encode()
  String base64UrlEncode() => base64Url.encode(this);

  /// utf8.decode()
  String utf8Decode({bool? allowMalformed}) => utf8.decode(this, allowMalformed: allowMalformed);

  /// ascii.decode()
  String asciiDecode({bool? allowInvalid}) => ascii.decode(this, allowInvalid: allowInvalid);

  /// latin1.decode()
  String latin1Decode({bool? allowInvalid}) => latin1.decode(this, allowInvalid: allowInvalid);

  Uint8List? get uInt8ListFrom32BitList {
    final Uint8List result = Uint8List(length * 4);
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < 4; j++) {
        result[i * 4 + j] = this[i] >> (j * 8);
      }
    }
    return result;
  }

  /// `List<int>` to Utf8
  String get toUtf8 => String.fromCharCodes(
    length.generate((int i) {
      return ((this[i >> 2]).toSigned(32) >> (24 - (i % 4) * 8)) & 0xff;
    }),
  );
}
