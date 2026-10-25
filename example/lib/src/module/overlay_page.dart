import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DemoPage(
      title: 'Overlay / Toast / Loading',
      description:
          '所有浮层都挂在 FlExtended 的全局 navigatorKey 上，可在任意页面调用。'
          'Toast / Loading 同时只展示一个，自定义 Overlay 可缓存并单独关闭。',
      actions: [
        IconButton(
          tooltip: '关闭所有浮层',
          icon: const Icon(Icons.layers_clear_rounded),
          onPressed: () {
            hideAllOverlay();
            showToast('已关闭所有浮层');
          },
        ),
      ],
      sections: [
        DemoSection(
          title: 'FlPopScope',
          description: '页面内存在 Toast / Loading / 缓存 Overlay 时，返回键会先关闭浮层，而不是直接退出页面。',
          children: [
            DemoItem(
              title: '返回拦截',
              code: r"""
FlPopScope(
  canPop: true,
  canHideOverlay: true,
  onPopInvokedWithResult: (didPop, result, didHideOverlay) {
    // didHideOverlay == true：本次返回只关闭了浮层
  },
  child: child,
)
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlButton(
                    onPressed: () => showToast('此时按返回键会先关闭 Toast', iconStyle: ToastIconStyle.info),
                    child: const Text('显示 Toast 后按返回键'),
                  ),
                  8.heightBox,
                  const Text('提示：本示例页面已使用 FlPopScope 包裹，返回时会优先关闭浮层。'),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'SnackBar',
          description: '通过 scaffoldMessengerKey 在任意位置显示，支持 action。',
          children: [
            DemoItem(
              title: 'showSnackBar',
              code: r"""
showSnackBar(SnackBar(
  content: const Text('已保存'),
  action: SnackBarAction(label: '撤销', onPressed: () {}),
));
""",
              child: FlButton(
                onPressed: () => showSnackBar(
                  SnackBar(
                    content: const Text('已保存'),
                    action: SnackBarAction(label: '撤销', onPressed: () => showToast('已撤销')),
                  ),
                ),
                child: const Text('显示 SnackBar'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Toast',
          description: '图标、颜色、方向、对齐、动画、时长与点击回调都可配置。',
          children: [
            DemoItem(
              title: '图标样式',
              code: "showToast('操作成功', iconStyle: ToastIconStyle.success)",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ToastIconStyle.values
                    .map(
                      (ToastIconStyle style) => FlButton(
                        category: FlButtonCategory.outlined,
                        onPressed: () => showToast(style.name, iconStyle: style),
                        child: Text(style.name),
                      ),
                    )
                    .toList(),
              ),
            ),
            DemoItem(
              title: '位置与动画',
              code:
                  "showToast(\n"
                  "  '顶部 Toast',\n"
                  "  options: ToastOptions(alignment: Alignment.topCenter),\n"
                  ");\n"
                  "showToast(\n"
                  "  '左右晃动',\n"
                  "  animationStyle: FlAnimationStyle.horizontalHunting,\n"
                  ");",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () => showToast('顶部 Toast', options: const ToastOptions(alignment: Alignment.topCenter)),
                    child: const Text('顶部'),
                  ),
                  FlButton(
                    onPressed: () => showToast(
                      '左右晃动',
                      animationStyle: FlAnimationStyle.horizontalHunting,
                    ),
                    child: const Text('水平晃动'),
                  ),
                  FlButton(
                    onPressed: () => showToast(
                      '自定义时长',
                      duration: const Duration(seconds: 3),
                      animationStyle: FlAnimationStyle.fade,
                    ),
                    child: const Text('3 秒'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: 'await 串联 Toast',
              description: 'showToast 返回的 Future 在 Toast 关闭后完成。',
              code: r"""
await showToast('第一个 Toast');
await showToast('第一个关闭后显示第二个');
""",
              child: FlButton(
                onPressed: () async {
                  await showToast('第一个 Toast');
                  await showToast('第一个关闭后显示第二个');
                },
                child: const Text('依次显示两个 Toast'),
              ),
            ),
            DemoItem(
              title: '自定义内容',
              code: r"""
showToast(
  '自定义内容',
  builder: (context, content) => Row(children: [
    Icon(content.iconStyle?.icon ?? Icons.info),
    const SizedBox(width: 8),
    Text(content.text),
  ]),
);
""",
              child: FlButton(
                onPressed: () => showToast(
                  '自定义 Toast 内容',
                  iconStyle: ToastIconStyle.info,
                  builder: (BuildContext context, ToastContent content) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(content.iconStyle?.icon ?? Icons.info_rounded, color: content.color),
                      8.widthBox,
                      Text(content.text, style: content.textStyle),
                    ],
                  ),
                ),
                child: const Text('自定义 Toast'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Loading',
          description: '默认拦截背景点击，可通过 onModalTap 允许点击遮罩关闭。',
          children: [
            DemoItem(
              title: '默认 Loading',
              code: "showLoading();\nawait Duration(seconds: 2).delayed(hideLoading);",
              child: FlButton(
                onPressed: () {
                  showLoading();
                  const Duration(milliseconds: 1600).delayed(hideLoading);
                },
                child: const Text('显示 Loading 1.6s'),
              ),
            ),
            DemoItem(
              title: '自定义进度条',
              code:
                  "showLoading(options: LoadingOptions(\n"
                  "  progressIndicator: ProgressIndicatorStyle.circular.options,\n"
                  "  builder: (_, options) => FlProgressIndicator(options!),\n"
                  "));",
              child: FlButton(
                onPressed: () {
                  showLoading(
                    options: LoadingOptions(
                      backgroundColor: colors.surface.withValues(alpha: 0.6),
                      builder: (_, ProgressIndicatorOptions? progress) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlProgressIndicator(ProgressIndicatorStyle.circular.options),
                          10.heightBox,
                          const FlText('Loading...', fontSize: 13),
                        ],
                      ),
                    ),
                  );
                  const Duration(milliseconds: 1600).delayed(hideLoading);
                },
                child: const Text('自定义 Loading'),
              ),
            ),
            DemoItem(
              title: '点击遮罩关闭',
              code: "showLoading(options: LoadingOptions(onModalTap: hideLoading))",
              child: FlButton(
                onPressed: () => showLoading(
                  options: LoadingOptions(
                    backgroundColor: colors.surface.withValues(alpha: 0.6),
                    onModalTap: hideLoading,
                  ),
                ),
                child: const Text('点击遮罩关闭 Loading'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '自定义 Overlay',
          description: 'FlOverlay().show 可缓存条目并通过 remove / hide / hideAllOverlay 关闭。',
          children: [
            DemoItem(
              title: 'showOverlay',
              description: 'Overlay 不在页面 Material 之下，内容需要用 Material / DefaultTextStyle 提供主题文字样式。',
              code: r"""
FlOverlayEntry? entry;
entry = Universal(
  color: Colors.black38,
  alignment: Alignment.center,
  onTap: () => entry?.remove(),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: Universal(
        onTap: () {},
        padding: const EdgeInsets.all(18),
        mainAxisSize: MainAxisSize.min,
        children: [...],
      ),
    ),
  ),
).showOverlay();
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FlButton(
                    onPressed: () {
                      FlOverlayEntry? entry;
                      entry = Universal(
                        color: Colors.black38,
                        alignment: Alignment.center,
                        onTap: () => entry?.remove(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Material(
                            color: colors.surface,
                            borderRadius: 16.borderRadiusAll,
                            child: Universal(
                              onTap: () {},
                              padding: const EdgeInsets.all(18),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FlText('Custom Overlay', fontWeight: FontWeight.w700, fontSize: 16),
                                8.heightBox,
                                const FlText('点击空白处或按钮关闭'),
                                12.heightBox,
                                FlButton(
                                  onPressed: () => entry?.remove(),
                                  child: const Text('关闭'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).showOverlay();
                    },
                    child: const Text('显示自定义 Overlay'),
                  ),
                  FlButton(
                    category: FlButtonCategory.outlined,
                    onPressed: hideAllOverlay,
                    child: const Text('hideAllOverlay'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
