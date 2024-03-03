import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          appBar: AppBarText('Popup'),
          isScroll: true,
          children: [
            const Partition('Dialog'),
            ElevatedText('popup Dialog', onTap: () {
              const Center(child: _AlertDemo()).popupDialog<dynamic>();
            }),
            ElevatedText('popup MaterialDialog', onTap: () {
              const Center(child: _AlertDemo()).popupMaterialDialog<dynamic>();
            }),
            ElevatedText('popup CupertinoDialog', onTap: () {
              const Center(child: _AlertDemo()).popupCupertinoDialog<dynamic>();
            }),
            const Partition('Bottom Sheet'),
            ElevatedText('popup BottomSheet', onTap: () {
              const _AlertDemo().popupBottomSheet<dynamic>(
                  options: const BottomSheetOptions(
                      backgroundColor: Colors.transparent));
            }),
            ElevatedText('popup BottomSheet - Full screen', onTap: () {
              Container(
                      color: Colors.blueGrey.withOpacity(0.4),
                      alignment: Alignment.center,
                      child: const _AlertDemo())
                  .popupBottomSheet<dynamic>(
                      options: const BottomSheetOptions(
                          backgroundColor: Colors.transparent));
            }),
            ElevatedText('popup CupertinoModal', onTap: () {
              const _AlertDemo().popupCupertinoModal<dynamic>();
            }),
            const Partition('DoubleChooseWindows Popup'),
            ElevatedText('popup DoubleChooseWindows',
                onTap: () => doubleChooseWindows(context)),
          ]);

  void doubleChooseWindows(BuildContext context) {
    DoubleChooseWindows(
            options: const ModalWindowsOptions(),
            decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            right: Universal(
                padding: const EdgeInsets.symmetric(vertical: 6),
                alignment: Alignment.center,
                child: Text('确定', style: context.textTheme.titleMedium),
                onTap: () {
                  ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
                  showToast('确定');
                }),
            left: Universal(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text('取消', style: context.textTheme.titleMedium),
                onTap: () {
                  ///如果isOverlay=true; 必须先closeOverlay() 再toast或者loading
                  showToast('取消');
                  pop();
                }),
            content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('内容', style: context.textTheme.bodyLarge)))
        .show();
  }
}

class _AlertDemo extends StatelessWidget {
  const _AlertDemo();

  @override
  Widget build(BuildContext context) {
    return const CupertinoActionSheet(
        title: Text('提示'),
        message: Text('是否要删除当前项？'),
        actions: [
          CupertinoActionSheetAction(
              onPressed: closePopup, isDefaultAction: true, child: Text('删除')),
          CupertinoActionSheetAction(
              onPressed: closePopup,
              isDestructiveAction: true,
              child: Text('暂时不删')),
        ]);
  }
}
