import 'package:example/src/demo/demo_widgets.dart';
import 'package:example/src/module/animation_page.dart';
import 'package:example/src/module/builder_page.dart';
import 'package:example/src/module/button_page.dart';
import 'package:example/src/module/context_page.dart';
import 'package:example/src/module/controller_page.dart';
import 'package:example/src/module/date_time_page.dart';
import 'package:example/src/module/function_page.dart';
import 'package:example/src/module/iterable_page.dart';
import 'package:example/src/module/list_map_page.dart';
import 'package:example/src/module/logcat_page.dart';
import 'package:example/src/module/navigator_page.dart';
import 'package:example/src/module/num_page.dart';
import 'package:example/src/module/object_page.dart';
import 'package:example/src/module/overlay_page.dart';
import 'package:example/src/module/popup_page.dart';
import 'package:example/src/module/progress_indicator_page.dart';
import 'package:example/src/module/regexp_page.dart';
import 'package:example/src/module/state_components_page.dart';
import 'package:example/src/module/string_page.dart';
import 'package:example/src/module/text_page.dart';
import 'package:example/src/module/universal_page.dart';
import 'package:example/src/module/widget_extension_page.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class DemoEntry {
  const DemoEntry({required this.title, required this.subtitle, required this.icon, required this.builder});

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
}

class DemoCategory {
  const DemoCategory({required this.title, required this.subtitle, required this.entries});

  final String title;
  final String subtitle;
  final List<DemoEntry> entries;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _searchController = SearchController();
  String _query = '';

