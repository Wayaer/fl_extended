import 'package:example/main.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FlTextPage extends StatelessWidget {
  const FlTextPage({super.key});

  @override
  Widget build(BuildContext context) => FlScaffold(
    isScroll: true,
    appBar: AppBaFlRichText('FlText'),
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    children: [
      const Partition('FlText  DefaultTextStyle', marginTop: 0),
      DefaultTextStyle(
        style: context.textTheme.bodyLarge ?? const TextStyle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const FlText('FlText'),
            FlText.richText(texts: ['FlText', '.', 'richText']),
          ],
        ),
      ),
      const Partition('FlText'),
      const FlText('FlText'),
      const Partition('FlText.rich'),
      FlText.rich(TextSpan(text: ' FlText.rich', style: TextStyle(color: Colors.purpleAccent)), color: Colors.blue),
      const Partition('FlText.richSpans'),
      FlText.richSpans([
        TextSpan(text: 'FlText', style: TextStyle(color: Colors.purpleAccent)),
        TextSpan(text: ' * '),
        TextSpan(text: 'richSpans', style: TextStyle(color: Colors.yellow)),
      ], color: Colors.blue),
      const Partition('FlText.richText'),
      FlText.richText(
        color: Colors.blue,
        texts: ['FlText', ' * ', 'rich'],
        styles: [TextStyle(color: Colors.purpleAccent), TextStyle(color: Colors.green)],
      ),
      const Partition('FlRichText'),
      FlRichText(
        style: const TextStyle(color: Colors.blue),
        texts: const ['FlRichText', ' * ', 'RichText'],
        styles: const [TextStyle(color: Colors.purpleAccent), TextStyle(color: Colors.green)],
      ),
      const Partition('FlText set color'),
      const FlText('FlText', color: Colors.blue),
      const Partition('FlText set style color'),
      const FlText('FlText', color: Colors.blue, style: TextStyle(color: Colors.red), useStyleFirst: true),
      const Partition('FlText set style color useStyleFirst=false'),
      const FlText('FlText', useStyleFirst: false, color: Colors.blue, style: TextStyle(color: Colors.red)),
    ],
  );
}
