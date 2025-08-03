import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class StateComponentsPage extends StatelessWidget {
  const StateComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('State Components'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('ValueBuilder', marginTop: 0),
        ValueBuilder<int>(
          initial: 0,
          builder: (_, int? value, ValueCallback<int> updater) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Universal(
                  child: const Icon(Icons.remove_circle_outline),
                  onTap: () {
                    int v = value ?? 0;
                    v -= 1;
                    updater(v);
                  },
                ),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(value.toString())),
                Universal(
                  child: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    int v = value ?? 0;
                    v += 1;
                    updater(v);
                  },
                ),
              ],
            );
          },
        ),
        const Partition('ValueListenBuilder'),
        ValueListenBuilder<int>(
          initial: 1,
          builder: (_, ValueNotifier<int?> valueListenable) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Universal(
                  child: const Icon(Icons.remove_circle_outline),
                  onTap: () {
                    int num = valueListenable.value ?? 0;
                    num -= 1;
                    valueListenable.value = num;
                  },
                ),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(valueListenable.value.toString())),
                Universal(
                  child: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    int num = valueListenable.value ?? 0;
                    num += 1;
                    valueListenable.value = num;
                  },
                ),
              ],
            );
          },
        ),
        const Partition('Checkbox 官方附加状态版本'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ChangedBuilder<bool?>(
              value: true,
              onChanged: (bool? value) {},
              builder: (bool? value, onChanged) => Checkbox(tristate: true, value: value, onChanged: onChanged),
            ),
            ChangedBuilder<bool?>(
              value: true,
              onWaitChanged: (bool? value) async {
                await 1.seconds.delayed();
                return value;
              },
              builder:
                  (bool? value, onChanged) =>
                      Checkbox(shape: const CircleBorder(), tristate: true, value: value, onChanged: onChanged),
            ),
          ],
        ),
        const Partition('Switch 官方附加状态版本'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ChangedBuilder<bool>(
              value: true,
              onChanged: (bool value) {},
              builder: (bool value, onChanged) => Switch(value: value, onChanged: onChanged),
            ),
            ChangedBuilder<bool>(
              value: true,
              onChanged: (bool value) {},
              builder: (bool value, onChanged) => CupertinoSwitch(value: value, onChanged: onChanged),
            ),
            ChangedBuilder<bool>(
              value: true,
              onWaitChanged: (bool value) async {
                await 1.seconds.delayed();
                return value;
              },
              builder: (bool value, onChanged) => CupertinoSwitch(value: value, onChanged: onChanged),
            ),
          ],
        ),
        const Partition('ExtendedListenableBuilder'),
        DefaultTabController(
          length: 2,
          child: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return Column(
                children: [
                  ExtendedListenableBuilder<TabController>(
                    listenable: controller,
                    builder: (_, TabController controller) {
                      final icons = [Icons.home, Icons.account_circle_outlined];
                      return Row(
                        children: 2.generate(
                          (index) =>
                              Icon(icons[index], color: controller.index == index ? Colors.blueAccent : null).expanded,
                        ),
                      );
                    },
                  ),
                  10.heightBox,
                  SizedBox(
                    height: 50,
                    child: TabBarView(
                      children: [
                        Container(color: Colors.yellow, child: const Center(child: Text('往左滑动'))),
                        Container(color: Colors.blueAccent, child: const Center(child: Text('往左滑动'))),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
