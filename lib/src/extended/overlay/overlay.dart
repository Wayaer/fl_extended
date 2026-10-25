import 'dart:async';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

part 'loading.dart';
part 'toast.dart';

/// Overlay / Toast / Loading 单例管理器
class FlOverlay extends ChangeNotifier {
  FlOverlay._();

  static final FlOverlay _instance = FlOverlay._();

  static FlOverlay get instance => _instance;

  factory FlOverlay() => _instance;

  final List<FlOverlayEntry> _overlayEntries = <FlOverlayEntry>[];

  /// 已缓存的 Overlay 条目
  List<FlOverlayEntry> get overlayEntries => _overlayEntries;

  /// 是否还有可见的 Toast / Loading / 缓存 Overlay
  bool get hasOverlay => (_toast?.mounted ?? false) || (_loading?.mounted ?? false) || _overlayEntries.isNotEmpty;

  void _emit() => notifyListeners();

  void _dropCached(FlOverlayEntry entry) {
    entry._unwatchMounted();
    _overlayEntries.remove(entry);
    _emit();
  }

  /// 显示自定义 Overlay
  /// [isCached] 是否缓存；显式传入 [id] 时，相同 [id] 的缓存项会被替换
  /// [id] 唯一标识，默认使用 Widget 运行时类型；未显式传入时允许同类组件叠加
  ///
  /// Overlay 内容位于页面 Material 之外；这里会自动补一层主题 DefaultTextStyle，
  /// 但背景、Ink 等 Material 效果仍建议自行使用 [Material] 包裹。
  FlOverlayEntry? show(Widget widget, {bool isCached = true, Object? id}) {
    final NavigatorState? navigator = FlExtended().navigatorKey.currentState;
    final OverlayState? overlay = navigator?.overlay;
    if (overlay == null) return null;
    if (isCached && id != null) {
      for (final FlOverlayEntry existing in List<FlOverlayEntry>.from(_overlayEntries)) {
        if (existing.id == id) existing.remove();
      }
    }
    final Object entryId = id ?? widget.runtimeType;
    final Widget themedWidget = Builder(
      builder: (BuildContext context) =>
          DefaultTextStyle(style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(), child: widget),
    );
    final FlOverlayEntry entry = FlOverlayEntry(isCached: isCached, widget: themedWidget, id: entryId);
    entry._order = ++_sequence;
    overlay.insert(entry);
    if (isCached) {
      _overlayEntries.add(entry);
      entry._watchMounted();
    }
    _emit();
    return entry;
  }

  int _sequence = 0;

  /// 关闭最顶层或指定 Overlay
  void hide({FlOverlayEntry? entry}) {
    if (entry != null) {
      entry.remove();
      return;
    }
    FlOverlayEntry? topmost;
    if (_hasLiveToast) topmost = _toast;
    if (_hasLiveLoading && (_loading!._order > (topmost?._order ?? -1))) topmost = _loading;
    for (final FlOverlayEntry cached in _overlayEntries) {
      if (cached._order > (topmost?._order ?? -1)) topmost = cached;
    }
    if (topmost == null) return;
    if (identical(topmost, _toast)) {
      hideToast();
    } else if (identical(topmost, _loading)) {
      hideLoading();
    } else {
      topmost.remove();
    }
  }

  /// 关闭所有 Overlay（含 Toast、Loading）
  void hideAll() {
    hideToast();
    hideLoading();
    final entries = List<FlOverlayEntry>.from(_overlayEntries);
    for (final entry in entries) {
      entry.remove();
    }
    _emit();
  }

  FlOverlayEntry? _toast;
  Completer<FlOverlayEntry?>? _toastCompleter;
  Timer? _toastTimer;

  /// 当前 Toast 条目
  FlOverlayEntry? get toast => _toast?.mounted == true ? _toast : null;

  bool get _hasLiveToast => _toast?.mounted == true;

