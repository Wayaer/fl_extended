import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final actionsDialog = ActionDialog(
      options: ModalBoxOptions(borderRadius: BorderRadius.circular(10)),
      title: title,
      content: content,
      actions: actions,
    );
    return FlScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      appBar: AppBaFlRichText('Popup'),
      isScroll: true,
      children: [
        const Partition('ActionDialog', marginTop: 0),
        ElevatedText(
          'popup Dialog',
          onTap: () {
            actionsDialog.popupDialog<dynamic>();
          },
        ),
        ElevatedText(
          'popup MaterialDialog',
          onTap: () {
            actionsDialog.popupMaterialDialog<dynamic>();
          },
        ),
        ElevatedText(
          'popup CupertinoDialog',
          onTap: () {
            actionsDialog.popupCupertinoDialog<dynamic>();
          },
        ),
        const Partition('Bottom Sheet'),
        ElevatedText(
          'popup BottomSheet',
          onTap: () {
            const _ActionSheet().popupBottomSheet<dynamic>(
              options: const BottomSheetOptions(backgroundColor: Colors.transparent),
            );
          },
        ),
        ElevatedText(
          'popup BottomSheet - Full screen',
          onTap: () {
            const _ActionSheet().popupBottomSheet<dynamic>(
              options: const BottomSheetOptions(backgroundColor: Colors.transparent),
            );
          },
        ),
        ElevatedText(
          'popup CupertinoModal',
          onTap: () {
            const _ActionSheet().popupCupertinoModal<dynamic>();
          },
        ),
      ],
    );
  }

  Widget get title => const Universal(margin: EdgeInsets.only(top: 16, bottom: 6), child: Text('Title'));

  List<Widget> get actions => [
    Universal(
      expanded: true,
      alignment: Alignment.center,
      onTap: () {
        showToast('Left');
        pop();
      },
      child: const Text('Left'),
    ),
    Universal(
      expanded: true,
      alignment: Alignment.center,
      onTap: () {
        showToast('Center');
        pop();
      },
      child: const Text('Center'),
    ),
    Universal(
      expanded: true,
      alignment: Alignment.center,
      onTap: () {
        showToast('Right');
        pop();
      },
      child: const Text('Right'),
    ),
  ];

  Widget get content => Universal(
    margin: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(4)),
    height: 200,
    child: const Text('ActionDialog'),
  );
}

class _ActionSheet extends StatelessWidget {
  const _ActionSheet();

  @override
  Widget build(BuildContext context) {
    return const CupertinoActionSheet(
      title: Text('提示'),
      message: Text('是否要删除当前项？'),
      actions: [
        CupertinoActionSheetAction(onPressed: closePopup, isDefaultAction: true, child: Text('删除')),
        CupertinoActionSheetAction(onPressed: closePopup, isDestructiveAction: true, child: Text('暂时不删')),
      ],
    );
  }
}
