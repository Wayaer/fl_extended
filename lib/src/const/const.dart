import 'package:flutter/material.dart';

/// icons
class FlIcons {
  FlIcons._();

  static const String fontFamily = 'FlIcons';
  static const String fontPackage = 'fl_extended';

  /// 成功
  static const IconData success = IconData(0xe660, fontFamily: fontFamily, fontPackage: fontPackage);

  /// 错误
  static const IconData fail = IconData(0xe65d, fontFamily: fontFamily, fontPackage: fontPackage);

  /// 提示
  static const IconData info = IconData(0xe65a, fontFamily: fontFamily, fontPackage: fontPackage);

  /// 警告
  static const IconData warning = IconData(0xe65c, fontFamily: fontFamily, fontPackage: fontPackage);

  /// 笑脸
  static const IconData smile = IconData(0xe65e, fontFamily: fontFamily, fontPackage: fontPackage);
}
