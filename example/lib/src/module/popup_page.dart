import 'dart:async';

import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Popup',
      description:
          '弹层建立在 Navigator 之上：GeneralDialog、ActionDialog、ModalBox、BottomSheet 与 Cupertino 模态都可通过 closePopup 返回结果。',
      sections: [
        DemoSection(
          title: '通用对话框',
          description: 'GeneralDialogOptions 控制遮罩、动画时长、进入方向与安全区。',
          children: [
            DemoItem(
              title: '进入方向',
              code: r"""
widget.popupGeneralDialog(
  options: GeneralDialogOptions(fromStyle: PopupFromStyle.fromBottom),
);
""",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final PopupFromStyle style in PopupFromStyle.values)
                    FlButton(
                      category: FlButtonCategory.outlined,
                      onPressed: () => _demoDialog(context, style),
                      child: Text(style.name),
                    ),
                ],
              ),
            ),
            DemoItem(
              title: '接收返回值',
              description: '通用弹窗的 pageBuilder 拿到的是全屏约束，原始卡片需要用 Center 包裹，才会按内容高度居中显示。',
              code: r"""
final result = await dialog.popupGeneralDialog<String>();
showToast('返回值：$result');
""",
              child: FlButton(
                onPressed: () async {
                  final String? result = await _valueDialog(context).popupGeneralDialog<String>();
                  if (result != null) unawaited(showToast('返回值：$result', iconStyle: ToastIconStyle.success));
                },
                child: const Text('选择并返回'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'ActionDialog',
          description: '带标题、内容、分隔线与操作按钮的对话框，可叠加 ModalBoxOptions。',
          children: [
            DemoItem(
              title: '标准操作对话框',
              code: r"""
ActionDialog(
  options: const ModalBoxOptions(borderRadius: BorderRadius.all(Radius.circular(16))),
  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
  title: const FlText('提示', fontWeight: FontWeight.w700),
  content: const Padding(
    padding: EdgeInsets.only(top: 10),
    child: FlText('确定要继续吗？'),
  ),
  dividerColor: Theme.of(context).colorScheme.outlineVariant,
  actions: [
    FlButton(onPressed: () => closePopup(false), child: const Text('取消')),
    FlButton(onPressed: () => closePopup(true), child: const Text('确定')),
  ],
).show();
""",
              child: FlButton(
                onPressed: () async {
                  final bool? result = await _actionDialog(context).show<bool>();
                  if (result != null) unawaited(showToast(result ? '已确定' : '已取消'));
                },
                child: const Text('打开 ActionDialog'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'ModalBox',
          description: '轻量模态容器，适合自定义布局；通过 ModalBoxOptions 控制颜色、圆角、模糊与点击遮罩。',
          children: [
            DemoItem(
              title: '自定义 ModalBox',
              code: r"""
ModalBox(
  options: ModalBoxOptions(
    backgroundColor: Colors.black26,
    onModalTap: closePopup,
  ),
  child: card,
).popupGeneralDialog();
""",
              child: FlButton(
                onPressed: () => _modalBox(context).popupGeneralDialog(),
                child: const Text('打开 ModalBox'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'BottomSheet',
          description: 'ModalBottomSheetOptions 支持 shape / constraints / useSafeArea / enableDrag。',
          children: [
            DemoItem(
              title: 'Material 底部弹层',
              code: r"""
widget.popupModalBottomSheet(
  options: const ModalBottomSheetOptions(
    useSafeArea: true,
    constraints: BoxConstraints(maxWidth: 620),
  ),
);
""",
              child: FlButton(
                onPressed: () => _bottomSheet(context).popupModalBottomSheet<dynamic>(),
                child: const Text('打开 BottomSheet'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Cupertino 模态',
          description: 'CupertinoModalPopupOptions 支持 filter / semanticsDismissible。',
          children: [
            DemoItem(
              title: 'Cupertino 弹层',
              code: r"""
widget.popupCupertinoModal(
  options: const CupertinoModalPopupOptions(
    barrierColor: Colors.black26,
  ),
);
""",
              child: FlButton(
                category: FlButtonCategory.filledTonal,
                onPressed: () => _cupertinoSheet(context).popupCupertinoModal<dynamic>(),
                child: const Text('打开 Cupertino 弹层'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: '配置速查',
          children: [
            const DemoItem(
              child: DemoValues([
                DemoValue('barrierColor', '遮罩颜色，默认 Cupertino 模态色'),
                DemoValue('barrierDismissible', '点击遮罩是否关闭'),
                DemoValue('useRootNavigator', '是否使用根 Navigator'),
                DemoValue('anchorPoint', '弹层锚点'),
                DemoValue('fromStyle', 'fromLeft / Right / Top / Bottom / Center'),
                DemoValue('transitionDuration', '显示与隐藏的动画时长'),
                DemoValue('useSafeArea', 'GeneralDialog / BottomSheet 安全区'),
                DemoValue('constraints', 'BottomSheet 尺寸约束'),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _demoDialog(BuildContext context, PopupFromStyle style) async {
    final String? result = await _valueDialog(context).popupGeneralDialog<String>(
      options: GeneralDialogOptions(fromStyle: style),
    );
    if (result != null && context.mounted) {
      unawaited(showToast('$style -> $result'));
    }
  }

  Widget _valueDialog(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Material(
          color: colors.surface,
          borderRadius: 16.borderRadiusAll,
          child: Universal(
            padding: const EdgeInsets.all(20),
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlText('选择一个结果', fontSize: 18, fontWeight: FontWeight.w700),
              12.heightBox,
              Row(
                children: [
                  Expanded(
                    child: FlButton(
                      category: FlButtonCategory.filledTonal,
                      onPressed: () => closePopup('A'),
                      child: const Text('A'),
                    ),
                  ),
                  10.widthBox,
                  Expanded(
                    child: FlButton(
                      category: FlButtonCategory.filledTonal,
                      onPressed: () => closePopup('B'),
                      child: const Text('B'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ActionDialog _actionDialog(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return ActionDialog(
      options: const ModalBoxOptions(borderRadius: BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      title: const FlText('提示', fontWeight: FontWeight.w700),
      content: const Padding(padding: EdgeInsets.only(top: 10), child: FlText('确定要继续吗？')),
      dividerColor: colors.outlineVariant,
      actions: [
        Expanded(
          child: Universal(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            onTap: () => closePopup(false),
            child: const FlText('取消'),
          ),
        ),
        Expanded(
          child: Universal(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            onTap: () => closePopup(true),
            child: FlText('确定', color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _modalBox(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return ModalBox(
      options: ModalBoxOptions(
        gaussian: 2,
        backgroundColor: Colors.black26,
        onModalTap: closePopup,
      ),
      child: Universal(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: colors.surface, borderRadius: 16.borderRadiusAll),
        mainAxisSize: MainAxisSize.min,
        children: [
          const FlText('ModalBox', fontSize: 18, fontWeight: FontWeight.w700),
          10.heightBox,
          const FlText('点击遮罩或按钮关闭', textAlign: TextAlign.center),
          16.heightBox,
          FlButton(onPressed: () => closePopup('modal'), child: const Text('关闭')),
        ],
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Universal(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: 2.borderRadiusAll),
          ),
        ),
        16.heightBox,
        const FlText('BottomSheet', fontSize: 18, fontWeight: FontWeight.w700),
        8.heightBox,
        const FlText('支持 shape、constraints、useSafeArea 与拖拽关闭。'),
        18.heightBox,
        FlButton(onPressed: () => closePopup('sheet'), child: const Text('确定')),
      ],
    );
  }

  Widget _cupertinoSheet(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Material(
          color: colors.surface,
          borderRadius: 16.borderRadiusAll,
          child: Universal(
            padding: const EdgeInsets.all(20),
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlText('CupertinoModalPopup', fontSize: 18, fontWeight: FontWeight.w700),
              8.heightBox,
              const FlText('由 CupertinoModalPopupOptions 控制遮罩与语义关闭。'),
              16.heightBox,
              FlButton(onPressed: () => closePopup('cupertino'), child: const Text('关闭')),
            ],
          ),
        ),
      ),
    );
  }
}
