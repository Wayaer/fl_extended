import 'package:flutter/material.dart';

/// 外挂监听器回调
typedef FlListenableBinderListener<T> = void Function(T value);

/// 外挂监听器：将值变化回调挂到 [Listenable] 上
class FlListenableBinder<T> {
  /// 上一次值
  T? last;

  final List<FlListenableBinderListener<T>> _subscribers = [];

  VoidCallback? _listener;

  FlListenableBinderListener<VoidCallback>? _onRemoveListener;

  WeakReference<Object>? _weakKey;

  /// 添加监听。当 [key] 被回收时会自动清理系统监听与订阅列表。
  /// 回调本身仍为强引用，业务侧应在 dispose 时调用 [removeListener]。
  ///
  /// 同一个 binder 只能绑定一个 [key]；传入不同的 key 会抛出 [ArgumentError]。
  /// 需要监听多个对象时，请为每个对象分别创建 binder。
  bool addWeakListener<K extends Object>({
    required K key,
    required FlListenableBinderListener<T> listener,
    required T Function(K) getValue,
    required FlListenableBinderListener<VoidCallback> onAddListener,
    required FlListenableBinderListener<VoidCallback> onRemoveListener,
  }) {
    if (_subscribers.contains(listener)) return false;

    final Object? boundKey = _weakKey?.target;
    if (boundKey != null && !identical(boundKey, key)) {
      throw ArgumentError.value(
        key,
        'key',
        'This FlListenableBinder<$T> is already bound to another key; '
            'use the same key or remove the existing listeners first.',
      );
    }
    if (boundKey == null && _subscribers.isNotEmpty) _autoCleanup();

    last ??= getValue(key);
    _onRemoveListener = onRemoveListener;

    if (_subscribers.isEmpty) {
      _weakKey = WeakReference<Object>(key);
      _listener = () {
        final Object? k = _weakKey?.target;
        if (k == null) {
          _autoCleanup();
          return;
        }
        change(getValue(k as K));
      };
      onAddListener(_listener!);
    }
    _subscribers.add(listener);
    return true;
  }

  void _autoCleanup() {
    _subscribers.clear();
    final VoidCallback? listener = _listener;
    final remove = _onRemoveListener;
    _listener = null;
    _onRemoveListener = null;
    _weakKey = null;
    if (listener != null && remove != null) {
      remove(listener);
    }
  }

  /// 移除监听回调
  bool removeListener(
    FlListenableBinderListener<T> listener,
    FlListenableBinderListener<VoidCallback> onRemoveListener,
  ) {
    final removed = _subscribers.remove(listener);
    if (_subscribers.isEmpty && _listener != null) {
      onRemoveListener(_listener!);
      _listener = null;
      _onRemoveListener = null;
      _weakKey = null;
    }
    return removed;
  }

  /// 改变值并通知订阅者
  void change(T value) {
    if (value == last) return;
    last = value;
    for (final listener in List<FlListenableBinderListener<T>>.from(_subscribers)) {
      listener(value);
    }
  }

  /// 清除所有改变监听
  void clearAllChangedListeners(FlListenableBinderListener<VoidCallback> onRemoveListener) {
    _subscribers.clear();
    if (_listener != null) onRemoveListener(_listener!);
    _listener = null;
    _onRemoveListener = null;
    _weakKey = null;
  }
}

final Expando<Map<Type, dynamic>> _globalListenableExpandoStore = Expando('GlobalListenableBinder_Store');

/// [Listenable] 外挂监听器扩展
extension ExtensionExpandoListenable on Listenable {
  /// 获取或创建当前对象关联的外挂监听器
  FlListenableBinder<T> expandoBinder<T>() {
    final storage = _globalListenableExpandoStore[this] ??= {};
    return storage.putIfAbsent(T, () => FlListenableBinder<T>()) as FlListenableBinder<T>;
  }
}
