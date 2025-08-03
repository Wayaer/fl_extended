import 'package:flutter/material.dart';

/// 全局FocusManager实例
FocusManager focusManager = FocusManager.instance;

FocusNode? primaryFocus = focusManager.primaryFocus;

void primaryFocusUnfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
  primaryFocus?.unfocus(disposition: disposition);
}

void primaryFocusRequestFocus({FocusNode? node}) {
  primaryFocus?.requestFocus(node);
}

bool? get primaryFocusCanRequestFocus => primaryFocus?.canRequestFocus;

bool? get primaryFocusHasFocus => primaryFocus?.hasFocus;
