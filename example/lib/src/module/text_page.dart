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
            const Partition('BText'),
            const BText('BText'),
            const BText.rich(
                style: BTextStyle(color: Color(0xFF42A5F5)),
                texts: [
                  'BText',
                  ' . ',
                  'rich',
                ],
                styles: [
                  BTextStyle(color: Color(0xFFD32F2F)),
                  BTextStyle(color: Colors.white),
                  BTextStyle(color: Color(0xFFFFC400)),
                ]),
            RText(
                style: const BTextStyle(color: Color(0xFF42A5F5)),
                texts: const [
                  'RText',
                  ' = ',
                  'RichText魔改版',
                ],
                styles: const [
                  BTextStyle(color: Color(0xFFD32F2F)),
                  BTextStyle(color: Colors.white),
                  // BTextStyle(color: Color(0xFFFFC400)),
                ])
          ]);
}