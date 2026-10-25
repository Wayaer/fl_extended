import 'package:flutter/material.dart';

extension ExtensionTextEditingController on TextEditingController {
  /// 当前有效选区；未设置选区时折叠到文本末尾
  TextSelection get _safeSelection => selection.isValid ? selection : TextSelection.collapsed(offset: text.length);

  /// 在光标后插入文本
  void addTextAfterCursor(String text) {
    final String value = this.text;
    final TextSelection selection = _safeSelection;
    final int start = selection.start.clamp(0, value.length).toInt();
    final int end = selection.end.clamp(start, value.length).toInt();
    final String newValue = value.substring(0, start) + text + value.substring(end);
    this.value = this.value.copyWith(
      text: newValue,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }

  /// 在光标前插入文本
  void addTextBeforeCursor(String text) {
    final String value = this.text;
    final TextSelection selection = _safeSelection;
    final int start = selection.start.clamp(0, value.length).toInt();
    final String newValue = value.substring(0, start) + text + value.substring(start);
    this.value = this.value.copyWith(
      text: newValue,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }
}
