import 'package:flutter/material.dart';

/// 全局 [FocusManager] 实例
FocusManager focusManager = FocusManager.instance;

/// 当前主焦点
FocusNode? get primaryFocus => focusManager.primaryFocus;

/// 取消主焦点
void primaryFocusUnfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
  primaryFocus?.unfocus(disposition: disposition);
}

/// 请求焦点：传入 [node] 时直接聚焦该节点，否则聚焦当前主焦点
void primaryFocusRequestFocus({FocusNode? node}) {
  if (node != null) {
    node.requestFocus();
  } else {
    primaryFocus?.requestFocus();
  }
}

/// 主焦点是否可请求焦点
bool? get primaryFocusCanRequestFocus => primaryFocus?.canRequestFocus;

/// 主焦点是否拥有焦点
bool? get primaryFocusHasFocus => primaryFocus?.hasFocus;