  void _clearToastRef([FlOverlayEntry? entry]) {
    _toastTimer?.cancel();
    _toastTimer = null;
    final FlOverlayEntry? current = _toast;
    if (current?.mounted ?? false) current?.removeListener(_toastListener);
    _toast = null;
    final Completer<FlOverlayEntry?>? completer = _toastCompleter;
    _toastCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(entry ?? current);
    }
  }

  /// 显示 Toast；返回的 Future 在 Toast 关闭时完成（手动关闭也会立即完成）
  Future<FlOverlayEntry?> showToast(Toast toast) {
    if (_hasLiveToast) {
      return _toastCompleter?.future ?? Future<FlOverlayEntry?>.value(_toast);
    }
    if (_toast != null) _clearToastRef();

    final FlOverlayEntry? entry = show(toast, isCached: false);
    if (entry == null) return Future<FlOverlayEntry?>.value();

    final Completer<FlOverlayEntry?> completer = Completer<FlOverlayEntry?>();
    _toast = entry;
    _toastCompleter = completer;
    entry.addListener(_toastListener);
    _emit();

    final Duration requested = toast.duration ?? toast.options?.duration ?? FlExtended().toastOptions.duration;
    _toastTimer = Timer(requested, () {
      _toastTimer = null;
      if (identical(_toast, entry)) hideToast();
    });
    return completer.future;
  }

  void _toastListener() {
    final FlOverlayEntry? entry = _toast;
    if (entry != null && !entry.mounted) {
      _clearToastRef(entry);
      _emit();
    }
  }

  /// 关闭 Toast
  void hideToast() {
    final entry = _toast;
    _clearToastRef(entry);
    entry?.remove();
    _emit();
  }

  FlOverlayEntry? _loading;

  /// 当前 Loading 条目
  FlOverlayEntry? get loading => _loading?.mounted == true ? _loading : null;

  bool get _hasLiveLoading => _loading?.mounted == true;

  void _clearLoadingRef() {
    if (_loading?.mounted ?? false) _loading?.removeListener(_loadingListener);
    _loading = null;
  }

  /// 显示 Loading；关闭请调用 [hideLoading]
  FlOverlayEntry? showLoading(Loading loading) {
    if (_hasLiveLoading) return _loading;
    if (_loading != null) _clearLoadingRef();

    final FlOverlayEntry? entry = show(loading);
    _loading = entry;
    entry?.addListener(_loadingListener);
    _emit();
    return entry;
  }

  void _loadingListener() {
    if (_loading?.mounted == false) {
      _clearLoadingRef();
      _emit();
    }
  }

  /// 关闭 Loading
  void hideLoading() {
    final entry = _loading;
    _clearLoadingRef();
    entry?.remove();
    _emit();
  }
}

/// 可缓存的 [OverlayEntry]
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

  /// 唯一标识
  final Object id;

  /// 插入顺序，用于判断最顶层
  int _order = 0;

  bool _removed = false;
  bool _hasMounted = false;
  VoidCallback? _mountedListener;

  void _watchMounted() {
    _mountedListener = () {
      if (mounted) {
        _hasMounted = true;
      } else if (_hasMounted) {
        FlOverlay()._dropCached(this);
      }
    };
    addListener(_mountedListener!);
  }

  void _unwatchMounted() {
    final VoidCallback? listener = _mountedListener;
    if (listener == null) return;
    _mountedListener = null;
    removeListener(listener);
  }

  @override
  void remove() {
    if (_removed) return;
    _removed = true;
    try {
      super.remove();
    } catch (e) {
      debugPrint('FlOverlayEntry remove error: $e');
    }
    FlOverlay()._dropCached(this);
  }
}

/// 关闭所有 Overlay
void hideAllOverlay() => FlOverlay().hideAll();

/// 关闭最顶层的 Overlay
void hideOverlay({FlOverlayEntry? entry}) => FlOverlay().hide(entry: entry);
