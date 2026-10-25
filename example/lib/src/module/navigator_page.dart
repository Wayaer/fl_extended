import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final GlobalKey _menuAnchor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Navigator',
      description:
          '顶层 push / pop / maybePop 与 Widget 扩展语义一致：打开的都是目标页面本身；'
          '默认转场读取 FlExtended().pushStyle，也可通过 PageRouteOptions 覆盖。',
      sections: [
        DemoSection(
          title: '打开页面',
          description: '支持 Material / Cupertino、全屏对话框与接收返回值。',
          children: [
            DemoItem(
              title: 'push 并接收返回值',
              description:
                  '在 iOS 上 MaterialPageRoute 也会使用 Cupertino 转场，两者动画几乎一致；这里让 Cupertino 路由打开 Cupertino 风格页面，便于看出差异。',
              code: r"""
final result = await push<String>(
  const DetailPage(),
  options: const PageRouteOptions.material(), // 或 .cupertino()
);
if (result != null) showToast('返回：$result');

// 或者
const DetailPage().push<String>();
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () => _pushAndShowResult(context),
                    child: const Text('push Material'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => _pushAndShowResult(context, maybe: true),
                    child: const Text('push Cupertino'),
                  ),
                  FlButton(
                    category: FlButtonCategory.filledTonal,
                    onPressed: () => _pushAndShowResult(context, maybePop: true),
                    child: const Text('maybePop 返回结果'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'pushReplacement / pushAndRemoveUntil',
              code: r"""
pushReplacement<String, dynamic>(const DetailPage(), result: 'replaced');

pushAndRemoveUntil(
  const DetailPage(),
  predicate: (route) => route.isFirst,
);
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () => pushReplacement<String, dynamic>(
                      const _DetailPage(title: 'pushReplacement'),
                      result: '从 Navigator 页替换',
                    ),
                    child: const Text('pushReplacement'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => pushAndRemoveUntil(
                      const _DetailPage(title: 'pushAndRemoveUntil'),
                      predicate: (Route<dynamic> route) => route.isFirst,
                    ),
                    child: const Text('清栈打开'),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'PageRouteOptions',
          description: '可全局设置默认样式，也可按页面覆盖。',
          children: [
            DemoItem(
              title: 'Material / Cupertino',
              code: r"""
push(
  const DetailPage(),
  options: const PageRouteOptions.cupertino(
    fullscreenDialog: true,
    title: 'Detail',
  ),
);
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () => push(
                      const _DetailPage(title: 'Material 全屏'),
                      options: const PageRouteOptions.material(fullscreenDialog: true),
                    ),
                    child: const Text('Material 全屏'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => push(
                      const _DetailPage(title: 'Cupertino', cupertino: true),
                      options: const PageRouteOptions.cupertino(title: 'Cupertino'),
                    ),
                    child: const Text('Cupertino'),
                  ),
                ],
              ),
            ),
            const DemoItem(
              child: DemoValues([
                DemoValue('style', 'material / cupertino'),
                DemoValue('maintainState', '是否保留页面状态'),
                DemoValue('fullscreenDialog', '是否全屏对话框样式'),
                DemoValue('title', 'Cupertino 路由标题'),
                DemoValue('allowSnapshotting', '是否允许快照'),
                DemoValue('barrierDismissible', '是否可点击遮罩返回'),
                DemoValue('builder', '自定义 PageBuilder'),
              ]),
            ),
          ],
        ),
        DemoSection(
          title: 'pop / maybePop / popUntil',
          description: 'popUntil 会一直弹到 predicate 为 true；maybePop 会走页面自己的 PopScope。',
          children: [
            DemoItem(
              title: '带返回值返回',
              code: r"""
pop<String>('result');          // 直接 pop
context.maybePop<String>('x');  // 尊重 PopScope
popUntil((route) => route.isFirst);
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => pop<String>('直接返回'),
                    child: const Text('pop 返回本页'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: () => popUntil((Route<dynamic> route) => route.isFirst),
                    child: const Text('popUntil 回到首页'),
                  ),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '菜单与 SnackBar',
          description: 'showMenuPopup 使用 RelativeRect 定位，showSnackBar 使用全局 ScaffoldMessenger。',
          children: [
            DemoItem(
              title: 'showMenuPopup',
              code: r"""
final Rect rect = context.getWidgetRectLocalToGlobal();
final value = await showMenuPopup<String>(
  position: RelativeRect.fromRect(rect, Offset.zero & MediaQuery.sizeOf(context)),
  items: const [PopupMenuItem(value: 'a', child: Text('选项 A'))],
);
""",
              child: Row(
                children: [
                  SizedBox(
                    key: _menuAnchor,
                    child: FlButton(
                      onPressed: () => _showMenu(context),
                      child: const Text('打开菜单'),
                    ),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'showSnackBar',
              code: r"""
showSnackBar(SnackBar(
  content: const Text('提示'),
  action: SnackBarAction(label: '撤销', onPressed: () {}),
));
""",
              child: FlButton(
                category: FlButtonCategory.outlined,
                onPressed: () => showSnackBar(
                  SnackBar(
                    content: const Text('来自全局 ScaffoldMessenger'),
                    action: SnackBarAction(label: '知道了', onPressed: () {}),
                  ),
                ),
                child: const Text('显示 SnackBar'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'BuildContext 导航方法',
          children: [
            const DemoItem(
              child: DemoValues([
                DemoValue('context.navigator', 'NavigatorState'),
                DemoValue('context.push / pushNamed', '打开页面'),
                DemoValue('context.pushReplacement', '替换当前页'),
                DemoValue('context.pushAndRemoveUntil', '清栈打开'),
                DemoValue('context.pop / maybePop', '返回并携带 result'),
                DemoValue('context.popUntil', '弹到指定路由'),
                DemoValue('context.canPop()', '是否还能返回'),
                DemoValue('context.overlay', 'Overlay.of(context)'),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pushAndShowResult(BuildContext context, {bool maybe = false, bool maybePop = false}) async {
    final PageRouteOptions options = maybe
        ? const PageRouteOptions.cupertino(title: 'Cupertino')
        : const PageRouteOptions.material();
    final String? result = await push<String>(
      _DetailPage(title: maybe ? 'Cupertino' : 'Material', maybePop: maybePop, cupertino: maybe),
      options: options,
    );
    if (result != null && context.mounted) {
      unawaited(showToast('返回：$result', iconStyle: ToastIconStyle.success));
    }
  }

  Future<void> _showMenu(BuildContext context) async {
    final Rect? rect = _menuAnchor.currentContext?.getWidgetRectLocalToGlobal();
    if (rect == null) return;
    final String? value = await showMenuPopup<String>(
      position: RelativeRect.fromRect(rect, Offset.zero & MediaQuery.sizeOf(context)),
      items: const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: 'A', child: Text('选项 A')),
        PopupMenuItem<String>(value: 'B', child: Text('选项 B')),
        PopupMenuItem<String>(value: 'C', child: Text('选项 C')),
      ],
    );
    if (value != null && context.mounted) unawaited(showToast('选择了 $value'));
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.title, this.maybePop = false, this.cupertino = false});

  final String title;
  final bool maybePop;
  final bool cupertino;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Widget content = SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('这是通过 Navigator 打开的页面', style: theme.textTheme.titleMedium),
              12.heightBox,
              Text('路由样式、标题与是否全屏由 PageRouteOptions 控制。', style: theme.textTheme.bodySmall),
              16.heightBox,
              FlText(
                cupertino ? 'Cupertino 风格页面' : 'Material 风格页面',
                color: colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              20.heightBox,
              FlButton(
                onPressed: () => maybePop ? context.maybePop<String>('maybePop result') : pop<String>('pop result'),
                child: Text(maybePop ? 'maybePop 返回结果' : 'pop 返回结果'),
              ),
            ],
          ),
        ),
      ),
    );
    if (cupertino) {
      return CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(primaryColor: colors.primary),
        child: CupertinoPageScaffold(
          backgroundColor: colors.surface,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: colors.surface,
            middle: Text(title, style: TextStyle(color: colors.onSurface)),
          ),
          // CupertinoPageScaffold 不提供 DefaultTextStyle，补一层主题样式，
          // 避免 FlText 继承到 Flutter 的调试兜底样式（黄色下划线 / 超大字号）。
          child: DefaultTextStyle(style: theme.textTheme.bodyMedium ?? const TextStyle(), child: content),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }
}
