import 'dart:math';

final Random _iterableRandom = Random();

/// [Iterable] 实用扩展
extension ExtensionIterableE<E> on Iterable<E> {
  /// [Iterable.map] 后转为 List
  List<T> builder<T>(T Function(E) builder) => map<T>((E e) => builder(e)).toList();

  /// [Iterable.every] 的别名
  bool all(bool Function(E element) test) => every(test);

  /// 若没有任何元素满足 [test] 则返回 true
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].none((e) => e > 4); // true
  /// [1, 2, 3].none((e) => e > 2); // false
  /// ```
  bool none(bool Function(E element) test) => !any(test);

  /// 恰好有一个元素满足 [test] 时返回 true
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].one((e) => e == 2); // true
  /// [1, 2, 3].one((e) => e > 4); // false
  /// [1, 2, 3].one((e) => e > 1); // false
  /// ```
  bool one(bool Function(E element) test) {
    bool foundOne = false;
    for (final e in this) {
      if (test(e)) {
        if (foundOne) return false;
        foundOne = true;
      }
    }
    return foundOne;
  }

  /// 若与 [other] 至少有一个公共元素则返回 true
  ///
  /// 惰性实现：找到第一个公共元素即返回。
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].containsAny([5, 2]); // true
  /// [1, 2, 3].containsAny([4, 5, 6]); // false
  /// ```
  bool containsAny(Iterable<E> other) => any(other.contains);

  /// 若 [other] 中每个元素都存在于当前集合则返回 true
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].containsAll([1, 2]); // true
  /// [1, 2].containsAll([1, 2, 3]); // false
  /// ```
  ///
  /// [collapseDuplicates] 为 true 时只比较是否出现过；为 false 时还要求当前集合中
  /// 各值出现次数不少于 [other]。
  ///
  /// 示例：
  /// ```
  /// [1, 2, 3].containsAll([1, 1, 1, 2]); // true
  /// [1, 2, 3].containsAll([1, 1, 1, 2], collapseDuplicates: false); // false
  /// [1, 1, 2, 3].containsAll([1, 1, 2], collapseDuplicates: false); // true
  /// ```
  bool containsAll(Iterable<E> other, {bool collapseDuplicates = true}) {
    if (other.isEmpty) return true;
    if (collapseDuplicates) {
      return Set<E>.from(this).containsAll(Set<E>.from(other));
    }
    final thisElementCounts = _elementCountsIn<E>(this);
    final otherElementCounts = _elementCountsIn<E>(other);
    for (final element in otherElementCounts.keys) {
      final countInThis = thisElementCounts[element] ?? 0;
      if (countInThis < otherElementCounts[element]!) {
        return false;
      }
    }
    return true;
  }

  /// 按 [addend] 累加各元素对应值；空集合返回 0
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
  /// ```
  num sum(num Function(E) addend) {
    if (isEmpty) return 0;
    return fold(0, (prev, element) => prev + addend(element));
  }

  /// 返回第一个满足 [predicate] 的元素；找不到则返回 null
  ///
  /// 示例：
  /// ```dart
  /// final list = ['a', 'Test'];
  /// final firstLong= list.firstOrNullWhere((e) => e.length > 1); // 'Test'
  /// final firstVeryLong = list.firstOrNullWhere((e) => e.length > 5); // null
  /// ```
  E? firstOrNullWhere(bool Function(E element) predicate) {
    for (final element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }
}

extension ExtensionIterableT<T> on Iterable<T> {
  /// 对每个元素应用 [selector] 后求和（int）
  ///
  /// 示例：
  /// ```dart
  /// [2, 4, 6].sumBy((n) => n);                   // 12
  /// ['hello', 'flutter'].sumBy((s) => s.length); // 12
  /// ```
  int sumBy(int Function(T) selector) {
    ArgumentError.checkNotNull(selector, 'selector');
    return map(selector).fold(0, (prev, curr) => prev + curr);
  }

