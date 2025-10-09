import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// 全局WidgetsBinding实例
WidgetsBinding widgetsBinding = WidgetsBinding.instance;

/// 调度相关绑定
SchedulerBinding schedulerBinding = SchedulerBinding.instance;

/// 手势处理相关绑定
GestureBinding gestureBinding = GestureBinding.instance;

/// 绘制相关绑定
PaintingBinding paintingBinding = PaintingBinding.instance;

/// 语义化（无障碍）相关绑定
SemanticsBinding semanticsBinding = SemanticsBinding.instance;

/// 渲染相关绑定
RendererBinding rendererBinding = RendererBinding.instance;

/// 平台服务交互绑定
ServicesBinding servicesBinding = ServicesBinding.instance;

void addPostFrameCallback(FrameCallback duration, {String debugLabel = 'callback'}) {
  widgetsBinding.addPostFrameCallback(duration, debugLabel: debugLabel);
}

void addObserver(WidgetsBindingObserver observer) {
  widgetsBinding.addObserver(observer);
}

void removeObserver(WidgetsBindingObserver observer) {
  widgetsBinding.removeObserver(observer);
}

void addPersistentFrameCallback(FrameCallback duration) {
  widgetsBinding.addPersistentFrameCallback(duration);
}

void addTimingsCallback(TimingsCallback callback) {
  widgetsBinding.addTimingsCallback(callback);
}

void removeTimingsCallback(TimingsCallback callback) {
  widgetsBinding.removeTimingsCallback(callback);
}
