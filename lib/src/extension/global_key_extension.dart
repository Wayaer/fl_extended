import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension ExtensionGlobalKey on GlobalKey {
  /// 截屏
  /// format 图片格式
  /// pixelRatio 截图分辨率比例
  Future<ByteData?> screenshots({
    ui.ImageByteFormat format = ui.ImageByteFormat.rawRgba,
    double pixelRatio = 1.0,
  }) async {
    if (currentContext == null) return null;
    final boundary =
        currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);

    /// Uint8List uint8list = byteData.buffer.asUint8List();
    return await image.toByteData(format: format);
  }
}
