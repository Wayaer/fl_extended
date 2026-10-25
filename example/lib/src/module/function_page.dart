import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class FunctionPage extends StatefulWidget {
  const FunctionPage({super.key});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends ExtendedState<FunctionPage> {
  int _debounceCount = 0;
  int _throttleCount = 0;
  int _futureCount = 0;
  int _futureDone = 0;
  int _classDebounceCount = 0;
  int _classThrottleCount = 0;

  late final Function _debounced = _onDebounce.debounce(const Duration(milliseconds: 600));
  late final Function _throttled = _onThrottle.throttle(const Duration(milliseconds: 800));
  late final Function _futureThrottled = _onFuture.throttle();
  late final FlDebouncer _debouncer = FlDebouncer(
    () => setState(() => _classDebounceCount++),
    delay: const Duration(milliseconds: 600),
  );
  late final FlThrottler _throttler = FlThrottler(
    () => setState(() => _classThrottleCount++),
    delay: const Duration(milliseconds: 800),
  );

  void _onDebounce() => setState(() => _debounceCount++);
  void _onThrottle() => setState(() => _throttleCount++);

  Future<void> _onFuture() async {
    setState(() => _futureCount++);
    await const Duration(milliseconds: 700).delayed();
    setState(() => _futureDone++);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Function',
      description:
          '防抖 / 节流既可以直接包装函数，也可以使用带 dispose 的 FlDebouncer / FlThrottler。'
          '页面销毁时请取消计时，避免回调在已销毁的 State 上执行。',
      sections: [
        DemoSection(
          title: '函数扩展',
          description: 'debounce 延迟执行并重置计时；throttle 立即执行，冷却期内忽略。',
          children: [
            DemoItem(
              title: 'debounce / throttle',
              code: r"""
final debounced = onTap.debounce(const Duration(milliseconds: 600));
final throttled = onTap.throttle(const Duration(milliseconds: 800));

// 触发
debounced();
throttled();
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FlButton(onPressed: () => _debounced(), child: const Text('debounce 触发')),
                      FlButton(onPressed: () => _throttled(), child: const Text('throttle 触发')),
                    ],
                  ),
                  10.heightBox,
                  Text('debounce 执行次数：$_debounceCount（600ms 内只执行最后一次）'),
                  4.heightBox,
                  Text('throttle 执行次数：$_throttleCount（800ms 内只执行一次）'),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'Future 节流',
          description: 'Future 完成前忽略重复调用，适合提交按钮防重复点击。',
          children: [
            DemoItem(
              title: 'Future Function().throttle()',
              code: r"""
final submit = onSubmit.throttle();

submit(); // 第一次执行
submit(); // Future 完成前忽略
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlButton(onPressed: () => _futureThrottled(), child: const Text('提交（Future 节流）')),
                  8.heightBox,
                  Text('开始次数：$_futureCount    完成次数：$_futureDone'),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'FlDebouncer / FlThrottler',
          description: '推荐在页面中使用：可手动 cancel，并在 dispose 中释放。',
          children: [
            DemoItem(
              title: '可取消版本',
              code: r"""
late final debouncer = FlDebouncer(() => search(), delay: Duration(milliseconds: 600));
late final throttler = FlThrottler(() => submit(), delay: Duration(milliseconds: 800));

debouncer();
throttler();

dispose() {
  debouncer.dispose();
  throttler.dispose();
  super.dispose();
}
""",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FlButton(onPressed: () => _debouncer(), child: const Text('FlDebouncer')),
                      FlButton(onPressed: () => _throttler(), child: const Text('FlThrottler')),
                      FlButton(
                        category: FlButtonCategory.outlined,
                        onPressed: () {
                          _debouncer.cancel();
                          _throttler.cancel();
                        },
                        child: const Text('全部取消'),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Text('FlDebouncer：$_classDebounceCount    FlThrottler：$_classThrottleCount'),
                ],
              ),
            ),
          ],
        ),
        DemoSection(
          title: '对比',
          children: [
            const DemoItem(
              child: DemoValues([
                DemoValue('debounce', '连续触发只在停止后执行最后一次'),
                DemoValue('throttle', '连续触发会按间隔执行，首次立即执行'),
                DemoValue('Future throttle', '异步完成前忽略重复调用'),
                DemoValue('FlDebouncer / FlThrottler', '可 cancel / dispose，适合页面生命周期'),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
