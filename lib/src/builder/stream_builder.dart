import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

/// 扩展 StreamBuilder
class ExtendedStreamBuilder<T> extends StreamBuilder {
  ExtendedStreamBuilder({
    super.key,
    super.initialData,
    super.stream,

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

/// 自定义版 StreamBuilder
class CustomStreamBuilder<T> extends ExtendedStatefulWidget {
  const CustomStreamBuilder({
    super.key,
    this.initial,
    required this.stream,
    required this.onDone,
    this.onNone,
    this.onWaiting,
    this.onError,
    this.didUpdateWidgetCallStream = false,
    this.initialCallStream = false,
    super.initState,
    super.didChangeDependencies,
    super.didUpdateWidget,
    super.deactivate,
    super.dispose,
  });

  /// 初始化数据
  final T? initial;

  /// 异步方法
  final Stream<T> stream;

  /// 没有数据时 为 null UI回调
  final ValueCallbackTV<Widget, BuildContext>? onNone;

  /// 等待异步执行 UI回调
  final ValueCallbackTV<Widget, BuildContext>? onWaiting;

  /// 异步错误时或者返回值为null时 UI回调
  final ValueTwoCallbackT<Widget, BuildContext, Object?>? onError;

  /// 完成时 UI回调 异步返回的数据一定不为null
  final ValueTwoCallbackT<Widget, BuildContext, T> onDone;

  /// 父组件update时 是否重新执行异步请求 默认为false
  final bool didUpdateWidgetCallStream;

  /// 当 [initial] !=null 时第一次渲染是否执行异步请求  默认为false
  final bool initialCallStream;

  @override
  State<CustomStreamBuilder<T>> createState() => _CustomStreamBuilderState<T>();
}

class _CustomStreamBuilderState<T>
    extends ExtendedStatefulWidgetState<CustomStreamBuilder<T>> {
  BuilderState state = BuilderState.none;
  StreamSubscription<T>? _subscription;
  T? data;
  Object? _error;

  @override
  void initState() {
    if (widget.initial != null) {
      state = BuilderState.done;
      data = widget.initial as T;
    }
    if (widget.initial == null || widget.initialCallStream) {
      addPostFrameCallback((duration) => _subscribe());
    }
    super.initState();
  }

  void _subscribe() {
    state = BuilderState.waiting;
    if (mounted && widget.onWaiting != null) setState(() {});
    _subscription = widget.stream.listen((T value) {
      if (value != null) {
        state = BuilderState.done;
        data = value;
      }
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
          return widget.onNone!.call(context);
        }
        break;
      case BuilderState.waiting:
        if (widget.onWaiting != null) {
          return widget.onWaiting!.call(context);
        }
        break;
      case BuilderState.error:
        if (widget.onError != null) {
          return widget.onError!.call(context, _error);
        }
        break;
      case BuilderState.done:
        return widget.onDone.call(context, data as T);
    }
    return const SizedBox();
  }

  @override
  void didUpdateWidget(covariant CustomStreamBuilder<T> oldWidget) {
    if (widget.didUpdateWidgetCallStream) {
      _unsubscribe();
      _subscribe();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
