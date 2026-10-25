import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Text & SelectableText',
      description:
          'FlText 支持 Text / Text.rich / 多段 TextSpan 的统一写法，额外提供颜色、字号、字重等扁平参数；'
          'FlSelectableText 用同样的方式构建可选文本。',
      sections: [
        DemoSection(
          title: 'FlText',
          description: '最常用的文本组件，默认继承最近的 DefaultTextStyle。',
          children: [
            DemoItem(
              title: '基础用法',
              code: "const FlText('Hello fl_extended')",
              child: FlText('Hello fl_extended'),
            ),
            DemoItem(
              title: '扁平样式参数',
              description: '颜色、字号、字重、行高、字间距都可以直接传入。',
              code: "FlText('Style', color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 1)",
              child: FlText(
                'Style',
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            DemoItem(
              title: 'useStyleFirst',
              description: '同时设置 color 与 style.color 时，true 优先 style，false 优先 color。',
              code:
                  "FlText('style first', color: Colors.blue, style: TextStyle(color: Colors.red), useStyleFirst: true)\n"
                  "FlText('color first', color: Colors.blue, style: TextStyle(color: Colors.red), useStyleFirst: false)",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlText(
                    'style first',
                    color: Colors.blue,
                    style: TextStyle(color: Colors.red),
                  ),
                  6.heightBox,
                  FlText(
                    'color first',
                    color: Colors.blue,
                    style: TextStyle(color: Colors.red),
                    useStyleFirst: false,
                  ),
                ],
              ),
            ),
            DemoItem(
              title: '继承 DefaultTextStyle',
              description: 'inherit 为 true 时与父级文本样式合并。',
              code: "DefaultTextStyle(style: TextStyle(fontSize: 18, color: Colors.teal), child: FlText('继承父级样式'))",
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 18, color: Colors.teal),
                child: FlText('继承父级样式'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '富文本',
          description: 'FlText 支持 InlineSpan、多个 TextSpan，以及按字符串列表 + 样式列表快速拼接。',
          children: [
            DemoItem(
              title: 'FlText.rich',
              code: "FlText.rich(TextSpan(text: 'FlText.rich', style: TextStyle(color: Colors.purple)))",
              child: FlText.rich(
                const TextSpan(
                  text: 'FlText.rich',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
            DemoItem(
              title: 'FlText.richSpans',
              description: '按 InlineSpan 列表构建，适合混合多种样式。',
              code: "FlText.richSpans([TextSpan(text: 'FlText'), TextSpan(text: ' * '), TextSpan(text: 'richSpans')])",
              child: FlText.richSpans(
                const [
                  TextSpan(
                    text: 'FlText',
                    style: TextStyle(color: Colors.purple),
                  ),
                  TextSpan(text: ' * '),
                  TextSpan(
                    text: 'richSpans',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'FlText.richText',
              description: 'texts 与 styles 按索引对应，styles 不足的片段继承外层样式。',
              code: "FlText.richText(texts: ['FlText', ' * ', 'rich'], styles: [TextStyle(color: Colors.purple), TextStyle(color: Colors.green)])",
              child: FlText.richText(
                color: Colors.blue,
                texts: const ['FlText', ' * ', 'rich'],
                styles: const [
                  TextStyle(color: Colors.purple),
                  TextStyle(color: Colors.green),
                ],
              ),
            ),
            DemoItem(
              title: 'FlRichText',
              description: 'RichText 的增强版，直接接收 texts / styles / recognizers 列表。',
              code: "FlRichText(style: TextStyle(color: Colors.blue), texts: ['FlRichText', ' * ', 'RichText'])",
              child: FlRichText(
                style: TextStyle(color: Colors.blue),
                texts: const ['FlRichText', ' * ', 'RichText'],
                styles: const [
                  TextStyle(color: Colors.purple),
                  TextStyle(color: Colors.green),
                ],
              ),
            ),
            DemoItem(
              title: 'FlTextSpan',
              description: '可像 FlText 一样使用扁平样式的 TextSpan。',
              code: "FlText.rich(FlTextSpan(children: [FlTextSpan(text: 'Fl', color: Colors.blue), FlTextSpan(text: 'Text', color: Colors.orange)]))",
              child: FlText.rich(
                FlTextSpan(
                  children: [
                    FlTextSpan(text: 'Fl', color: Colors.blue),
                    FlTextSpan(text: 'Text', color: Colors.orange, fontWeight: FontWeight.bold),
                    FlTextSpan(text: 'Span', color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'FlSelectableText',
          description: '与 FlText 相同的参数体系，支持长按选择、自定义上下文菜单与选择回调。',
          children: [
            DemoItem(
              title: '基础选择',
              code: "FlSelectableText('Long press to select this text')",
              child: FlSelectableText('Long press to select this text'),
            ),
            DemoItem(
              title: '富文本选择',
              code: "FlSelectableText.richText(texts: ['FlSelectable', ' * ', 'Text'], styles: [...])",
              child: FlSelectableText.richText(
                color: Colors.blue,
                texts: const ['FlSelectable', ' * ', 'Text'],
                styles: const [
                  TextStyle(color: Colors.purpleAccent),
                  TextStyle(color: Colors.green),
                ],
              ),
            ),
            DemoItem(
              title: 'custom 构造',
              code: "FlSelectableText.custom(data: 'custom', color: Colors.indigo, fontSize: 15)",
              child: FlSelectableText.custom(data: 'FlSelectableText.custom data', color: Colors.indigo, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
