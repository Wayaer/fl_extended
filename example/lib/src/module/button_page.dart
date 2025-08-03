import 'package:example/main.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FlButtonPage extends StatelessWidget {
  const FlButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlScaffold(
      appBar: AppBaFlRichText('FlButton'),
      isScroll: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Partition('FlButton', marginTop: 0),
          ...FlButtonCategory.values.builder(
            (item) => FlButton(
              category: item,
              child: Text('FlButton (${item.name})'),
              onPressed: () {
                showToast('FlButton');
              },
            ),
          ),
          const Partition('FlButton.icon'),
          ...FlButtonCategory.values.builder(
            (item) => FlButton.icon(
              icon: const Icon(Icons.ac_unit),
              category: item,
              onPressed: () {
                showToast('FlButton.icon');
              },
              child: Text('FlButton.icon (${item.name})'),
            ),
          ),
          const Partition('Universal'),
          ...FlButtonCategory.values.builder(
            (item) => Universal(
              direction: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 4),
              buttonCategory: item,
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
