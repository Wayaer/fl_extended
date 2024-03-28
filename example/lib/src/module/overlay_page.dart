import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          appBar: AppBarText('Overlay'),
          isScroll: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            ElevatedText('showSnackBar', onTap: () {
              showSnackBar(const SnackBar(content: BText('show SnackBar')));
            }),
            const Partition('Toast'),
            Wrap(
                alignment: WrapAlignment.center,
                children: ToastIconStyle.values.builder(
                    (ToastIconStyle style) =>
                        ElevatedText(style.toString(), onTap: () async {
                          await showToast(style.toString(), iconStyle: style);
                          '添加await第一个Toast完了之后弹出第二个Toast'.showToast();
                        }))),
            Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Alignment.topCenter,
                  Alignment.topLeft,
                  Alignment.topRight,
                  Alignment.bottomCenter,
                  Alignment.bottomLeft,
                  Alignment.bottomRight,
                  Alignment.center,
                  Alignment.centerLeft,
                  Alignment.centerRight,
                ].builder((positioned) => ElevatedText(
                        positioned.toString().split('.')[1], onTap: () async {
                      showToast(positioned.toString(),
                          animationStyle: FlAnimationStyle.fade,
                          );
                    }))),
            const Partition('Loading'),
            ElevatedText('showLoading', onTap: () {
              showLoading();
            }),
            ...LoadingStyle.values.builder(
                (style) => ElevatedText('showLoading ($style)', onTap: () {
                      showLoading(
                          style: style,
                          options: LoadingOptions(
                              onLoadingTap: () {
                                '点击了Loading'.log();
                              },
                              gaussian: true,
                              onModalTap: closeOverlay));
                    })),
            const SizedBox(height: 60),
          ]);
}
