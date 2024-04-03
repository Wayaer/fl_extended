import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

/// 扩展 FutureBuilder
class ExtendedFutureBuilder<T> extends FutureBuilder {
  ExtendedFutureBuilder({
    super.key,
    super.initialData,
    super.future,

    /// [ConnectionState.none] 显示的内容
    ValueTwoCallbackT<Widget, BuildContext, T>? onNone,

    /// [ConnectionState.waiting] 显示的内容
    ValueTwoCallbackT<Widget, BuildContext, T>? onWaiting,

    /// [ConnectionState.active] 显示的内容
    ValueTwoCallbackT<Widget, BuildContext, T>? onActive,

    /// [ConnectionState.done] 显示的内容
    ValueTwoCallbackT<Widget, BuildContext, T>? onDone,

    /// [error] 显示的内容
    ValueTwoCallbackT<Widget, BuildContext, Object?>? onError,
  }) : super(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return onError?.call(context, snapshot.error) ?? const SizedBox();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return onNone?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.waiting:
              return onWaiting?.call(context, snapshot.data) ??
                  const SizedBox();
            case ConnectionState.active:
              return onActive?.call(context, snapshot.data) ?? const SizedBox();
            case ConnectionState.done:
              return onDone?.call(context, snapshot.data) ?? const SizedBox();
          }
        });
}

enum BuilderState {
  /// 异步返回数据 为 null
  none,

  /// 等待中
  waiting,

  /// 异步有数据
  done,

  /// 异步错误
  error,
}

/// 自定义版 FutureBuilder
class CustomFutureBuilder<T> extends ExtendedStatefulWidget {
  const CustomFutureBuilder({
    super.key,
    this.initial,
    required this.future,
    required this.onDone,
    this.onNone,
    this.onWaiting,
    this.onError,
    this.didUpdateWidgetCallFuture = false,
    this.initialCallFuture = false,
    super.initState,
    super.didUpdateWidget,
    super.didChangeDependencies,
    super.deactivate,
    super.dispose,
  });

  /// 初始化数据
  final T? initial;

  /// 异步方法
  final Future<T> Function() future;

  /// 没有数据时 为 null UI回调
  final ValueTwoCallbackT<Widget, BuildContext, Function()>? onNone;

  /// 等待异步执行 UI回调
  final ValueCallbackTV<Widget, BuildContext>? onWaiting;

  /// 异步错误时或者返回值为null时 UI回调
  final ValueThreeCallbackT<Widget, BuildContext, Object?, Function()>? onError;

  /// 完成时 UI回调 异步返回的数据一定不为null
  final ValueThreeCallbackT<Widget, BuildContext, T, Function()> onDone;

  /// 父组件update时 是否重新执行异步请求 默认为false
  final bool didUpdateWidgetCallFuture;

  /// 当 [initial] !=null 时第一次渲染是否执行异步请求  默认为false
  final bool initialCallFuture;

  @override
  State<CustomFutureBuilder<T>> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T>
    extends ExtendedStatefulWidgetState<CustomFutureBuilder<T>> {
  BuilderState state = BuilderState.none;
  T? data;
  Object? _error;

  @override
  void initState() {
    if (widget.initial != null) {
      state = BuilderState.done;
      data = widget.initial as T;
    }
    if (widget.initial == null || widget.initialCallFuture) {
      addPostFrameCallback((duration) => _subscribe());
    }
    super.initState();
  }

  void _subscribe() {
    state = BuilderState.waiting;
    if (mounted && widget.onWaiting != null) setState(() {});
    widget.future.call().then((value) {
      state = BuilderState.done;
      data = value;
      setState(() {});
    }, onError: (Object error, StackTrace stackTrace) {
      state = BuilderState.error;
      _error = error;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BuilderState.none:
        if (widget.onNone != null) {
          return widget.onNone!.call(context, _subscribe);
        }
        break;
      case BuilderState.waiting:
        if (widget.onWaiting != null) {
          return widget.onWaiting!.call(context);
        }
        break;
      case BuilderState.error:
        if (widget.onError != null) {
          return widget.onError!.call(context, _error, _subscribe);
        }
        break;
      case BuilderState.done:
        return widget.onDone.call(context, data as T, _subscribe);
    }
    return const SizedBox();
  }

  @override
  void didUpdateWidget(covariant CustomFutureBuilder<T> oldWidget) {
    if (widget.didUpdateWidgetCallFuture) _subscribe();
    super.didUpdateWidget(oldWidget);
  }
}
