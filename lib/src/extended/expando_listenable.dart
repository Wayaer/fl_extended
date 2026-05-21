import 'package:flutter/material.dart';

typedef FlListenableBinderListener<T> = void Function(T value);

/// 外挂监听器类
class FlListenableBinder<T> {
  /// 上一次值
  T? last;

  /// 监听回调列表
  final List<FlListenableBinderListener<T>> _subscribers = [];

  /// 监听回调
  VoidCallback? _listener;

  /// 添加监听回调
  bool addWeakListener<K extends Object>({
    required K key,
    required FlListenableBinderListener<T> listener,
    required T Function(K) getValue,
    required FlListenableBinderListener<VoidCallback> onAddListener,
  }) {
    if (_subscribers.contains(listener)) return false;

    /// 添加首次赋值
    last ??= getValue(key);

    /// 第一次添加时，注册系统监听
    if (_subscribers.isEmpty) {
      final weakKey = WeakReference(key);
      _listener = () {
        final k = weakKey.target;
        if (k == null) return;
        change(getValue(k));
      };
      onAddListener(_listener!);
    }
    _subscribers.add(listener);
    return true;
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
    }
    return removed;
  }

  /// 改变值
  void change(T value) {
    if (value == last) return;
    last = value;
    for (var listener in List.from(_subscribers)) {
      listener(value);
    }
  }

  /// 清除所有改变监听
  void clearAllChangedListeners(FlListenableBinderListener<VoidCallback> onRemoveListener) {
    _subscribers.clear();
    if (_listener != null) onRemoveListener(_listener!);
    _listener = null;
  }
}

final Expando<Map<Type, dynamic>> _globalListenableExpandoStore = Expando('GlobalListenableBinder_Store');

extension ExtensionExpandoListenable on Listenable {
  /// 获取或创建当前对象关联的外挂监听器
  FlListenableBinder<T> expandoBinder<T>() {
    final storage = _globalListenableExpandoStore[this] ??= {};
    return storage.putIfAbsent(T, () => FlListenableBinder<T>()) as FlListenableBinder<T>;
  }
}
