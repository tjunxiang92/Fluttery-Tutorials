import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page/page_indicator.dart';

class PageDragger extends StatefulWidget {

  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({
    this.slideUpdateStream,
  });

  @override
  State<StatefulWidget> createState() {
    return new _PageDraggerState();
  }
  
}

class _PageDraggerState extends State<PageDragger> {

  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart == null) {
      return;
    }

    final newPosition = details.globalPosition;
    final dx = newPosition.dx - dragStart.dx;
    if (dx > 0) {
      slideDirection = SlideDirection.leftToRight;
    } else if (dx < 0) {
      slideDirection = SlideDirection.rightToLeft;
    } else {
      slideDirection = SlideDirection.none;
    }

    slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);

    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
  }

  onDragEnd(DragEndDetails details) {
    dragStart = null;
    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.doneDragging, SlideDirection.none, 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }

}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = new Duration(
        milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round(),
      );
    } else {
      endSlidePercent = 0.0;
      final slideRemaining = slidePercent;
      duration = new Duration(
        milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round(),
      );
    }

    completionAnimationController = new AnimationController(
      duration: duration,
      vsync: vsync,
    )
    ..addListener(() {
      final slidePercent = lerpDouble(
          startSlidePercent, 
          endSlidePercent, 
          completionAnimationController.value
        );

      slideUpdateStream.add(
        new SlideUpdate(
          UpdateType.animating, 
          slideDirection, 
          slidePercent
        )
      );
    })
    ..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        slideUpdateStream.add(
          new SlideUpdate(
            UpdateType.doneAnimating,
            slideDirection,
            endSlidePercent
          )
        );
      }
    });
  }

  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final UpdateType dragging;
  final SlideDirection direction;
  final double slidePercent;

  SlideUpdate(
    this.dragging,
    this.direction,
    this.slidePercent,
  );
}