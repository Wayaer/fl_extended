import 'package:collection/collection.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/foundation.dart';

/// [switch] 的增强版：支持比较各类基础值，以及 [List]、[Map]、[Set]、[Iterable]。
/// 当 [conditionMap] 的 key 中存在与 [value] 深度相等的项时，执行对应 [ValueGetter] 并返回结果。
///
/// 示例：
/// ```dart
/// T? kind = whenValue<T>(
///   V,
///   {
///     V: () {
///       return T;
///     },
///     V: () {
///       return T;
///     },
///     V: () {
///       return T;
///     },
///   },
/// );
/// ```
T? whenValue<V, T>(V value, Map<V, ValueGetter<T>> conditionMap) {
  return conditionMap.entries
      .firstOrNullWhere((element) => const DeepCollectionEquality().equals(element.key, value))
      ?.value();
}

/// Kotlin 风格的 when：在 [conditionMap] 的 key 中找到第一个为 `true` 的项，立即执行对应 [ValueGetter] 并返回。
/// 未找到则返回 null；若需默认值，可在 Map 末尾加入 key 为 `true` 的条目。
///
/// 注意：受 [Map] 特性影响，需保证 [conditionMap] 中不会出现多个为 `true` 的 key。
/// 无法保证时建议使用 [whenTrue] 或 [whenBool]，避免逻辑异常。
///
/// 示例：
/// ```dart
/// String? winner = when<String>({
///   "Dart is Language".contains("UI"): () {
///     return "Flutter";
///   },
///   "Flutter is UI Framework".contains("UI"): () {
///     return "Flutter";
///   },
/// });
/// ```
T? when<T>(Map<bool, ValueGetter<T>> conditionMap) {
  for (final MapEntry<bool, ValueGetter<T>> element in conditionMap.entries) {
    if (element.key) {
      return element.value();
    }
  }
  return null;
}

/// Kotlin 风格的 when：条件为惰性计算的 [ValueGetter]。
/// 按顺序执行 [conditionMap] 的 key，第一个返回 `true` 时立即执行对应 [ValueGetter] 并返回。
/// 未找到则返回 null；若需默认值，可在 Map 末尾加入恒为 true 的条件。
///
/// 示例：
/// ```dart
///String? something = whenTrue<String>({
///      () {
///    if (1 + 100 * 1000 < 2000) {
///      return false;
///    } else if ("Who is my lovely baby?".length > 10) {
///      return true;
///    } else {
///      return false;
///    }
///  }: () {
///    return "Test OK";
///  },
///      () {
///    return int.tryParse("3.14*") != null;
///  }: () {
///    return "PI get";
///  }
///});
/// ```
T? whenTrue<T>(Map<ValueGetter<bool>, ValueGetter<T>> conditionMap) {
  for (final MapEntry<ValueGetter<bool>, ValueGetter<T>> element in conditionMap.entries) {
    if (element.key.call()) {
      return element.value();
    }
  }
  return null;
}
