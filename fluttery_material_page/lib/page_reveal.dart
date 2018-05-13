import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_page/page_indicator.dart';

class PageReveal extends StatelessWidget {
  final SlideDirection slideDirection;
  final double revealPercent;
  final Widget child;

  PageReveal({
    this.slideDirection,
    this.revealPercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      clipper: new CircleRevealClipper(slideDirection: slideDirection, revealPercent: revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final SlideDirection slideDirection;
  final double revealPercent;

  CircleRevealClipper({
    this.slideDirection,
    this.revealPercent,
  });

  @override
  Rect getClip(Size size) {
    final xIndex = slideDirection == SlideDirection.leftToRight ? 1 : 3;
    final epicenter = new Offset(size.width * xIndex / 4, size.height * 0.9);
    
    double theta = atan(epicenter.dy / epicenter.dx);
    double distanceToCorner = epicenter.dy / sin(theta);

    double radius = distanceToCorner * revealPercent;
    double diameter = radius * 2;

    return new Rect.fromLTWH(epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}