  /// 对每个元素应用 [selector] 后求和（double）
  ///
  /// 示例：
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) {
    ArgumentError.checkNotNull(selector, 'selector');
    return map(selector).fold(0.0, (prev, curr) => prev + curr);
  }

  /// 对每个元素应用 [selector] 后求算术平均值；空集合返回 null
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].averageBy((n) => n);               // 2.0
  /// ['cat', 'horse'].averageBy((s) => s.length); // 4.0
  /// ```
  double? averageBy(num Function(T) selector) {
    ArgumentError.checkNotNull(selector, 'selector');
    if (isEmpty) return null;
    return sumByDouble(selector) / length;
  }

  /// 按 [size] 分块；可选 [fill] 补齐最后一块
  ///
  /// 惰性实现：只遍历一次，可用于很长的迭代器；无限迭代器请自行限制。
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].chunked(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunked(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunked(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunked(int size, {T Function()? fill}) sync* {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be a positive integer greater than 0.');
    }
    final Iterator<T> item = iterator;
    while (true) {
      final List<T> chunk = <T>[];
      while (chunk.length < size && item.moveNext()) {
        chunk.add(item.current);
      }
      if (chunk.isEmpty) return;
      if (fill != null) {
        while (chunk.length < size) {
          chunk.add(fill());
        }
      }
      yield chunk;
    }
  }

  /// 统计满足 [test] 的元素个数；未传 [test] 则统计全部
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3, 13, 14, 15].count();             // 6
  /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  /// ```
  int count([bool Function(T element)? test]) {
    int result = 0;
    for (final element in this) {
      if (test == null || test(element)) result++;
    }
    return result;
  }

  /// 过滤满足 [test] 的元素；[where] 的别名
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3, 4].filter((n) => n < 3).toList(); // [1,2]
  /// ```
  Iterable<T> filter(bool Function(T element) test) {
    ArgumentError.checkNotNull(test, 'test');
    return where(test);
  }

  /// 按迭代顺序对每个元素执行回调，参数为索引与元素
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b', 'c'].forEachIndex((index, value) {
  ///   print('$index : $value'); // '0 : a', '1: b', '2: c'
  /// });
  /// ```
  void forEachIndexed(void Function(int index, T element) funcIndexValue) {
    ArgumentError.checkNotNull(funcIndexValue, 'funcIndexValue');
    int index = 0;
    final item = iterator;
    while (item.moveNext()) {
      funcIndexValue(index++, item.current);
    }
  }

  /// 取第 [index] 个元素；越界则调用 [orElse]
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].elementAtOrElse(2, () => ''); // ''
  /// ```
  T elementAtOrElse(int index, T Function() orElse) {
    RangeError.checkNotNegative(index, 'index');
    ArgumentError.checkNotNull(index);
    ArgumentError.checkNotNull(orElse, 'orElse');
    try {
      return elementAt(index);
    } catch (error) {
      return orElse();
    }
  }

  /// 取第 [index] 个元素；越界返回 null
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].elementAtOrNull(2); // null
  /// ```
  T? elementAtOrNull(int index) {
    if (index < 0) return null;
    int currentIndex = 0;
    for (final element in this) {
      if (currentIndex++ == index) return element;
    }
    return null;
  }

  /// 取首元素；为空则调用 [orElse]
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].firstOrElse(() => ''); // 'a'
  /// [].firstOrElse(() => '');         // ''
  /// ```
  T firstOrElse(T Function() orElse) {
    ArgumentError.checkNotNull(orElse, 'orElse');
    return firstWhere((_) => true, orElse: orElse);
  }

  /// 取首元素；为空返回 null
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].firstOrNull; // 'a'
  /// [].firstOrNull;         // null
  /// ```
  T? get firstOrNull {
    final Iterator<T> item = iterator;
    return item.moveNext() ? item.current : null;
  }

  /// 取末元素；为空则调用 [orElse]
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].lastOrElse(() => ''); // 'b'
  /// [].lastOrElse(() => '');         // ''
  /// ```
  T lastOrElse(T Function() orElse) {
    ArgumentError.checkNotNull(orElse, 'orElse');
    return lastWhere((_) => true, orElse: orElse);
  }

  /// 取末元素；为空返回 null
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'b'].lastOrNull; // 'b'
  /// [].lastOrNull;         // null
  /// ```
  T? get lastOrNull {
    T? result;
    for (final element in this) {
      result = element;
    }
    return result;
  }

  /// 按 [keySelector] 分组；可选 [valueTransform] 映射元素
  ///
  /// 示例：
  /// ```dart
  /// final map = [1, 2, 3, 97, 98, 99].groupBy((n) => n < 10 ? 'smallNumbers' : 'largeNumbers')
  /// // map = {'smallNumbers': [1, 2, 3], 'largeNumbers': [97, 98, 99]}
  /// ```
  ///
  /// ```dart
  /// List<Person> persons = [
  ///     Person(name: 'John', age: 21),
  ///     Person(name: 'Carl', age: 18),
  ///     Person(name: 'Peter', age: 56),
  ///     Person(name: 'Sarah', age: 61)
  /// ];
  /// final map = persons.groupBy((p) => p.age < 40 ? 'young' : 'old',
  ///        valueTransform: (p) => p.name);
  /// // map = {'young': ['John', 'Carl'], 'old': ['Peter', 'Sarah']}
  /// ```
  Map<K, List<V>> groupBy<K, V>(K Function(T element) keySelector, {V Function(T element)? valueTransform}) {
    ArgumentError.checkNotNull(keySelector);
    valueTransform ??= (element) => element as V;
    final map = <K, List<V>>{};
    forEach((element) {
      final key = keySelector(element);
      if (!map.containsKey(key)) map[key] = [];
      map[key]!.add(valueTransform!(element));
    });
    return map;
  }

  /// 由 [transform] 生成 [MapEntry] 组成 Map；相同 key 后者覆盖前者
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].associate((e) => MapEntry('key_$e', e * 100)); // {'key_1': 100, 'key_2': 200, 'key_3': 300}
  /// ```
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T element) transform) {
    ArgumentError.checkNotNull(transform, 'transform');
    return Map.fromEntries(map(transform));
  }

  /// 以 [keySelector] 生成 key，元素本身为 value；相同 key 后者覆盖前者
  ///
  /// 示例：
  /// ```dart
  /// ['a', 'ab', 'abc'].associateBy((e) => e.length); // {1: 'a', 2: 'ab', 3: 'abc'}
  /// ```
  Map<K, T> associateBy<K>(K Function(T element) keySelector) {
    ArgumentError.checkNotNull(keySelector, 'keySelector');
    final map = <K, T>{};
    forEach((element) {
      final key = keySelector(element);
      map[key] = element;
    });
    return map;
  }

  /// 以元素为 key，[valueSelector] 生成 value
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].associateWith((e) => e * 1000); // {1: 1000, 2: 2000, 3: 3000}
  /// ```
  Map<T, V> associateWith<V>(V Function(T element) valueSelector) {
    ArgumentError.checkNotNull(valueSelector, 'valueSelector');
    final map = <T, V>{};
    forEach((element) {
      map[element] = valueSelector(element);
    });
    return map;
  }

  /// 按 [comparator] 取最小值；空集合返回 null
  ///
  /// 示例：
  /// ```dart
  /// [1, 0, 2].minBy((a, b) => a.compareTo(b));       // 0
  /// persons.minBy((a, b) => a.age.compareTo(b.age)); // 最年轻者
  /// ```
  T? minimumBy(Comparator<T> comparator) {
    ArgumentError.checkNotNull(comparator, 'comparator');
    if (isEmpty) return null;
    return reduce((value, element) => comparator(value, element) < 0 ? value : element);
  }

  /// 按 [comparator] 取最大值；空集合返回 null
  ///
  /// 示例：
  /// ```dart
  /// [90, 10, 20, 30].maxBy((a, b) => a.compareTo(b)); // 90
  /// persons.maxBy((a, b) => a.age.compareTo(b.age));  // 最年长者
  /// ```
  T? maximumBy(Comparator<T> comparator) {
    ArgumentError.checkNotNull(comparator, 'comparator');
    if (isEmpty) return null;
    return reduce((value, element) => comparator(value, element) > 0 ? value : element);
  }

  /// 按 [comparator] 排序后返回新 List
  ///
  /// 与 `package:collection` 的 `sortedBy(keyOf)` 区分：本方法接收比较器。
  ///
  /// 示例：
  /// ```dart
  /// [3, 1, 5, 9, 7].sortedWith((a, b) => a.compareTo(b)); // [1, 3, 5, 7, 9]
  /// ```
  List<T> sortedWith(Comparator<T> comparator) {
    ArgumentError.checkNotNull(comparator, 'comparator');
    final list = toList();
    list.sort(comparator);
    return list;
  }

  /// 按 [valueProvider] 提供的数值排序
  ///
  /// 示例：
  /// ```dart
  /// [2, 1, 3].sortedByNum((n) => n); // [1, 2, 3]
  /// persons.sortedByNum((p) => p.age).reversed; // 年龄从大到小
  /// ```
  List<T> sortedByNum(num Function(T element) valueProvider) {
    ArgumentError.checkNotNull(valueProvider, 'valueProvider');
    return sortedWith((a, b) => valueProvider(a).compareTo(valueProvider(b)));
  }

  /// 按 [valueProvider] 提供的字符串排序
  ///
  /// 示例：
  /// ```dart
  /// ['c', 'b', 'a'].sortedByString((c) => c); // ['a', 'b', 'c']
  /// persons.sortedByString((p) => p.name); // 按姓名字母序
  /// ```
  List<T> sortedByString(String Function(T element) valueProvider) {
    ArgumentError.checkNotNull(valueProvider, 'valueProvider');
    return sortedWith((a, b) => valueProvider(a).compareTo(valueProvider(b)));
  }

  /// 最后一个可用索引；空集合返回 null
  ///
  /// 示例：
  /// ```dart
  /// final list = ['a', 'b', 'c'];
  /// list.lastIndex; // 2
  /// list[list.lastIndex]; // 'c'
  /// ```
  int? get lastIndex {
    if (isNotEmpty) {
      return length - 1;
    } else {
      return null;
    }
  }

  /// 惰性返回除首元素外的其余元素
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].withoutFirst; // [2, 3]
  /// [].withoutFirst; // [];
  /// ```
  Iterable<T> get withoutFirst sync* {
    iterator.moveNext(); // eat the first
    while (iterator.moveNext()) {
      yield iterator.current;
    }
  }

  /// 惰性返回除末元素外的其余元素
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].withoutLast; // [1, 2]
  /// [].withoutLast; // [];
  /// ```
  Iterable<T> get withoutLast sync* {
    final hasFirst = iterator.moveNext();
    if (!hasFirst) return;
    while (true) {
      final value = iterator.current;
      final isLastOne = !iterator.moveNext();
      if (!isLastOne) {
        yield value;
      } else {
        break;
      }
    }
  }

  /// 将满足 [comparator] 的元素全部替换为 [newValue]
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].replaceWhere((n) => n < 3, 0); // [0, 0, 3]
  /// ```
  Iterable<T> replaceWhere(bool Function(T currentValue) comparator, T newValue) sync* {
    final it = iterator;
    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield newValue;
      } else {
        yield it.current;
      }
    }
  }

  /// 将第一个满足 [comparator] 的元素替换为 [newValue]
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].replaceFirstWhere((n) => n < 3, 0); // [0, 2, 3]
  /// ```
  Iterable<T> replaceFirstWhere(bool Function(T currentValue) comparator, T newValue) sync* {
    final it = iterator;
    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield newValue;
        while (it.moveNext()) {
          yield it.current;
        }
      } else {
        yield it.current;
      }
    }
  }

  /// 类似 [map]，但回调可访问当前索引
  ///
  /// 参数顺序与 `package:collection` 的 `mapIndexed` 保持一致：`(index, element)`。
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].mapIndexed((index, number) => number * 2); // [2, 4, 6]
  /// ```
  Iterable<U> mapIndexed<U>(U Function(int index, T element) transformer) sync* {
    final it = iterator;
    int index = 0;
    while (it.moveNext()) {
      yield transformer(index++, it.current);
    }
  }

  /// 对每个元素执行 [action]，并原样惰性返回该 [Iterable]
  ///
  /// 示例：
  /// ```dart
  /// final sum = [1, 2, 3].onEach(print).sum(); // sum = 6（同时打印每个数）
  /// ```
  Iterable<T> onEach(void Function(T element) action) sync* {
    ArgumentError.checkNotNull(action, 'action');
    final it = iterator;
    while (it.moveNext()) {
      action(it.current);
      yield it.current;
    }
  }

  /// 对每个元素执行带索引的 [action]，并原样惰性返回该 [Iterable]
  ///
  /// 示例：
  /// ```dart
  /// final sum = [1, 2, 3].onEachIndexed((e, i) => print('$i:$e')).sum(); // sum = 6
  /// ```
  Iterable<T> onEachIndexed(void Function(T element, int index) action) sync* {
    ArgumentError.checkNotNull(action, 'action');
    final it = iterator;
    int index = 0;
    while (it.moveNext()) {
      action(it.current, index++);
      yield it.current;
    }
  }

  /// 随机取一个元素；可通过 [random] 自定义随机源。空集合返回 null
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].pickOne(); // 2（或 1 或 3）
  /// ```
  T? pickOne([Random? random]) {
    final rng = random ?? _iterableRandom;
    final it = iterator;
    T? result;
    int seen = 0;
    while (it.moveNext()) {
      seen++;
      if (rng.nextInt(seen) == 0) result = it.current;
    }
    return result;
  }

  /// 随机取 [count] 个元素组成 List；可通过 [random] 自定义随机源。
  /// [count] 会被收敛到 `[0, length]` 之间，空集合返回空列表
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].pickSome(2); // [1, 2] 或 [3, 2] 等
  /// ```
  List<T> pickSome(int count, [Random? random]) {
    if (count <= 0) return <T>[];
    final List<T> pool = toList();
    if (pool.isEmpty) return <T>[];
    final int amount = count > pool.length ? pool.length : count;
    final Random rng = random ?? _iterableRandom;
    for (int i = 0; i < amount; i++) {
      final int j = i + rng.nextInt(pool.length - i);
      final T temp = pool[i];
      pool[i] = pool[j];
      pool[j] = temp;
    }
    return pool.take(amount).toList();
  }

  /// 在相邻元素之间插入 [element]
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].insertElementBetween(0); // [1, 0, 2, 0, 3]
  /// ```
  List<T> insertElementBetween(T element) => fold([], (result, item) {
    if (result.isEmpty) {
      result.add(item);
    } else {
      result.add(element);
      result.add(item);
    }
    return result;
  });
}

