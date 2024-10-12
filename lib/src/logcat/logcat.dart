import 'dart:async';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

typedef RunZonedGuardedOnError = void Function(
    Object error, StackTrace stackTrace);

enum _LogType {
  print,
  error,
  errorCallback,
}

class _LogContent {
  const _LogContent(
      {required this.type,
      required this.dateTime,
      this.line,
      this.error,
      this.stackTrace});

  final _LogType type;
  final DateTime dateTime;
  final String? line;
  final Object? error;
  final StackTrace? stackTrace;
}

class FlLogcat {
  FlLogcat._();

  static final ValueNotifiers<List<_LogContent>> _logs = ValueNotifiers([]);

  static R? runZone<R>(R Function() body,
      {RunZonedGuardedOnError? onError,
      bool enable = isDebug,
      Map<Object?, Object?>? zoneValues,
      ZoneSpecification? zoneSpecification}) {
    if (!enable) return body();
    if (zoneSpecification != null) {
      zoneSpecification = ZoneSpecification.from(zoneSpecification,
          errorCallback: (Zone self, ZoneDelegate parent, Zone zone,
              Object error, StackTrace? stackTrace) {
        parent.errorCallback(zone, error, stackTrace);
        _addLog(_LogContent(
          type: _LogType.errorCallback,
          dateTime: DateTime.now(),
          error: error,
          stackTrace: stackTrace,
        ));
        return zoneSpecification!.errorCallback
                ?.call(self, parent, zone, error, stackTrace) ??
            parent.errorCallback(zone, error, stackTrace);
      }, print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        zoneSpecification!.print?.call(self, parent, zone, line);
        parent.print(zone, line);
        _addLog(_LogContent(
            type: _LogType.print, dateTime: DateTime.now(), line: line));
      });
    } else {
      zoneSpecification = ZoneSpecification(errorCallback: (Zone self,
          ZoneDelegate parent,
          Zone zone,
          Object error,
          StackTrace? stackTrace) {
        parent.errorCallback(zone, error, stackTrace);
        _addLog(_LogContent(
          type: _LogType.errorCallback,
          dateTime: DateTime.now(),
          error: error,
          stackTrace: stackTrace,
        ));
        return null;
      }, print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        parent.print(zone, line);
        _addLog(_LogContent(
            type: _LogType.print, dateTime: DateTime.now(), line: line));
      });
    }
    return runZonedGuarded(body, (Object error, StackTrace stackTrace) {
      onError?.call(error, stackTrace);
      _addLog(_LogContent(
        type: _LogType.error,
        dateTime: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      ));
    }, zoneSpecification: zoneSpecification);
  }

  static void _addLog(_LogContent log) {
    _logs.value.add(log);
    _logs.notify();
    if (_scrollController.hasClients) {
      0.5.seconds.delayed(() {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      });
    }
    show();
  }

  static bool isRunning = false;

  static ExtendedOverlayEntry? _overlayEntry;

  static void show() {
    if (isRunning) {
      _overlayEntry ??= _LogIcon(show: showLog, hide: hide).showOverlay();
    }
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static final ScrollController _scrollController = ScrollController();

  static Future<void> showLog() async {
    if (isRunning && FlExtended().navigatorKey.currentContext != null) {
      await showModalBottomSheet(
          context: FlExtended().navigatorKey.currentContext!,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const _LogList());
    }
  }
}

class _LogIcon extends StatefulWidget {
  const _LogIcon({required this.show, this.hide});

  final void Function()? hide;
  final Future<void> Function() show;

  @override
  State<_LogIcon> createState() => _LogIconState();
}

class _LogIconState extends State<_LogIcon> {
  bool hasWindows = false;
  Offset offSet = const Offset(10, 10);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      offSet = Offset(100, MediaQuery.of(context).padding.top + 8);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Stack(children: [
      Positioned(
          left: offSet.dx,
          top: offSet.dy,
          child: GestureDetector(
              onTap: show,
              onDoubleTap: widget.hide,
              onPanStart: (DragStartDetails details) =>
                  update(details.globalPosition),
              onPanUpdate: (DragUpdateDetails details) =>
                  update(details.globalPosition),
              child: Container(
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.terminal_outlined,
                      size: 23, color: Colors.white))))
    ]);
  }

  Future<void> show() async {
    if (hasWindows) {
      Navigator.of(context).maybePop();
    } else {
      hasWindows = true;
      await widget.show();
      hasWindows = false;
    }
  }

  void update(Offset offset) {
    final mediaQuery = MediaQuery.of(context);
    if (offset.dx > 1 &&
        offset.dx < mediaQuery.size.height - 24 &&
        offset.dy > mediaQuery.padding.top &&
        offset.dy < mediaQuery.size.height - mediaQuery.padding.bottom - 24) {
      double dy = offset.dy;
      double dx = offset.dx;
      offSet = Offset(dx -= 12, dy -= 26);
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          _Toolbar(onDelete: () {
            FlLogcat._logs.value.clear();
            FlLogcat._logs.notify();
          }),
          Universal(
              padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
              expanded: true,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: ValueListenableBuilder<List<_LogContent>>(
                      valueListenable: FlLogcat._logs,
                      builder: (_, map, __) => ListView.builder(
                          controller: FlLogcat._scrollController,
                          padding: EdgeInsets.all(6),
                          itemCount: map.length,
                          itemBuilder: (_, int index) =>
                              itemBuilder(context, map, index)))))
        ]));
  }

  Widget itemBuilder(BuildContext context, List<_LogContent> log, int index) {
    final item = log[index];
    return Universal(
        width: double.infinity,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText.rich(style: TextStyle(fontSize: 12), texts: [
            '[${item.dateTime} ${item.type.name.toUpperCase()}] : \n',
            if (item.line != null) item.line!,
            if (item.error != null) item.error.toString(),
            if (item.stackTrace != null) item.stackTrace.toString(),
          ], styles: [
            TextStyle(
                color: context.theme.primaryColor, fontWeight: FontWeight.w500),
            TextStyle(
                color: item.error != null
                    ? context.theme.colorScheme.error
                    : null),
          ]),
          10.heightBox,
        ]);
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 19)),
      const CloseButton(),
    ]);
  }
}
