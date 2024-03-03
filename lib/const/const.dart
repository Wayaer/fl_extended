import 'package:flutter/material.dart';

const String refreshEvent = 'refreshEvent';

/// icons
class FlExtendedIcons {
  FlExtendedIcons._();

  /// 成功
  static const IconData success = _IconData(0xe660);

  /// 错误
  static const IconData fail = _IconData(0xe65d);

  /// 提示
  static const IconData info = _IconData(0xe65a);

  /// 警告
  static const IconData warning = _IconData(0xe65c);

  /// 笑脸
  static const IconData smile = _IconData(0xe65e);
}

class _IconData extends IconData {
  const _IconData(super.codePoint)
      : super(fontFamily: 'FlExtendedIcons', fontPackage: 'fl_extended');
}
