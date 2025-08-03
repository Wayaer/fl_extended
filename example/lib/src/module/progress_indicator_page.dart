import 'package:example/main.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorPage extends StatefulWidget {
  const ProgressIndicatorPage({super.key});

  @override
  State<ProgressIndicatorPage> createState() => _ProgressIndicatorPageState();
}

class _ProgressIndicatorPageState extends State<ProgressIndicatorPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<Color?>? animationColor;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: 10.seconds);
    animationColor = ColorTween(begin: Colors.red, end: Colors.greenAccent).animate(controller);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      appBar: AppBarText('FlProgressIndicator'),
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: controller,
        builder:
            (_, __) => Column(
              children: [
                const Partition('FlProgressIndicator.linear', marginTop: 0),
                ProgressIndicatorOptions.linear(
                  height: 10,
                  borderRadius: BorderRadius.circular(10),
                  value: controller.value,
                  valueColor: animationColor,
                  backgroundColor: Colors.amber,
                ).widget,
                const Partition('FlProgressIndicator.circular'),
                ProgressIndicatorOptions.circular(
                  strokeWidth: 4,
                  width: 100,
                  height: 100,
                  strokeCap: StrokeCap.round,
                  value: controller.value,
                  valueColor: animationColor,
                  backgroundColor: Colors.amber,
                ).widget,
                const Partition('FlProgressIndicator.refresh'),
                ProgressIndicatorOptions.refresh(
                  elevation: 2,
                  width: 100,
                  height: 100,
                  indicatorMargin: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  value: controller.value,
                  valueColor: animationColor,
                  backgroundColor: Colors.amber,
                ).widget,
              ],
            ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
