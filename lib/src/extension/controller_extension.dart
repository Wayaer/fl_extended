import 'package:fl_extended/src/extended/expando_listenable.dart';
import 'package:flutter/material.dart';

/// [TabController] 索引改变监听
extension TabControllerIndexChangedExtension on TabController {
  FlListenableBinder<int> get _expandoBinder => expandoBinder<int>();

  bool addIndexChangedListener(FlListenableBinderListener<int> listener) => _expandoBinder.addWeakListener(
      key: this,
      listener: listener,
      getValue: (c) => c.indexIsChanging ? (_expandoBinder.last ?? c.index) : c.index,
      onAddListener: addListener);

  bool removeIndexChangedListener(FlListenableBinderListener<int> listener) =>
      _expandoBinder.removeListener(listener, removeListener);

  void animateToIndex(int index, {Duration duration = const Duration(milliseconds: 200)}) {
    animateTo(index, duration: duration);
  }

  void jumpToIndex(int index) {
    animateTo(index, duration: Duration.zero);
  }

  /// 清除所有索引改变监听
  void clearAllIndexChangedListeners() {
    _expandoBinder.clearAllChangedListeners(removeListener);
  }
}

/// 焦点节点扩展监听
extension FocusNodeExtensionListener on FocusNode {
  FlListenableBinder<bool> get _expandoBinder => expandoBinder<bool>();

  /// 添加监听回调
  bool addFocusChangedListener(FlListenableBinderListener<bool> listener) => _expandoBinder.addWeakListener(
      key: this, listener: listener, getValue: (f) => f.hasFocus, onAddListener: addListener);

  /// 移除监听回调
  bool removeFocusListener(FlListenableBinderListener<bool> listener) =>
      _expandoBinder.removeListener(listener, removeListener);

  /// 清除所有焦点监听
  void clearAllFocusListeners() {
    _expandoBinder.clearAllChangedListeners(removeListener);
  }
}

/// 控制器文本改变监听
extension TextEditingControllerExtensionListener on TextEditingController {
  FlListenableBinder<String> get _expandoBinder => expandoBinder<String>();

  /// 添加监听回调
  bool addTextChangedListener(FlListenableBinderListener<String> listener) => _expandoBinder.addWeakListener(
      key: this, listener: listener, getValue: (c) => c.text, onAddListener: addListener);

  /// 移除监听回调
  bool removeTextChangedListener(FlListenableBinderListener<String> listener) =>
      _expandoBinder.removeListener(listener, removeListener);

  /// 清除所有文本改变监听
  void clearAllTextChangedListeners() {
    _expandoBinder.clearAllChangedListeners(removeListener);
  }
}
