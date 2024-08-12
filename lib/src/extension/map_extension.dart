extension ExtensionMap<K, V> on Map<K, V> {
  List<K> keysList({bool growable = true}) => keys.toList(growable: growable);

  List<V> valuesList({bool growable = true}) =>
      values.toList(growable: growable);

  ///  entries.map()
  Iterable<E> entriesMapKV<E>(E Function(K, V) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry.key, entry.value));

  ///  entries.map().toList()
  List<E> entriesMapKVToList<E>(E Function(K, V) builder) => entries
      .map((MapEntry<K, V> entry) => builder(entry.key, entry.value))
      .toList();

  /// entries.map()
  Iterable<E> entriesMap<E>(E Function(MapEntry<K, V>) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry));

  /// entries.map().toList()
  List<E> entriesMapToList<E>(E Function(MapEntry<K, V>) builder) =>
      entries.map((MapEntry<K, V> entry) => builder(entry)).toList();

  /// addAll map 并返回 新map
  Map<K, V> addAllT(Map<K, V> iterable, {bool isAdd = true}) {
    if (isAdd) addAll(iterable);
    return this;
  }

  /// update map 并返回 新map
  Map<K, V> updateAllT(V Function(K key, V value) update,
      {bool isUpdate = true}) {
    if (isUpdate) updateAll(update);
    return this;
  }

  /// update map 并返回 新map
  Map<K, V> updateT(K key, V Function(V value) update,
      {V Function()? ifAbsent, bool isUpdate = true}) {
    if (isUpdate) this.update(key, update, ifAbsent: ifAbsent);
    return this;
  }

  /// Map<dynamic,dynamic> to Map<String,dynamic>
  Map<String, dynamic> get keyToString {
    Map<String, dynamic> resultMap = {};
    forEach((key, value) {
      if (value is Map) {
        resultMap[key.toString()] = value.keyToString;
      } else if (value is List<Map> && value.isNotEmpty) {
        resultMap[key.toString()] = value.keyToString;
      } else {
        resultMap[key.toString()] = value;
      }
    });
    return resultMap;
  }
}

extension ExtensionListMap on List<Map> {
  /// List<Map> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> get keyToString {
    List<Map<String, dynamic>> resultMap = [];
    forEach((element) {
      resultMap.add(element.keyToString);
    });
    return resultMap;
  }
}

extension ExtensionMapUnsafe on Map? {
  /// null 或者 Empty 返回 true
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// 不为 null 且不为 empty 返回true
  bool get isNotEmptyOrNull => !isEmptyOrNull;
}
