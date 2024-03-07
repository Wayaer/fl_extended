import 'package:example/main.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class IconBoxPage extends StatelessWidget {
  const IconBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('IconBox'),
        isScroll: true,
        padding: const EdgeInsets.all(20),
        children: [
          IconBox(
              unifiedButtonCategory: UnifiedButtonCategory.filled,
              icon: Icons.ac_unit,
              onTap: () {
                showToast('IconBox');
              },
              label: const Text('IconBox')),
          10.heightBox,
          IconBox(
              unifiedButtonCategory: UnifiedButtonCategory.filledTonal,
              icon: Icons.ac_unit,
              direction: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              onPressed: () {
                showToast('IconBox');
              },
              label: const Text('IconBox')),
        ]);
  }
}