extension ExtensionIterableInt on Iterable<int> {
  /// 所有元素之和
  ///
  /// 示例：
  /// ```dart
  /// [2, 6, 4, 8].sum(); // 20
  /// ```
  int sum() => sumBy((n) => n);

  /// 算术平均值
  ///
  /// 示例：
  /// ```dart
  /// [2, 4, 6, 8].average(); // 5.0
  /// ```
  double? average() => averageBy((n) => n);

  /// 最大值
  ///
  /// 示例：
  /// ```dart
  /// [9, 42, 3].max(); // 42
  /// ```
  int? max() => maximumBy((a, b) => a.compareTo(b));

  /// 最小值
  ///
  /// 示例：
  /// ```dart
  /// [17, 13, 92].min(); // 13
  /// ```
  int? min() => minimumBy((a, b) => a.compareTo(b));
}

extension ExtensionIterableDouble on Iterable<double> {
  /// 所有元素之和
  ///
  /// 示例：
  /// ```dart
  /// [2.0, 6.0, 4.0, 8.0].sum(); // 20.0
  /// ```
  double sum() => sumByDouble((n) => n);

  /// 算术平均值
  ///
  /// 示例：
  /// ```dart
  /// [2.0, 4.0, 6.0, 8.0].average(); // 5.0
  /// ```
  double? average() => averageBy((n) => n);

