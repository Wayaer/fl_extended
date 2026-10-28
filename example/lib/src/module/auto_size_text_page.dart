import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class AutoSizeTextPage extends StatelessWidget {
  const AutoSizeTextPage({super.key});

  /// 演示用的通用渲染方式：把组件回传的数据交给 Text.rich
  static FlAutoSizeTextBuilderCallback _textBuilder({TextAlign? textAlign}) =>
      (BuildContext context, FlAutoSizeTextData data) => Text.rich(
        data.textSpan,
        style: data.style,
        textScaler: data.textScaler,
        maxLines: data.maxLines,
        textDirection: data.textDirection,
        locale: data.locale,
        softWrap: data.softWrap,
        strutStyle: data.strutStyle,
        textHeightBehavior: data.textHeightBehavior,
        textAlign: textAlign,
      );

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'FlAutoSizeTextBuilder',
      description:
          '自动缩放文本：在可用空间内二分查找能放下的最大字号，'
          '支持最小 / 最大字号、步长、预置字号、单词换行策略、溢出兜底与多文本字号同步。'
          '组件只负责计算字号，渲染统一交给 builder。',
      sections: [
        DemoSection(
          title: '基础用法',
          description: '需要在有限约束中使用（如 SizedBox、Expanded），字号会在给定区间内自动缩小。',
          children: [
            DemoItem(
              title: 'FlText.autoSizeOptions',
              description: 'FlText 开启 autoSizeOptions 后走自动缩放逻辑，其余参数保持不变。',
              code:
                  "SizedBox(\n"
                  "  width: 220,\n"
                  "  height: 44,\n"
                  "  child: FlText(\n"
                  "    'Flutter 自动缩放文本',\n"
                  "    fontSize: 28,\n"
                  "    maxLines: 1,\n"
                  "    autoSizeOptions: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 28),\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 220,
                height: 44,
                child: FlText(
                  'Flutter 自动缩放文本',
                  fontSize: 28,
                  maxLines: 1,
                  autoSizeOptions: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 28),
                ),
              ),
            ),
            DemoItem(
              title: 'FlAutoSizeTextBuilder + Text.rich',
              description: 'builder 必传，组件把算好的字号、缩放器和行数通过 FlAutoSizeTextData 回传。',
              code:
                  "SizedBox(\n"
                  "  width: 220,\n"
                  "  height: 60,\n"
                  "  child: FlAutoSizeTextBuilder(\n"
                  "    const TextSpan(text: 'FlAutoSizeTextBuilder 独立使用'),\n"
                  "    options: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 30),\n"
                  "    style: const TextStyle(fontWeight: FontWeight.w700),\n"
                  "    layout: const FlAutoSizeTextLayout(maxLines: 2),\n"
                  "    builder: (BuildContext context, FlAutoSizeTextData data) => Text.rich(\n"
                  "      data.textSpan,\n"
                  "      style: data.style,\n"
                  "      textScaler: data.textScaler,\n"
                  "      maxLines: data.maxLines,\n"
                  "      textDirection: data.textDirection,\n"
                  "      locale: data.locale,\n"
                  "      softWrap: data.softWrap,\n"
                  "      strutStyle: data.strutStyle,\n"
                  "      textHeightBehavior: data.textHeightBehavior,\n"
                  "      textAlign: TextAlign.center,\n"
                  "    ),\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 220,
                height: 60,
                child: FlAutoSizeTextBuilder(
                  const TextSpan(text: 'FlAutoSizeTextBuilder 独立使用'),
                  options: const FlAutoSizeOptions(minFontSize: 10, maxFontSize: 30),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  layout: const FlAutoSizeTextLayout(maxLines: 2),
                  builder: _textBuilder(textAlign: TextAlign.center),
                ),
              ),
            ),
            DemoItem(
              title: 'builder 自定义渲染',
              description: '渲染组件完全由外部决定，这里把 Text.rich 换成 SelectableText.rich。',
              code:
                  "SizedBox(\n"
                  "  width: 220,\n"
                  "  height: 48,\n"
                  "  child: FlAutoSizeTextBuilder(\n"
                  "    const TextSpan(text: 'builder 自定义渲染'),\n"
                  "    layout: const FlAutoSizeTextLayout(maxLines: 1),\n"
                  "    builder: (BuildContext context, FlAutoSizeTextData data) => SelectableText.rich(\n"
                  "      data.textSpan as TextSpan,\n"
                  "      style: data.style,\n"
                  "      textScaler: data.textScaler,\n"
                  "      maxLines: data.maxLines,\n"
                  "      textDirection: data.textDirection,\n"
                  "      textHeightBehavior: data.textHeightBehavior,\n"
                  "      textAlign: TextAlign.center,\n"
                  "    ),\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 220,
                height: 48,
                child: FlAutoSizeTextBuilder(
                  const TextSpan(text: 'builder 自定义渲染'),
                  layout: const FlAutoSizeTextLayout(maxLines: 1),
                  builder: (BuildContext context, FlAutoSizeTextData data) => SelectableText.rich(
                    data.textSpan as TextSpan,
                    style: data.style,
                    textScaler: data.textScaler,
                    maxLines: data.maxLines,
                    textDirection: data.textDirection,
                    textHeightBehavior: data.textHeightBehavior,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'WidgetSpan：不支持自动缩放',
          description: '内容包含 WidgetSpan 时组件会跳过字号测量，按原始字号直接渲染，WidgetSpan 内的组件也不会随字号变化。',
          children: [
            DemoItem(
              title: '含 WidgetSpan 的对比',
              description:
                  '两个预览框宽度相同：上方含 WidgetSpan，字号保持 24、星形图标保持 20，超出部分被省略；'
                  '下方普通文本自动缩小到能完整放下。',
              note: '上：含 WidgetSpan，不缩放；下：普通文本，自动缩放。',
              code:
                  "SizedBox(\n"
                  "  width: 140,\n"
                  "  height: 40,\n"
                  "  child: FlText.rich(\n"
                  "    const TextSpan(\n"
                  "      children: [\n"
                  "        WidgetSpan(child: Icon(Icons.star, size: 20, color: Colors.amber)),\n"
                  "        TextSpan(text: ' 图标文本不缩放'),\n"
                  "      ],\n"
                  "    ),\n"
                  "    fontSize: 24,\n"
                  "    maxLines: 1,\n"
                  "    overflow: TextOverflow.ellipsis,\n"
                  "    autoSizeOptions: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24),\n"
                  "  ),\n"
                  ")",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PreviewBox(
                    width: 140,
                    height: 40,
                    child: FlText.rich(
                      const TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(child: Icon(Icons.star, size: 20, color: Colors.amber)),
                          TextSpan(text: ' 图标文本不缩放'),
                        ],
                      ),
                      fontSize: 24,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      autoSizeOptions: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24),
                    ),
                  ),
                  8.heightBox,
                  _PreviewBox(
                    width: 140,
                    height: 40,
                    child: FlText(
                      '图标文本不缩放',
                      fontSize: 24,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      autoSizeOptions: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '字号策略',
          description: 'minFontSize / maxFontSize / stepGranularity 控制连续缩放，presetFontSizes 则只在预置字号中挑选。',
          children: [
            DemoItem(
              title: 'min / max / stepGranularity',
              description: '步长越大，字号变化越粗糙；minFontSize 需是步长的整数倍。',
              code:
                  "FlAutoSizeTextBuilder(\n"
                  "  const TextSpan(text: 'stepGranularity 步长控制'),\n"
                  "  options: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 32, stepGranularity: 8),\n"
                  "  layout: const FlAutoSizeTextLayout(maxLines: 1),\n"
                  "  builder: (BuildContext context, FlAutoSizeTextData data) => Text.rich(\n"
                  "    data.textSpan,\n"
                  "    style: data.style,\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 200,
                height: 48,
                child: FlAutoSizeTextBuilder(
                  const TextSpan(text: 'stepGranularity 步长控制'),
                  options: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 32, stepGranularity: 8),
                  layout: const FlAutoSizeTextLayout(maxLines: 1),
                  builder: _textBuilder(),
                ),
              ),
            ),
            DemoItem(
              title: 'presetFontSizes',
              description: '只在预置字号中挑选（必须降序），不会产生中间字号。',
              code:
                  "FlAutoSizeTextBuilder(\n"
                  "  const TextSpan(text: '预置字号 presetFontSizes'),\n"
                  "  options: const FlAutoSizeOptions(presetFontSizes: [40, 32, 24, 16, 12]),\n"
                  "  layout: const FlAutoSizeTextLayout(maxLines: 1),\n"
                  "  builder: (BuildContext context, FlAutoSizeTextData data) => Text.rich(\n"
                  "    data.textSpan,\n"
                  "    style: data.style,\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 200,
                height: 52,
                child: FlAutoSizeTextBuilder(
                  const TextSpan(text: '预置字号 presetFontSizes'),
                  options: const FlAutoSizeOptions(presetFontSizes: [40, 32, 24, 16, 12]),
                  layout: const FlAutoSizeTextLayout(maxLines: 1),
                  builder: _textBuilder(),
                ),
              ),
            ),
            DemoItem(
              title: 'wrapWords',
              description: 'true 时允许换行；false 时会持续缩小直到最长的单词能放进一行。',
              code:
                  "FlAutoSizeTextBuilder(\n"
                  "  const TextSpan(text: 'FlutterAutoSizeText wrapWords'),\n"
                  "  options: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24, wrapWords: true),\n"
                  "  layout: const FlAutoSizeTextLayout(maxLines: 2),\n"
                  "  builder: (BuildContext context, FlAutoSizeTextData data) => Text.rich(\n"
                  "    data.textSpan,\n"
                  "    style: data.style,\n"
                  "  ),\n"
                  ")",
              note: '上：wrapWords = true；下：wrapWords = false',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PreviewBox(
                    width: 180,
                    height: 64,
                    child: FlAutoSizeTextBuilder(
                      const TextSpan(text: 'FlutterAutoSizeText wrapWords'),
                      options: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24),
                      layout: const FlAutoSizeTextLayout(maxLines: 2),
                      builder: _textBuilder(),
                    ),
                  ),
                  8.heightBox,
                  _PreviewBox(
                    width: 180,
                    height: 64,
                    child: FlAutoSizeTextBuilder(
                      const TextSpan(text: 'FlutterAutoSizeText wrapWords'),
                      options: const FlAutoSizeOptions(minFontSize: 8, maxFontSize: 24, wrapWords: false),
                      layout: const FlAutoSizeTextLayout(maxLines: 2),
                      builder: _textBuilder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '溢出兜底',
          description: '缩到 minFontSize 仍放不下时展示替代组件。',
          children: [
            DemoItem(
              title: 'overflowReplacement',
              code:
                  "FlText(\n"
                  "  '超出可用空间的长文本',\n"
                  "  fontSize: 28,\n"
                  "  maxLines: 1,\n"
                  "  autoSizeOptions: const FlAutoSizeOptions(\n"
                  "    minFontSize: 24,\n"
                  "    maxFontSize: 28,\n"
                  "    overflowReplacement: Text('放不下'),\n"
                  "  ),\n"
                  ")",
              child: _PreviewBox(
                width: 120,
                height: 40,
                child: FlText(
                  '超出可用空间的长文本',
                  fontSize: 28,
                  maxLines: 1,
                  autoSizeOptions: const FlAutoSizeOptions(
                    minFontSize: 24,
                    maxFontSize: 28,
                    overflowReplacement: Text('放不下'),
                  ),
                ),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'FlAutoSizeGroup',
          description: '多个文本共用同一个 FlAutoSizeGroup 时，统一取其中最小的字号，适合并排卡片标题对齐。',
          children: [
            DemoItem(
              title: '字号同步',
              code:
                  "final FlAutoSizeGroup group = FlAutoSizeGroup();\n\n"
                  "FlText('短', fontSize: 30, maxLines: 1,\n"
                  "  autoSizeOptions: FlAutoSizeOptions(group: group, minFontSize: 10, maxFontSize: 30))\n"
                  "FlText('更长的一段标题', fontSize: 30, maxLines: 1,\n"
                  "  autoSizeOptions: FlAutoSizeOptions(group: group, minFontSize: 10, maxFontSize: 30))",
              note: '两个文本框宽度不同，但最终字号一致。',
              child: const _GroupDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _GroupDemo extends StatefulWidget {
  const _GroupDemo();

  @override
  State<_GroupDemo> createState() => _GroupDemoState();
}

class _GroupDemoState extends State<_GroupDemo> {
  final FlAutoSizeGroup group = FlAutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewBox(
          width: 260,
          height: 44,
          child: FlText(
            '短',
            fontSize: 30,
            maxLines: 1,
            autoSizeOptions: FlAutoSizeOptions(group: group, minFontSize: 10, maxFontSize: 30),
          ),
        ),
        8.heightBox,
        _PreviewBox(
          width: 150,
          height: 44,
          child: FlText(
            '更长的一段标题',
            fontSize: 30,
            maxLines: 1,
            autoSizeOptions: FlAutoSizeOptions(group: group, minFontSize: 10, maxFontSize: 30),
          ),
        ),
      ],
    );
  }
}

/// 固定尺寸的预览框，用于观察自动缩放效果
class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.width, required this.height, required this.child});

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: 10.borderRadiusAll,
      ),
      child: child,
    );
  }
}
