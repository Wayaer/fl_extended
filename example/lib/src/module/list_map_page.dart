import 'dart:convert';
import 'dart:typed_data';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ListMapPage extends StatelessWidget {
  const ListMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> scores = <String, int>{'Alice': 90, 'Bob': 82};
    return DemoPage(
      title: 'List & Map',
      description: '列表的构建、修改、切片、编解码，以及 Map 的键值转换与条件更新。',
      sections: [
        DemoSection(
          title: '构建新列表',
          children: [
            DemoItem(
              title: 'generate / mapToList / builder',
              code: r"""
3.generate((index) => index * 2);            // [0, 2, 4]
[1, 2].mapToList((n) => n + 1);              // [2, 3]
[10, 20].builder((n) => n / 10);             // [1.0, 2.0]
[10, 20].builderIV((index, n) => index + n); // [10, 21]
[10, 20].builderEntry((entry) => entry.key); // [0, 1]
asMapEntriesMapToList((entry) => '${entry.key}:${entry.value}');
""",
              child: const DemoValues([
                DemoValue('3.generate((i) => i * 2)', '[0, 2, 4]'),
                DemoValue('[1, 2].mapToList((n) => n + 1)', '[2, 3]'),
                DemoValue('[10, 20].builder((n) => n / 10)', '[1.0, 2.0]'),
                DemoValue('[10, 20].builderIV((i, n) => i + n)', '[10, 21]'),
                DemoValue('[10, 20].builderEntry((e) => e.key)', '[0, 1]'),
                DemoValue("[10, 20].asMapEntriesMapToList((e) => '\${e.key}:\${e.value}')", '[0:10, 1:20]'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '修改与访问',
          description: 'addT / insertT / replaceRangeT 会返回自身，便于链式调用；isEmptyOrNull 处理可空列表。',
          children: [
            DemoItem(
              title: '链式修改',
              code: r"""
[1, 2].addT(3);                          // [1, 2, 3]
[1, 2].addAllT([3, 4], isAdd: false);    // [1, 2]
[1, 3].insertT(1, 2);                    // [1, 2, 3]
[1, 4].replaceRangeT(1, 2, [2, 3]);      // [1, 2, 3]
""",
              child: const DemoValues([
                DemoValue('[1, 2].addT(3)', '[1, 2, 3]'),
                DemoValue('[1, 2].addAllT([3, 4], isAdd: false)', '[1, 2]'),
                DemoValue('[1, 3].insertT(1, 2)', '[1, 2, 3]'),
                DemoValue('[1, 4].replaceRangeT(1, 2, [2, 3])', '[1, 2, 3]'),
                DemoValue('[1, 2, 3, 4].slice(1, 3)', '[2, 3]'),
                DemoValue('[1, 2, 3].getElementOrNull(9)', 'null'),
                DemoValue('[1, 2, 3].getElementSafe(9)', '3'),
                DemoValue('[1, 2, 3].getElementSafe(-1)', '1'),
                DemoValue('List<int>? none; none.isEmptyOrNull', 'true'),
              ]),
            ),
            DemoItem(
              title: 'removeWhere',
              code: "final list = [1, 2, 3, 4];\nlist.removeElement((n) => n.isEven);\n// [1, 3]",
              child: const DemoValues([
                DemoValue('[1, 2, 3, 4].removeElement((n) => n.isEven)', '[1, 3]'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: '编码与解码',
          description: 'List<int> 与字符串、Base64、UTF-8、32 位打包之间互转。',
          children: [
            DemoItem(
              title: 'Base64 / UTF-8',
              code: r"""
[1, 2, 3].base64Encode();
'AQID'.base64Decode().toList();
utf8.encode('中文').toUtf8;
[72, 101, 108, 108, 111].utf8Decode();
""",
              child: DemoValues([
                DemoValue('[1, 2, 3].base64Encode()', <int>[1, 2, 3].base64Encode()),
                DemoValue("'AQID'.base64Decode().toList()", 'AQID'.base64Decode().toList().toString()),
                DemoValue("utf8.encode('中文').toUtf8", utf8.encode('中文').toUtf8),
                DemoValue('[72, 101, 108, 108, 111].utf8Decode()', <int>[72, 101, 108, 108, 111].utf8Decode()),
                DemoValue("[1, 2].toStringRemoveBracket", <String>['a', 'b'].toStringRemoveBracket),
              ]),
            ),
            DemoItem(
              title: '32 位打包',
              code: r"""
final bytes = Uint8List.fromList([1, 2, 3]);
final packed = bytes.bit32ListFromUInt8List();
packed.uInt8ListFrom32BitList(bytes.length); // [1, 2, 3]
""",
              child: DemoValues([
                DemoValue(
                  'bytes.bit32ListFromUInt8List()',
                  Uint8List.fromList(<int>[1, 2, 3]).bit32ListFromUInt8List().toString(),
                ),
                DemoValue(
                  'uInt8ListFrom32BitList(3)',
                  Uint8List.fromList(<int>[1, 2, 3])
                      .bit32ListFromUInt8List()
                      .uInt8ListFrom32BitList(3)
                      .toList()
                      .toString(),
                ),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'Map',
          description: 'keys / values 列表化、entries 映射、条件更新与 key 递归转字符串。',
          children: [
            DemoItem(
              title: '读取与映射',
              code: r"""
scores.keysList();
scores.valuesList();
scores.entriesMapKVToList((k, v) => '$k=$v');
scores.entriesMap((entry) => entry.value);
""",
              child: DemoValues([
                DemoValue('scores.keysList()', scores.keysList().toString()),
                DemoValue('scores.valuesList()', scores.valuesList().toString()),
                DemoValue(
                  "scores.entriesMapKVToList((k, v) => '\$k=\$v')",
                  scores.entriesMapKVToList((String k, int v) => '$k=$v').toString(),
                ),
                DemoValue(
                  'scores.entriesMap((e) => e.value).toList()',
                  scores.entriesMap((MapEntry<String, int> e) => e.value).toList().toString(),
                ),
              ]),
            ),
            DemoItem(
              title: '条件更新',
              code: r"""
scores.addAllT({'Cara': 88});
scores.updateAllT((k, v) => v + 5);
scores.updateT('Alice', (v) => v + 1);
scores.updateT('Zoe', (v) => v, ifAbsent: () => 100);
""",
              child: DemoValues([
                DemoValue("scores.addAllT({'Cara': 88})", "{Alice: 90, Bob: 82, Cara: 88}"),
                DemoValue('scores.updateAllT((k, v) => v + 5)', "{Alice: 95, Bob: 87, Cara: 93}"),
                DemoValue("scores.updateT('Alice', (v) => v + 1)", "{Alice: 96, Bob: 87, Cara: 93}"),
                DemoValue(
                  "scores.updateT('Zoe', (v) => v, ifAbsent: () => 100)",
                  "{Alice: 96, Bob: 87, Cara: 93, Zoe: 100}",
                ),
              ]),
            ),
            DemoItem(
              title: 'keyToString',
              description: '递归把 Map / List 中的 key 转成 String，便于 JSON 序列化。',
              code: r"""
final data = {
  'list': [ {1: 'a'} ],
  'nested': {2: {3: 'b'}},
};
data.keyToString;
""",
              child: DemoValues([
                DemoValue(
                  'data.keyToString',
                  <dynamic, dynamic>{
                    'list': <dynamic>[
                      <int, String>{1: 'a'},
                    ],
                    'nested': <dynamic, dynamic>{
                      2: <int, String>{3: 'b'},
                    },
                  }.keyToString.toString(),
                ),
                DemoValue('Map<String, int>? none; none.isEmptyOrNull', 'true'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
