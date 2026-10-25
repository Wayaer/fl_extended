import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// 示例全局主题模式（默认跟随系统）
final ValueNotifier<ThemeMode> demoThemeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

/// 白天 / 黑夜切换按钮
class DemoThemeToggle extends StatelessWidget {
  const DemoThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: demoThemeMode,
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return IconButton(
          tooltip: isDark ? '切换到白天' : '切换到黑夜',
          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          onPressed: () => demoThemeMode.value = isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
    );
  }
}

/// 示例页面统一骨架
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.title,
    required this.description,
    required this.sections,
    this.actions,
  });

  final String title;
  final String description;
  final List<Widget> sections;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        title: Text(title),
        actions: <Widget>[
          ...?actions,
          const DemoThemeToggle(),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          _DemoBanner(title: title, description: description),
          20.heightBox,
          ...sections,
        ],
      ),
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: 20.borderRadiusAll,
        gradient: LinearGradient(
          colors: <Color>[colors.primary, colors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          8.heightBox,
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.86),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 一个功能分区（卡片）
class DemoSection extends StatelessWidget {
  const DemoSection({super.key, required this.title, this.description, required this.children});

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(color: colors.primary, borderRadius: 2.borderRadiusAll),
              ),
              8.widthBox,
              Expanded(
                child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (description != null) ...[
            6.heightBox,
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(description!, style: theme.textTheme.bodySmall),
            ),
          ],
          12.heightBox,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: 18.borderRadiusAll,
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < children.length; index++) ...[
                  if (index > 0) Divider(height: 26, color: colors.outlineVariant.withValues(alpha: 0.5)),
                  children[index],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 单项示例：标题 + 说明 + 预览 + 代码
class DemoItem extends StatelessWidget {
  const DemoItem({
    super.key,
    this.title,
    this.description,
    this.code,
    this.child,
    this.note,
  });

  final String? title;
  final String? description;
  final String? code;
  final Widget? child;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        if (description != null) ...[
          4.heightBox,
          Text(description!, style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
        ],
        if (child != null) ...[
          10.heightBox,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: 12.borderRadiusAll,
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: child,
          ),
        ],
        if (code != null) ...[
          10.heightBox,
          DemoCode(code!),
        ],
        if (note != null) ...[
          8.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, size: 15, color: colors.tertiary),
              6.widthBox,
              Expanded(
                child: Text(note!, style: theme.textTheme.bodySmall?.copyWith(color: colors.tertiary)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 代码块，支持一键复制
class DemoCode extends StatelessWidget {
  const DemoCode(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: 12.borderRadiusAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 4, top: 2),
            child: Row(
              children: [
                Text(
                  'DART',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: '复制代码',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  onPressed: () {
                    code.toClipboard();
                    showToast('代码已复制', iconStyle: ToastIconStyle.success, duration: const Duration(milliseconds: 1200));
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SelectableText(
              code.trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontFamilyFallback: <String>['Menlo', 'Consolas'],
                fontSize: 12,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 表达式 -> 结果 的对照行
class DemoValue {
  const DemoValue(this.expression, this.result);

  final String expression;
  final String result;
}

class DemoValues extends StatelessWidget {
  const DemoValues(this.values, {super.key});

  final List<DemoValue> values;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final DemoValue value in values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SelectableText(
                    value.expression,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontFamilyFallback: <String>['Menlo', 'Consolas'],
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
                10.widthBox,
                Expanded(
                  flex: 4,
                  child: Text(
                    value.result,
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 用于展示源码生命周期的日志面板
class DemoConsole extends StatelessWidget {
  const DemoConsole(this.lines, {super.key});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 72, maxHeight: 180),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: 10.borderRadiusAll,
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Text(
          lines.isEmpty ? '暂无日志' : lines.join('\n'),
          style: TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: const <String>['Menlo', 'Consolas'],
            fontSize: 11.5,
            height: 1.5,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
