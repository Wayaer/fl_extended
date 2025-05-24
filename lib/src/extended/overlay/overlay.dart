import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

part 'loading.dart';

part 'toast.dart';

class FlOverlay {
  factory FlOverlay() => _singleton ??= FlOverlay._();

  FlOverlay._();

  static FlOverlay? _singleton;

  final List<FlOverlayEntry> _overlayEntries = <FlOverlayEntry>[];

  List<FlOverlayEntry> get overlayEntries => _overlayEntries;

  /// ********* [Overlay] ********* ///

  /// 自定义Overlay
  /// [isCached] 是否缓存
  /// [id] 唯一标识
  /// [widget] 要显示的Widget
  FlOverlayEntry? show(Widget widget, {bool isCached = true, Object? id}) {
    assert(
      FlExtended().navigatorKey.currentState != null,
      'Set FlExtended().navigatorKey to one of [MaterialApp CupertinoApp WidgetsApp]',
    );
    final overlay = FlExtended().navigatorKey.currentState!.overlay;
    if (overlay == null) return null;
    id ??= widget.runtimeType;
    final FlOverlayEntry entry = FlOverlayEntry(
      isCached: isCached,
      widget: widget,
      id: id,
    );
    overlay.insert(entry);
    if (isCached) _overlayEntries.add(entry);
    return entry;
  }

  /// 关闭最顶层的Overlay
  void hide({FlOverlayEntry? entry}) {
    if (entry != null) {
      entry.remove();
    } else if (_overlayEntries.isNotEmpty) {
      _overlayEntries.last.remove();
    }
  }

  /// 关闭所有Overlay
  void hideAll() {
    _overlayEntries.removeElement((element) {
      element.remove();
      return false;
    });
  }

  /// ********* [Toast] ********* ///
  /// Toast
  FlOverlayEntry? _toast;

  FlOverlayEntry? get toast => _toast;

  /// Toast 关闭 hideToast();
  Future<FlOverlayEntry?> showToast(Toast toast) async {
    if (_toast != null) return _toast;
    _toast = show(toast, isCached: false);
    _toast?.addListener(_toastListener);
    final duration =
        toast.duration ??
        toast.options?.duration ??
        FlExtended().toastOptions.duration;
    await duration.delayed();
    hideToast();
    return _toast;
  }

  void _toastListener() {
    if (_toast?.mounted == false) {
      _toast?.removeListener(_toastListener);
      _toast?.dispose();
      _toast = null;
    }
  }

  void hideToast() {
    _toast?.removeListener(_toastListener);
    _toast?.remove();
    _toast = null;
  }

  /// ********* [Loading] ********* ///
  FlOverlayEntry? _loading;

  FlOverlayEntry? get loading => _loading;

  /// loading 加载框 关闭 hideLoading();
  FlOverlayEntry? showLoading(Loading loading) {
    if (_loading != null) return _loading;
    _loading = FlOverlay().show(loading);
    _loading?.addListener(_loadingListener);
    return _loading;
  }

  void _loadingListener() {
    if (_loading?.mounted == false) {
      _loading?.removeListener(_loadingListener);
      _loading = null;
    }
  }

  void hideLoading() {
    _loading?.removeListener(_loadingListener);
    _loading?.remove();
    _loading = null;
  }
}

class FlOverlayEntry extends OverlayEntry {
  FlOverlayEntry({
    this.id = 'FlOverlayEntry',
    WidgetBuilder? builder,
    Widget? widget,
    this.isCached = true,
    super.opaque = false,
    super.maintainState = false,
    super.canSizeOverlay = false,
  }) : assert(builder != null || widget != null),
       super(builder: builder ?? (_) => widget!);

  /// 是否缓存至 [FlOverlay().overlayEntries]
  final bool isCached;

  /// id 标识
  final Object id;

  @override
  void remove() {
    try {
      super.remove();
      FlOverlay()._overlayEntries.remove(this);
    } catch (e) {
      debugPrint('FlOverlayEntry remove error: $e');
    }
  }
}

/// 关闭所有Overlay
void hideAllOverlay() => FlOverlay().hideAll();

/// 关闭最顶层的Overlay
void hideOverlay({FlOverlayEntry? entry}) => FlOverlay().hide(entry: entry);
