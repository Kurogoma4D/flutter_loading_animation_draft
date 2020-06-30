import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animation/sections/init_section.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

const colors = [
  Colors.blue,
  Colors.cyan,
  Colors.lightGreen,
  Colors.green,
];

class DelayedCurve extends Curve {
  const DelayedCurve();

  @override
  double transform(double t) {
    return (t.clamp(0.2, 0.8) - 0.2) / 0.6;
  }
}

class TranslateAnimationDesktop extends StatefulWidget {
  const TranslateAnimationDesktop({Key key}) : super(key: key);

  @override
  _TranslateAnimationDesktopState createState() =>
      _TranslateAnimationDesktopState();
}

class _TranslateAnimationDesktopState extends State<TranslateAnimationDesktop>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController endController;
  Animation<double> translate;
  Animation<double> translateEnd;
  Stream signal;
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    endController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    translate = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(controller)
          ..addListener(() => setState(() {}));

    translateEnd = Tween(begin: 0.0, end: -1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(endController)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              await Future.delayed(const Duration(milliseconds: 2000));
              context.read<AnimationManager>().state = AnimationState.MAIN;
            }
          });

    signal = context.read<InitSectionController>().continueSignal.stream;
    signal.listen((event) {
      if (event) {
        isStopped = true;
        endController.forward();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var i = 0; i < 4; i++)
          Positioned(
            top: (isStopped ? translateEnd.value : translate.value) *
                MediaQuery.of(context).size.height *
                lerpedValue(i),
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colors[i],
            ),
          )
      ],
    );
  }

  double lerpedValue(int index) {
    final c = isStopped ? controller.value : endController.value;
    return c + 0.5 * index;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
