import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension ExtensionGlobalKey on GlobalKey {
  /// 截取当前 key 对应组件的画面
  /// [format]：图片格式
  /// [pixelRatio]：截图分辨率比例
  Future<ByteData?> screenshots({
    ui.ImageByteFormat format = ui.ImageByteFormat.rawRgba,
    double pixelRatio = 1.0,
  }) async {
    final RenderObject? renderObject = currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;
    final ui.Image image = await renderObject.toImage(pixelRatio: pixelRatio);
    try {
      /// 可通过 `byteData.buffer.asUint8List()` 转为 [Uint8List]
      return await image.toByteData(format: format);
    } finally {
      image.dispose();
    }
  }
}
