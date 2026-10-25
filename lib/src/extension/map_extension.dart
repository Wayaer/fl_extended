import 'dart:collection';

import 'package:fl_extended/fl_extended.dart';

extension ExtensionMap<K, V> on Map<K, V> {
  /// 将 keys 转为 List
  List<K> keysList({bool growable = true}) => keys.toList(growable: growable);

  /// 将 values 转为 List
  List<V> valuesList({bool growable = true}) => values.toList(growable: growable);

  /// 对 entries 做 map，回调接收 key、value
  Iterable<E> entriesMapKV<E>(E Function(K, V) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry.key, entry.value));

  /// 对 entries 做 map 并转为 List，回调接收 key、value
  List<E> entriesMapKVToList<E>(E Function(K, V) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry.key, entry.value)).toList();

  /// 对 entries 做 map，回调接收 [MapEntry]
  Iterable<E> entriesMap<E>(E Function(MapEntry<K, V>) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry));

  /// 对 entries 做 map 并转为 List，回调接收 [MapEntry]
  List<E> entriesMapToList<E>(E Function(MapEntry<K, V>) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry)).toList();

  /// 条件 [addAll]，返回当前 map
  Map<K, V> addAllT(Map<K, V> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// 条件 [updateAll]，返回当前 map
  Map<K, V> updateAllT(V Function(K key, V value) update, {bool isUpdate = true}) {
    if (isUpdate) updateAll(update);
    return this;
  }

  /// 条件 [update]，返回当前 map
  Map<K, V> updateT(K key, V Function(V value) update, {V Function()? ifAbsent, bool isUpdate = true}) {
    if (isUpdate) this.update(key, update, ifAbsent: ifAbsent);
    return this;
  }

  /// 将 key 递归转为 String（支持嵌套 Map / List / Iterable）
  Map<String, dynamic> get keyToString => _stringifyKeys(this) as Map<String, dynamic>;
}

dynamic _stringifyKeys(dynamic value, [Set<Object>? path]) {
  if (value is Map || value is Iterable) {
    final Set<Object> ancestors = path ?? HashSet<Object>.identity();
    if (!ancestors.add(value)) {
      throw ArgumentError.value(value, 'value', 'Cannot convert a cyclic Map / Iterable to String keys.');
    }
    try {
      if (value is Map) {
        return value.map(
          (dynamic key, dynamic item) => MapEntry<String, dynamic>(key.toString(), _stringifyKeys(item, ancestors)),
        );
      }
      return value.map((dynamic item) => _stringifyKeys(item, ancestors)).toList();
    } finally {
      ancestors.remove(value);
    }
  }
  return value;
}

extension ExtensionListMap on List<Map> {
  /// 将 `List<Map>` 转为 `List<Map<String, dynamic>>`（key 转 String）
  List<Map<String, dynamic>> get keyToString => builder((element) => element.keyToString);
}

extension ExtensionMapUnsafe on Map? {
  /// null 或 empty 返回 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 非 null 且非 empty 返回 true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}
