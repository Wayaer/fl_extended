import 'dart:async';

/// Future 回调节流：首次调用立即执行，Future 完成前忽略后续调用。
///
/// 每个包装闭包持有独立状态，不再使用全局 `hashCode` 表。
extension ExtensionFutureFunction on Future Function() {
  Function() throttle() {
    bool running = false;
    return () {
      if (running) return;
      running = true;
      try {
        this.call().whenComplete(() => running = false).ignore();
      } catch (_) {
        running = false;
        rethrow;
      }
    };
  }
}

/// 通用 [Function] 防抖 / 节流
extension ExtensionFunction on Function {
  /// 防抖：延迟执行，延迟期内再次触发则重置计时
  ///
  /// 返回的闭包无法取消内部 Timer；页面销毁等场景请使用 [FlDebouncer]。
  Function() debounce([Duration delay = const Duration(seconds: 1)]) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => this.call());
    };
  }

  /// 节流：立即执行，延迟期内再次触发会被忽略
  ///
  /// 返回的闭包无法取消内部 Timer；页面销毁等场景请使用 [FlThrottler]。
  Function() throttle([Duration delay = const Duration(seconds: 1)]) {
    bool running = false;
    return () {
      if (running) return;
      running = true;
      try {
        this.call();
      } finally {
        Future<void>.delayed(delay, () => running = false);
      }
    };
  }
}

/// 可取消的防抖器
///
/// 示例：
/// ```dart
/// final debouncer = FlDebouncer(() => search());
/// onChanged: (_) => debouncer();
/// dispose: () => debouncer.dispose();
/// ```
class FlDebouncer {
  FlDebouncer(this.callback, {this.delay = const Duration(seconds: 1)});

  final void Function() callback;
  final Duration delay;
  Timer? _timer;

  bool get isActive => _timer?.isActive ?? false;

  void call() {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// 取消尚未触发的调用
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => cancel();
}

/// 可取消的节流器
class FlThrottler {
  FlThrottler(this.callback, {this.delay = const Duration(seconds: 1)});

  final void Function() callback;
  final Duration delay;
  bool _running = false;
  Timer? _resetTimer;

  bool get isRunning => _running;

  void call() {
    if (_running) return;
    _running = true;
    try {
      callback();
    } finally {
      _resetTimer?.cancel();
      _resetTimer = Timer(delay, () => _running = false);
    }
  }

  /// 取消计时并重置状态
  void cancel() {
    _resetTimer?.cancel();
    _resetTimer = null;
    _running = false;
  }

  void dispose() => cancel();
}
