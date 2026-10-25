import 'dart:async';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

/// [runZonedGuarded] 错误回调
typedef RunZonedGuardedOnError = void Function(Object error, StackTrace stackTrace);

/// 日志类型
enum LogType {
  /// 详细日志
  verbose(color: Colors.grey),

  /// 调试日志
  debug(color: Colors.blue),

  /// 普通信息
  info(color: Colors.green),

  /// 警告
  warn(color: Colors.orange),

  /// 错误
  error(color: Colors.red),

  /// 未处理错误，由 Zone 捕获
  asyncError(color: Colors.redAccent);

  const LogType({required this.color});

  /// 展示颜色
  final Color color;
}

/// 单条日志内容
class LogContent {
  const LogContent({required this.type, required this.dateTime, this.line, this.error, this.stackTrace});

  /// 日志类型
  final LogType type;

  /// 时间
  final DateTime dateTime;

  /// 打印行内容
  final String? line;

  /// 错误对象
  final Object? error;

  /// 堆栈
  final StackTrace? stackTrace;
}

/// 调试日志收集与悬浮入口
class FlLogcat {
  FlLogcat._();

  static final FlLogcat _instance = FlLogcat._();

  static FlLogcat get instance => _instance;

  factory FlLogcat() => _instance;

  final ValueNotifiers<List<LogContent>> _logs = ValueNotifiers([]);

  /// 在 Zone 中运行并收集日志
  R? runZone<R>(
    R Function() body, {
    RunZonedGuardedOnError? onError,
    bool enable = isDebug,
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  }) {
    if (!enable) return body();
    final ZoneSpecification original = zoneSpecification ?? const ZoneSpecification();
    final ZoneSpecification spec = ZoneSpecification.from(
      original,
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        final PrintHandler? handler = original.print;
        if (handler != null) {
          handler(self, parent, zone, line);
        } else {
          parent.print(zone, line);
        }
        insertLog(LogContent(type: LogType.debug, dateTime: DateTime.now(), line: line));
      },
    );
    return runZonedGuarded(
      body,
      (Object error, StackTrace stackTrace) {
        onError?.call(error, stackTrace);
        insertLog(LogContent(type: LogType.asyncError, dateTime: DateTime.now(), error: error, stackTrace: stackTrace));
      },
      zoneValues: zoneValues,
      zoneSpecification: spec,
    );
  }

  /// 最多保留的日志条数
  static const int maxLogs = 500;

  /// 插入日志并尝试展示悬浮入口
  void insertLog(LogContent log) {
    _logs.value.insert(0, log);
    if (_logs.value.length > maxLogs) {
      _logs.value.removeRange(maxLogs, _logs.value.length);
    }
    _logs.notify();
    show();
  }

  /// 是否启用日志收集 UI
  bool isRunning = false;

  FlOverlayEntry? _overlayEntry;

  bool get _hasOverlayEntry => _overlayEntry?.mounted == true;

  /// 显示悬浮日志入口
  void show() {
    if (!isRunning) return;
    if (FlExtended().navigatorKey.currentState == null) return;
    if (_hasOverlayEntry) return;
    _overlayEntry = _LogcatIcon(show: showLog, hide: hide).showOverlay(isCached: false);
  }

  /// 隐藏悬浮日志入口
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 弹出日志列表
  Future<void> showLog() async {
    if (isRunning && FlExtended().navigatorKey.currentContext != null) {
      await const _LogList().popupModalBottomSheet();
    }
  }
}

class _LogcatIcon extends StatefulWidget {
  const _LogcatIcon({required this.show, this.hide});

  /// 隐藏悬浮日志入口
  final void Function()? hide;

  /// 显示悬浮日志入口
  final Future<void> Function() show;

  @override
  State<_LogcatIcon> createState() => _LogcatIconState();
}

class _LogcatIconState extends State<_LogcatIcon> {
  bool hasWindows = false;
  Offset offSet = const Offset(100, 10);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        offSet = Offset(100, MediaQuery.of(context).padding.top + 8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Stack(
      children: [
        Positioned(
          left: offSet.dx,
          top: offSet.dy,
          child: GestureDetector(
            onTap: show,
            onDoubleTap: widget.hide,
            onPanStart: (DragStartDetails details) => update(details.globalPosition),
            onPanUpdate: (DragUpdateDetails details) => update(details.globalPosition),
            child: Container(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.terminal_outlined, size: 23, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// 显示悬浮日志入口
  Future<void> show() async {
    if (hasWindows) {
      Navigator.of(context).maybePop();
      return;
    }
    hasWindows = true;
    try {
      await widget.show();
    } finally {
      hasWindows = false;
    }
  }

  void update(Offset offset) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    if (offset.dx > 1 &&
        offset.dx < size.width - 24 &&
        offset.dy > mediaQuery.padding.top &&
        offset.dy < size.height - mediaQuery.padding.bottom - 24) {
      offSet = Offset(offset.dx - 12, offset.dy - 26);
      setState(() {});
    }
  }
}

class _LogList extends StatelessWidget {
  const _LogList();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Toolbar(
            onDelete: () {
              FlLogcat()._logs.value.clear();
              FlLogcat()._logs.notify();
            },
          ),
          Universal(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
            expanded: true,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: ValueListenableBuilder<List<LogContent>>(
                valueListenable: FlLogcat()._logs,
                builder: (BuildContext context, map, Widget? child) => ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(6),
                  itemCount: map.length,
                  itemBuilder: (_, int index) => itemBuilder(context, map, index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, List<LogContent> log, int index) {
    final item = log[index];
    return Universal(
      width: double.infinity,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SelectionArea(
            child: FlText.richText(
              style: TextStyle(fontSize: 12, color: item.type.color),
              maxLines: 1000,
              texts: [
                '[${item.dateTime} - ${item.type.name}] : \n',
                if (item.line != null) item.line!,
                if (item.error != null) item.error.toString(),
                if (item.stackTrace != null) item.stackTrace.toString(),
              ],
              styles: [TextStyle(fontWeight: FontWeight.w500)],
            ),
          ),
        ),
        10.heightBox,
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 19)),
        const CloseButton(),
      ],
    );
  }
}
