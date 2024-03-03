import 'dart:ui';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';

class UniversalPage extends StatefulWidget {
  const UniversalPage({super.key});

  @override
  State<UniversalPage> createState() => _UniversalPageState();
}

class _UniversalPageState extends ExtendedState<UniversalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Color color = context.theme.primaryColor;
    List<Widget> children = [
      Universal(
          width: 200,
          height: 50,
          color: color,
          margin: const EdgeInsets.all(10),
          isClipRRect: true,
          borderRadius: BorderRadius.circular(10),
          alignment: Alignment.center,
          child: const BText('ScrollUniversal', color: Colors.white),
          onTap: () => push(_ScrollUniversalPage())),
      Universal(
          color: color.withOpacity(0.2),
          isStack: true,
          size: const Size(100, 100),
          children: [
            Universal(
                left: 10, top: 10, color: color, size: const Size(50, 50)),
          ]),
      const SizedBox(height: 10),
      Universal(
          size: const Size(300, 20),
          direction: Axis.horizontal,
          color: Colors.green.withOpacity(0.2),
          children: const [
            Universal(flex: 1, color: Colors.red),
            Universal(flex: 2, color: Colors.greenAccent),
          ]),
      const SizedBox(height: 10),
      Universal(
          size: const Size(200, 100),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: Colors.primaries)),
          child: Universal(filter: ImageFilter.blur())),
      const SizedBox(height: 10),
      Universal(
          decoration: const BoxDecoration(color: Colors.red),
          clipBehavior: Clip.antiAlias,
          color: color,
          opacity: 0.2,
          onTap: () {
            RefreshControllers().call(EasyRefreshType.refresh);
          },
          size: const Size(200, 50)),
      const SizedBox(height: 20),
    ];
    children = children.builder((Widget item) => SizeTransition(
        sizeFactor: controller, axis: Axis.horizontal, child: item));
    return ExtendedScaffold(
        appBar: AppBarText('Universal'),
        mainAxisAlignment: MainAxisAlignment.center,
        isScroll: true,
        refreshConfig: RefreshConfig(onRefresh: () async {
          await showToast('onRefresh');
          RefreshControllers().call(EasyRefreshType.refreshSuccess);
        }),
        children: children);
  }
}

class _ScrollUniversalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollUniversal'),
        mainAxisAlignment: MainAxisAlignment.center,
        child: scrollUniversal(context));
  }

  Widget scrollUniversal(BuildContext context) {
    Color color = context.theme.primaryColor;
    return Universal(
        isScroll: true,
        direction: Axis.horizontal,
        isWrap: true,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: context.theme.colorScheme.background,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.red, blurRadius: 20),
              BoxShadow(color: Colors.greenAccent, blurRadius: 15),
              BoxShadow(color: Colors.indigo, blurRadius: 10),
              BoxShadow(color: Colors.yellowAccent, blurRadius: 5)
            ]),
        refreshConfig: RefreshConfig(onRefresh: () async {
          await showToast('onRefresh');
          RefreshControllers().call(EasyRefreshType.refreshSuccess);
        }),
        child: Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 130,
            color: Colors.greenAccent),
        // isStack: true,
        children: [
          Container(
              margin: const EdgeInsets.all(10),
              width: 90,
              height: 90,
              color: color),
          Container(
              margin: const EdgeInsets.all(10),
              width: 70,
              height: 70,
              color: Colors.black),
          Container(
              margin: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              color: Colors.amberAccent),
        ]);
  }
}
