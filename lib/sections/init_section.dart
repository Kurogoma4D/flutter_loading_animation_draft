import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animations/animations.dart';

class InitSection extends StatelessWidget {
  const InitSection._({Key key}) : super(key: key);

  static Widget wrapped() {
    return MultiProvider(
      providers: [
        Provider<InitSectionController>(
          create: (context) => InitSectionController(),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: const InitSection._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const TranslateAnimationDesktop(),
        Positioned(
          bottom: 20,
          right: 0,
          child: const _ContinueButton(),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 4,
      onPressed: () =>
          context.read<InitSectionController>().continueSignal.sink.add(true),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class InitSectionController {
  InitSectionController({this.locator});

  final Locator locator;
  final StreamController<bool> textChain = StreamController<bool>.broadcast();
  final StreamController<bool> continueSignal =
      StreamController<bool>.broadcast();

  void dispose() {
    textChain.close();
    continueSignal.close();
  }
}
