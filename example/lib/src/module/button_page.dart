import 'package:example/main.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      appBar: AppBarText('Button'),
      isScroll: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Partition('UnifiedButton', marginTop: 0),
          ...UnifiedButtonCategory.values.builder(
            (item) => UnifiedButton(
              category: item,
              child: Text('UnifiedButton (${item.name})'),
              onPressed: () {
                showToast('UnifiedButton');
              },
            ),
          ),
          const Partition('UnifiedButton.icon'),
          ...UnifiedButtonCategory.values.builder(
            (item) => UnifiedButton.icon(
              icon: const Icon(Icons.ac_unit),
              category: item,
              onPressed: () {
                showToast('UnifiedButton.icon');
              },
              child: Text('UnifiedButton.icon (${item.name})'),
            ),
          ),
          const Partition('Universal'),
          ...UnifiedButtonCategory.values.builder(
            (item) => Universal(
              direction: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 4),
              unifiedButtonCategory: item,
              children: [Icon(Icons.ac_unit), Text('Universal (${item.name})')],
              onPressed: () {
                showToast('Universal');
              },
            ),
          ),
          60.heightBox,
        ],
      ),
    );
  }
}