  static final List<DemoCategory> _categories = <DemoCategory>[
    DemoCategory(
      title: '基础组件',
      subtitle: '文本、按钮、布局、动画、进度与正则',
      entries: <DemoEntry>[
        DemoEntry(
          title: 'Text & SelectableText',
          subtitle: 'FlText / FlRichText / FlSelectableText',
          icon: Icons.text_fields_rounded,
          builder: (_) => const TextPage(),
        ),
        DemoEntry(
          title: 'Button & IconLabel',
          subtitle: 'FlButton 五种类型、图标按钮、图文组合',
          icon: Icons.smart_button_rounded,
          builder: (_) => const ButtonPage(),
        ),
        DemoEntry(
          title: 'Universal',
          subtitle: '布局、尺寸、滚动、手势、裁剪、安全区',
          icon: Icons.dashboard_customize_rounded,
          builder: (_) => const UniversalPage(),
        ),
        DemoEntry(
          title: 'FlAnimation',
          subtitle: '淡入淡出与水平 / 垂直晃动',
          icon: Icons.animation_rounded,
          builder: (_) => const AnimationPage(),
        ),
        DemoEntry(
          title: 'FlProgressIndicator',
          subtitle: '线性、环形、下拉刷新进度配置',
          icon: Icons.donut_large_rounded,
          builder: (_) => const ProgressIndicatorPage(),
        ),
        DemoEntry(
          title: 'FlRegExp',
          subtitle: 'RegExp 封装、匹配、命名分组',
          icon: Icons.code_rounded,
          builder: (_) => const RegExpPage(),
        ),
      ],
    ),
    DemoCategory(
      title: '构建器与状态',
      subtitle: 'Future / Stream / Value / Listenable 局部刷新',
      entries: <DemoEntry>[
        DemoEntry(
          title: 'Future & Stream Builder',
          subtitle: 'FlFutureBuilder / CustomFutureBuilder 等',
          icon: Icons.stream_rounded,
          builder: (_) => const BuilderPage(),
        ),
        DemoEntry(
          title: 'State Components',
          subtitle: 'ValueBuilder、ChangedBuilder、生命周期回调',
          icon: Icons.widgets_rounded,
          builder: (_) => const StateComponentsPage(),
        ),
      ],
    ),
    DemoCategory(
      title: '弹层与路由',
      subtitle: 'Toast、Loading、Overlay、Dialog、BottomSheet、Navigator',
      entries: <DemoEntry>[
        DemoEntry(
          title: 'Overlay / Toast / Loading',
          subtitle: '全局浮层、动画样式、FlPopScope 返回拦截',
          icon: Icons.layers_rounded,
          builder: (_) => const OverlayPage(),
        ),
        DemoEntry(
          title: 'Popup',
          subtitle: 'ActionDialog、ModalBox、BottomSheet、Cupertino',
          icon: Icons.open_in_new_rounded,
          builder: (_) => const PopupPage(),
        ),
        DemoEntry(
          title: 'Navigator',
          subtitle: 'push / pop / maybePop / SnackBar / Menu',
          icon: Icons.route_rounded,
          builder: (_) => const NavigatorPage(),
        ),
      ],
    ),
    DemoCategory(
      title: '扩展方法',
      subtitle: 'String、Number、Iterable、List / Map、日期、Context、Widget…',
      entries: <DemoEntry>[
        DemoEntry(
          title: 'String',
          subtitle: '解析、编解码、格式化、正则与颜色',
          icon: Icons.abc_rounded,
          builder: (_) => const StringPage(),
        ),
        DemoEntry(
          title: 'Number',
          subtitle: '数学、时长、尺寸、存储与中文数字',
          icon: Icons.numbers_rounded,
          builder: (_) => const NumberPage(),
        ),
        DemoEntry(
          title: 'Iterable',
          subtitle: '分组、排序、聚合、分块、映射',
          icon: Icons.repeat_rounded,
          builder: (_) => const IterablePage(),
        ),
        DemoEntry(
          title: 'List & Map',
          subtitle: '列表构建、切片、编解码、Map 转换',
          icon: Icons.data_array_rounded,
          builder: (_) => const ListMapPage(),
        ),
        DemoEntry(
          title: 'DateTime & Duration',
          subtitle: '日期格式化、区间、定时与时长运算',
          icon: Icons.schedule_rounded,
          builder: (_) => const DateTimePage(),
        ),
        DemoEntry(
          title: 'Object & Binding',
          subtitle: 'let / also / log / ValueNotifier / Binding',
          icon: Icons.data_object_rounded,
          builder: (_) => const ObjectPage(),
        ),
        DemoEntry(
          title: 'Context & Focus',
          subtitle: '主题、MediaQuery、RenderBox、焦点与导航',
          icon: Icons.window_rounded,
          builder: (_) => const ContextPage(),
        ),
        DemoEntry(
          title: 'Widget Extensions',
          subtitle: '链式 padding / size / clip / gesture / decoration',
          icon: Icons.extension_rounded,
          builder: (_) => const WidgetExtensionPage(),
        ),
        DemoEntry(
          title: 'Controller & GlobalKey',
          subtitle: 'TextEditingController、FocusNode、TabController、截图',
          icon: Icons.key_rounded,
          builder: (_) => const ControllerPage(),
        ),
        DemoEntry(
          title: 'Function',
          subtitle: '防抖、节流与可取消的 FlDebouncer / FlThrottler',
          icon: Icons.timer_rounded,
          builder: (_) => const FunctionPage(),
        ),
      ],
    ),
    DemoCategory(
      title: '调试',
      subtitle: '日志收集与悬浮日志入口',
      entries: <DemoEntry>[
        DemoEntry(
          title: 'FlLogcat',
          subtitle: 'runZone、日志类型、悬浮入口',
          icon: Icons.terminal_rounded,
          builder: (_) => const LogcatPage(),
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DemoCategory> get _filteredCategories {
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) return _categories;
    return _categories
        .map(
          (DemoCategory category) => DemoCategory(
            title: category.title,
            subtitle: category.subtitle,
            entries: category.entries
                .where(
                  (DemoEntry entry) =>
                      entry.title.toLowerCase().contains(query) || entry.subtitle.toLowerCase().contains(query),
                )
                .toList(),
          ),
        )
        .where((DemoCategory category) => category.entries.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final List<DemoCategory> categories = _filteredCategories;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 1,
            backgroundColor: colors.surface,
            title: const Text('fl_extended'),
            actions: [
              IconButton(
                tooltip: '日志悬浮入口',
                icon: const Icon(Icons.terminal_rounded),
                onPressed: () {
                  FlLogcat().isRunning = true;
                  FlLogcat().show();
                  showToast('已开启日志悬浮入口', iconStyle: ToastIconStyle.info);
                },
              ),
              const DemoThemeToggle(),
              const SizedBox(width: 4),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _HomeHeader(count: _categories.fold<int>(0, (int sum, DemoCategory c) => sum + c.entries.length)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: SearchBar(
                controller: _searchController,
                hintText: '搜索组件、扩展方法…',
                elevation: const WidgetStatePropertyAll<double>(0),
                leading: const Icon(Icons.search_rounded),
                trailing: _query.isEmpty
                    ? null
                    : <Widget>[
                        IconButton(
                          tooltip: '清空',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                      ],
                onChanged: (String value) => setState(() => _query = value),
              ),
            ),
          ),
          if (categories.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: colors.outline),
                    12.heightBox,
                    Text('没有找到相关示例', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            )
          else
            for (final DemoCategory category in categories)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverToBoxAdapter(child: _CategorySection(category: category)),
              ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              child: Center(
                child: Text(
                  'fl_extended 5.0.0 · 点击卡片查看完整示例与源码',
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: 24.borderRadiusAll,
        gradient: LinearGradient(
          colors: <Color>[colors.primary, colors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.onPrimary.withValues(alpha: 0.18),
                  borderRadius: 14.borderRadiusAll,
                ),
                child: Icon(Icons.widgets_rounded, color: colors.onPrimary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.onPrimary.withValues(alpha: 0.16),
                  borderRadius: 20.borderRadiusAll,
                ),
                child: Text('$count 个示例', style: theme.textTheme.labelSmall?.copyWith(color: colors.onPrimary)),
              ),
            ],
          ),
          16.heightBox,
          Text(
            'Flutter 扩展工具集',
            style: theme.textTheme.headlineMedium?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w800),
          ),
          6.heightBox,
          Text(
            '组件、构建器、Overlay、路由与常用扩展方法，每个示例都附带说明与可复制的代码。',
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.onPrimary.withValues(alpha: 0.86), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category});

  final DemoCategory category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Column(
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
              child: Text(category.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            8.widthBox,
            Flexible(
              child: Text(
                category.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
              ),
            ),
          ],
        ),
        12.heightBox,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final int columns = width >= 1000
                ? 3
                : width >= 660
                ? 2
                : 1;
            const double gap = 10;
            final double cardWidth = (width - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final DemoEntry entry in category.entries)
                  SizedBox(
                    width: cardWidth,
                    child: _EntryCard(entry: entry),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final DemoEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: 16.borderRadiusAll,
      child: InkWell(
        borderRadius: 16.borderRadiusAll,
        onTap: () => push(entry.builder(context)),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: 13.borderRadiusAll),
                child: Icon(entry.icon, color: colors.onPrimaryContainer, size: 22),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    3.heightBox,
                    Text(
                      entry.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              4.widthBox,
              Icon(Icons.chevron_right_rounded, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