  /// 最大值
  ///
  /// 示例：
  /// ```dart
  /// [9.0, 42.0, 3.0].max(); // 42.0
  /// ```
  double? max() => maximumBy((a, b) => a.compareTo(b));

  /// 最小值
  ///
  /// 示例：
  /// ```dart
  /// [17.0, 13.0, 92.0].min(); // 13.0
  /// ```
  double? min() => minimumBy((a, b) => a.compareTo(b));
}

/// 元素为 [num] 的 [Iterable] 扩展
extension ExtensionIterableNum<E extends num> on Iterable<E> {
  /// 求和；若提供 [addend] 则对映射值求和；空集合返回 0
  ///
  /// 示例：
  /// ```dart
  /// [1, 2, 3].sum(); // 6
  /// [1, 2, 3].sum((i) => i * 3); // 18
  /// [].sum() // 0
  /// ```
  num sum([num Function(E)? addend]) {
    if (isEmpty) return 0;
    return addend == null ? reduce((a, b) => a + b as E) : fold(0, (prev, element) => prev + addend(element));
  }
}

Map<E, int> _elementCountsIn<E>(Iterable<E> iterable) {
  final counts = <E, int>{};
  for (final element in iterable) {
    final currentCount = counts[element] ?? 0;
    counts[element] = currentCount + 1;
  }
  return counts;
}
