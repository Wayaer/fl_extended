import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class IterablePage extends StatelessWidget {
  const IterablePage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<int> numbers = <int>[3, 1, 4, 1, 5, 9, 2, 6];
    const List<String> words = <String>['apple', 'banana', 'cherry'];
    final List<({String name, int age})> persons = <({String name, int age})>[
      (name: 'John', age: 21),
      (name: 'Carl', age: 18),
      (name: 'Peter', age: 56),
      (name: 'Sarah', age: 61),
    ];
    return DemoPage(
      title: 'Iterable',
      description: '基于 Iterable 的查询、聚合、分组、排序与惰性转换；数值集合还有 sum / average / max / min 专用扩展。',
      sections: [
        DemoSection(
          title: '判断与过滤',
          children: [
            DemoItem(
              title: '布尔查询',
              code: r"""
[1, 2, 3].all((n) => n > 0);          // true
[1, 2, 3].none((n) => n > 4);         // true
[1, 2, 3].one((n) => n == 2);         // true
[1, 2, 3].containsAny([5, 2]);        // true
[1, 2, 3].containsAll([1, 2, 2]);     // true
[1, 2, 3].count((n) => n > 1);        // 2
[1, 2, 3].firstOrNullWhere((n) => n > 1);
""",
              child: const DemoValues([
                DemoValue('[1, 2, 3].all((n) => n > 0)', 'true'),
                DemoValue('[1, 2, 3].none((n) => n > 4)', 'true'),
                DemoValue('[1, 2, 3].one((n) => n == 2)', 'true'),
                DemoValue('[1, 2, 3].containsAny([5, 2])', 'true'),
                DemoValue('[1, 2, 3].containsAll([1, 1, 2], collapseDuplicates: false)', 'false'),
                DemoValue('[1, 2, 3].count((n) => n > 1)', '2'),
                DemoValue('[1, 2, 3].firstOrNullWhere((n) => n > 1)', '2'),
                DemoValue('[1, 2, 3].filter((n) => n.isOdd).toList()', '[1, 3]'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '聚合',
          description: '空集合返回 0 / null，不会抛异常。',
          children: [
            DemoItem(
              title: '求和、平均、最值',
              code: r"""
[2, 4, 6].sum();                    // 12
[1, 2, 3].sum((n) => n * 2);        // 12
['hello', 'flutter'].sumBy((s) => s.length);
[1.5, 2.5].sumByDouble((d) => d);
[1, 2, 3].average();                // 2.0
[3, 1, 4].max();                    // 4
[3, 1, 4].min();                    // 1
""",
              child: DemoValues([
                DemoValue('[2, 4, 6].sum()', '12'),
                DemoValue('[1, 2, 3].sum((n) => n * 2)', '12'),
                DemoValue("['hello', 'flutter'].sumBy((s) => s.length)", '12'),
                DemoValue('[1.5, 2.5].sumByDouble((d) => d)', '4.0'),
                DemoValue('[1, 2, 3].average()', '2.0'),
                DemoValue('[3, 1, 4].max()', '4'),
                DemoValue('[3, 1, 4].min()', '1'),
                DemoValue(
                  'persons.averageBy((p) => p.age)',
                  '${persons.averageBy((({String name, int age}) p) => p.age)}',
                ),
              ]),
            ),
            DemoItem(
              title: '自定义比较',
              code: r"""
persons.minimumBy((a, b) => a.age.compareTo(b.age));
persons.maximumBy((a, b) => a.age.compareTo(b.age));
""",
              child: DemoValues([
                DemoValue(
                  'minimumBy(age)',
                  '${persons.minimumBy((({String name, int age}) a, ({String name, int age}) b) => a.age.compareTo(b.age))?.name}',
                ),
                DemoValue(
                  'maximumBy(age)',
                  '${persons.maximumBy((({String name, int age}) a, ({String name, int age}) b) => a.age.compareTo(b.age))?.name}',
                ),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '转换与分组',
          children: [
            DemoItem(
              title: 'mapIndexed / groupBy / associate',
              code: r"""
[10, 20].mapIndexed((index, value) => '$index:$value');
[1, 2, 3, 4].groupBy((n) => n.isEven);
['a', 'ab'].associateBy((s) => s.length);
[1, 2, 3].associateWith((n) => n * 100);
[1, 2].associate((n) => MapEntry('key_$n', n));
""",
              child: DemoValues([
                DemoValue("[10, 20].mapIndexed((i, v) => '\$i:\$v')", '[0:10, 1:20]'),
                DemoValue('[1, 2, 3, 4].groupBy((n) => n.isEven)', '${<int>[1, 2, 3, 4].groupBy((int n) => n.isEven)}'),
                DemoValue(
                  "['a', 'ab'].associateBy((s) => s.length)",
                  '${<String>['a', 'ab'].associateBy((String s) => s.length)}',
                ),
                DemoValue('[1, 2].associateWith((n) => n * 100)', '${<int>[1, 2].associateWith((int n) => n * 100)}'),
                DemoValue("[1, 2].associate((n) => MapEntry('key_\$n', n))", "[key_1: 1, key_2: 2]"),
                DemoValue('numbers.chunked(3)', '${numbers.chunked(3).toList()}'),
                DemoValue("numbers.chunked(3, fill: () => 0)", '${numbers.chunked(3, fill: () => 0).toList()}'),
              ]),
            ),
            DemoItem(
              title: '插值 / 替换 / 去首尾',
              code: r"""
[1, 2, 3].insertElementBetween(0);          // [1, 0, 2, 0, 3]
[1, 2, 3].replaceWhere((n) => n < 3, 0);    // [0, 0, 3]
[1, 2, 3].replaceFirstWhere((n) => n < 3, 0);
[1, 2, 3].withoutFirst;                     // [2, 3]
[1, 2, 3].withoutLast;                      // [1, 2]
""",
              child: const DemoValues([
                DemoValue('[1, 2, 3].insertElementBetween(0)', '[1, 0, 2, 0, 3]'),
                DemoValue('[1, 2, 3].replaceWhere((n) => n < 3, 0)', '[0, 0, 3]'),
                DemoValue('[1, 2, 3].replaceFirstWhere((n) => n < 3, 0)', '[0, 2, 3]'),
                DemoValue('[1, 2, 3].withoutFirst.toList()', '[2, 3]'),
                DemoValue('[1, 2, 3].withoutLast.toList()', '[1, 2]'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '排序与取值',
          children: [
            DemoItem(
              title: '排序',
              code: r"""
[3, 1, 2].sortedWith((a, b) => a.compareTo(b));
persons.sortedByNum((p) => p.age);
words.sortedByString((s) => s);
""",
              child: DemoValues([
                DemoValue(
                  '[3, 1, 2].sortedWith((a, b) => a.compareTo(b))',
                  '${<int>[3, 1, 2].sortedWith((int a, int b) => a.compareTo(b))}',
                ),
                DemoValue(
                  'persons.sortedByNum((p) => p.age).map((p) => p.name)',
                  '${persons.sortedByNum((({String name, int age}) p) => p.age).map((({String name, int age}) p) => p.name).toList()}',
                ),
                DemoValue('words.sortedByString((s) => s)', '${words.sortedByString((String s) => s)}'),
              ]),
            ),
            DemoItem(
              title: '安全取值',
              code: r"""
list.elementAtOrElse(9, () => -1);
list.elementAtOrNull(9);      // null
list.firstOrElse(() => -1);
list.lastOrNull;
list.lastIndex;
list.pickOne();
list.pickSome(3);
""",
              child: DemoValues([
                DemoValue('numbers.elementAtOrElse(9, () => -1)', '${numbers.elementAtOrElse(9, () => -1)}'),
                DemoValue('numbers.elementAtOrNull(99)', '${numbers.elementAtOrNull(99)}'),
                DemoValue('numbers.firstOrElse(() => -1)', '${numbers.firstOrElse(() => -1)}'),
                DemoValue('numbers.lastOrNull', '${numbers.lastOrNull}'),
                DemoValue('numbers.lastIndex', '${numbers.lastIndex}'),
                DemoValue('numbers.pickSome(3)', '${numbers.pickSome(3)}（随机）'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '惰性遍历',
          description: 'onEach / onEachIndexed 会执行副作用并原样返回，适合调试或统计。',
          children: [
            DemoItem(
              title: 'onEach',
              code: r"""
int total = 0;
final result = [1, 2, 3].onEach((n) => total += n).toList();
// total == 6, result == [1, 2, 3]
""",
              child: const DemoValues([
                DemoValue('onEach 之后 total', '6'),
                DemoValue('onEachIndexed 原样返回', '[1, 2, 3]'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
