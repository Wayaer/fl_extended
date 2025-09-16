import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class BuilderPage extends StatelessWidget {
  const BuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool? showError = true;
    return FlScaffold(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      appBar: AppBaFlRichText('Builder'),
      children: [
        const Partition('CustomFutureBuilder', marginTop: 0),
        CustomFutureBuilder<String>(
          initial: '初始的数据 点击刷新',
          future: () => future(showError),
          onDone: (_, data, reset) {
            return ElevatedText(data, onTap: reset);
          },
          onError: (_, error, reset) {
            return ElevatedText(error.toString(), onTap: reset);
          },
          onNone: (_, reset) {
            return ElevatedText('没有数据点击刷新', onTap: reset);
          },
          onWaiting: (_) {
            return const CircularProgressIndicator();
          },
        ),
        const Partition('FlFutureBuilder'),
        FlFutureBuilder<String>(
          initialData: '初始的数据 点击刷新',
          future: future.call(false),
          onDone: (_, data) {
            return ElevatedText(data);
          },
          onError: (_, error) {
            return ElevatedText(error.toString());
          },
          onNone: (_, data) {
            return const ElevatedText('没有数据点击刷新');
          },
          onWaiting: (_, data) {
            return const CircularProgressIndicator();
          },
        ),
        const Partition('CustomStreamBuilder'),
        CustomStreamBuilder<String>(
          stream: Stream.fromFuture(future(false)),
          onDone: (_, String data) {
            return ElevatedText(data);
          },
          onError: (_, error) {
            return ElevatedText(error.toString());
          },
          onNone: (_) {
            return const ElevatedText('没有数据点击刷新');
          },
          onWaiting: (_) {
            return const CircularProgressIndicator();
          },
        ),
        const Partition('FlStreamBuilder'),
        FlStreamBuilder<String>(
          initialData: '初始的数据 点击刷新',
          stream: Stream.fromFuture(future(false)),
          onDone: (_, data) {
            return ElevatedText(data);
          },
          onError: (_, error) {
            return ElevatedText(error.toString());
          },
          onNone: (_, data) {
            return const ElevatedText('没有数据点击刷新');
          },
          onWaiting: (_, data) {
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  Future<String> future(bool? showError) async {
    await 2.seconds.delayed();
    if (showError == null) {
      showError = true;
      return 'null 点击刷新 错误';
    } else if (showError) {
      showError = false;
      return '错误 点击刷新正常';
    } else {
      showError = null;
      return '正常 点击刷新为 null';
    }
  }
}
