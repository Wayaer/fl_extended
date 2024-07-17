import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class TextPage extends StatelessWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('Text'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Partition('BText  DefaultTextStyle'),
            DefaultTextStyle(
                style: context.textTheme.bodyLarge ?? const TextStyle(),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BText('BText'),
                      BText.rich(
                          text: 'Start text  ',
                          texts: ['BText', ' * ', 'rich']),
                    ])),
            const Partition('BText'),
            const BText('BText'),
            const Partition('BText.rich'),
            const BText.rich(
                style: TextStyle(color: Colors.green),
                color: Colors.red,
                texts: [
                  'BText',
                  ' * ',
                  'rich'
                ],
                styles: [
                  TextStyle(color: Colors.purpleAccent),
                  TextStyle(color: Colors.blue),
                  TextStyle(color: Colors.yellow),
                ]),
            const BText.rich(
                style: TextStyle(color: Colors.red),
                color: Colors.green,
                texts: ['BText', ' * ', 'rich'],
                styles: [TextStyle(color: Colors.purpleAccent)]),
            const BText.rich(
                style: TextStyle(color: Colors.red),
                color: Colors.green,
                texts: ['BText', ' * ', 'rich']),
            const Partition('RText'),
            RText(style: const TextStyle(color: Colors.green), texts: const [
              'RText',
              ' = ',
              'RichText魔改版',
            ], styles: const [
              TextStyle(color: Colors.purpleAccent),
              TextStyle(color: Colors.blue),
              TextStyle(color: Colors.yellow),
            ]),
            const Partition('BText set color'),
            const BText('BText', color: Colors.red),
            const Partition('BText set style color'),
            const BText('BText',
                color: Colors.red,
                style: TextStyle(color: Colors.blue),
                useStyleFirst: true),
            const Partition('BText set style color useStyleFirst=false'),
            const BText('BText',
                useStyleFirst: false,
                color: Colors.red,
                style: TextStyle(color: Colors.blue)),
          ]);
}
