import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

EdgeInsets insets = const EdgeInsets.all(20);

class FlOverlayPage extends StatelessWidget {
  const FlOverlayPage({super.key});

  @override
  Widget build(BuildContext context) => FlScaffold(
    appBar: AppBaFlRichText('FlOverlay'),
    isScroll: true,
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    canPop: false,
    canHideOverlay: true,
    onPopInvokedWithResult: (bool didPop, dynamic result, bool didCloseOverlay) {
      log('FlOverlayPage onPopInvokedWithResult didPop=$didPop result=$result didCloseOverlay=$didCloseOverlay');
      if (didCloseOverlay || didPop) return;
      pop();
    },
    children: [
      const Partition('FlPopScope'),
      Text(
        'If there is an FlOverlayEntry on the current page, it will be closed first, and clicking back again will close the page',
      ),
      12.heightBox,
      const Partition('SnackBar'),
      ElevatedText(
        'showSnackBar',
        onTap: () {
          showSnackBar(const SnackBar(content: FlText('show SnackBar')));
        },
      ),
      const Partition('Toast'),
      Wrap(
        alignment: WrapAlignment.center,
        children: ToastIconStyle.values.builder(
          (ToastIconStyle style) => ElevatedText(
            style.toString(),
            onTap: () async {
              await showToast(
                style.toString(),
                iconStyle: style,
                options: const ToastOptions(elevation: 6, shadowColor: Colors.red),
              );
              showToast(
                '添加await第一个Toast完了之后弹出第二个Toast',
                options: const ToastOptions(elevation: 6, shadowColor: Colors.red),
              );
            },
          ),
        ),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        children: [Alignment.topCenter, Alignment.bottomCenter, Alignment.center].builder(
          (alignment) => ElevatedText(
            alignment.toString().split('.')[1],
            onTap: () async {
              showToast(alignment.toString(), options: ToastOptions(alignment: alignment));
            },
          ),
        ),
      ),
      const Partition('Loading'),
      const ElevatedText('showLoading', onTap: showLoading),
      ElevatedText(
        'showLoading custom',
        onTap: () {
          showLoading(
            options: LoadingOptions(
              gaussian: 4,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onModalTap: hideLoading,
              builder: (_, ProgressIndicatorOptions? progressIndicator) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlProgressIndicator(ProgressIndicatorStyle.circular.options),
                  10.heightBox,
                  const Text('Loading...'),
                ],
              ),
              borderRadius: BorderRadius.circular(6),
              alignment: Alignment.center,
              textStyle: TextStyle(color: context.theme.primaryColor, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      ...ProgressIndicatorStyle.values.builder(
        (style) => ElevatedText(
          'showLoading ($style)',
          onTap: () {
            showLoading(
              options: LoadingOptions(
                gaussian: 4,
                onLoadingTap: () {
                  '点击了Loading'.log();
                },
                progressIndicator: style.options,
                onModalTap: hideOverlay,
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 60),
    ],
  );
}
