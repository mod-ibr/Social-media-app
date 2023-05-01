import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AnimatedNavigation {
  void navigate({required Widget widget, required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      PageTransition(
        type: PageTransitionType.topToBottom,
        child: widget,
      ),
      (route) => false,
    );
  }
}
