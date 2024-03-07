import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class StateTextPage extends StatelessWidget {
  const StateTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('State Components'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('ValueBuilder'),
          ValueBuilder<int>(
              initialValue: 0,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconBox(
                          icon: Icons.remove_circle_outline,
                          onTap: () {
                            int v = value ?? 0;
                            v -= 1;
                            updater(v);
                          }),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value.toString())),
                      IconBox(
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            int v = value ?? 0;
                            v += 1;
                            updater(v);
                          })
                    ]);
              }),
          const Partition('ValueListenBuilder'),
          ValueListenBuilder<int>(
              initialValue: 1,
              builder: (_, ValueNotifier<int?> valueListenable) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconBox(
                          icon: Icons.remove_circle_outline,
                          onTap: () {
                            int num = valueListenable.value ?? 0;
                            num -= 1;
                            valueListenable.value = num;
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(valueListenable.value.toString()),
                      ),
                      IconBox(
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            int num = valueListenable.value ?? 0;
                            num += 1;
                            valueListenable.value = num;
                          })
                    ]);
              }),
          const Partition('Checkbox 官方附加状态版本'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ChangedBuilder<bool?>(
                value: true,
                onChanged: (bool? value) {},
                builder: (bool? value, onChanged) => Checkbox(
                    tristate: true, value: value, onChanged: onChanged)),
            ChangedBuilder<bool?>(
                value: true,
                onWaitChanged: (bool? value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool? value, onChanged) => Checkbox(
                    shape: const CircleBorder(),
                    tristate: true,
                    value: value,
                    onChanged: onChanged)),
          ]),
          const Partition('Switch 官方附加状态版本'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ChangedBuilder<bool>(
                value: true,
                onChanged: (bool value) {},
                builder: (bool value, onChanged) =>
                    Switch(value: value, onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onChanged: (bool value) {},
                builder: (bool value, onChanged) =>
                    CupertinoSwitch(value: value, onChanged: onChanged)),
            ChangedBuilder<bool>(
                value: true,
                onWaitChanged: (bool value) async {
                  await 1.seconds.delayed();
                  return value;
                },
                builder: (bool value, onChanged) =>
                    CupertinoSwitch(value: value, onChanged: onChanged)),
          ]),
          const SizedBox(height: 100),
        ]);
  }
}
