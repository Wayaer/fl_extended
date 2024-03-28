import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:example/src/scaffold.dart';
import 'package:fl_extended/fl_extended.dart';

class FlAnimationPage extends StatefulWidget {
  const FlAnimationPage({super.key});

  @override
  State<FlAnimationPage> createState() => _FlAnimationPageState();
}

class _FlAnimationPageState extends State<FlAnimationPage> {
  Map<String, Function> animation = {};

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        appBar: AppBarText('FlAnimation'),
        children: [
          FlAnimation(
              delayDuration: 2.seconds,
              stayDuration: 6.seconds,
              animationDuration: 3.seconds,
              style: FlAnimationStyle.fade,
              onAnimate: (running) {
                animation.addAll({'fade': running});
              },
              child: buildText('fade')),
          FlAnimation(
              delayDuration: 2.seconds,
              style: FlAnimationStyle.horizontalHunting,
              onAnimate: (running) {
                animation.addAll({'horizontalHunting': running});
              },
              child: buildText('horizontalHunting')),
          FlAnimation(
              delayDuration: 2.seconds,
              style: FlAnimationStyle.verticalHunting,
              onAnimate: (running) {
                animation.addAll({'verticalHunting': running});
              },
              child: buildText('verticalHunting')),
        ]);
  }

  Widget buildText(String text) {
    return Universal(
        width: 300,
        height: 50,
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
        onTap: () {
          animation[text]?.call();
        },
        child: BText(text, color: Colors.white));
  }
}
