import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page/pages.dart';

class PageIndicator extends StatelessWidget {
  final PageIndicatorViewModel viewModel;

  PageIndicator({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel.pages.length; i++) {
      final PageViewModel page = viewModel.pages[i];

      var activePercent;
      if (viewModel.activeIndex == i) {
        activePercent = 1.0 - viewModel.slidePercent;
      } else if (viewModel.activeIndex - 1 == i && viewModel.slideDirection == SlideDirection.leftToRight) {
        activePercent = viewModel.slidePercent;
      } else if (viewModel.activeIndex + 1 == i && viewModel.slideDirection == SlideDirection.rightToLeft) {
        activePercent = viewModel.slidePercent;
      } else {
        activePercent = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        new PageBubble(
          viewModel: new PageBubbleViewModel(
            page.iconAssetIcon,
            page.color,
            isHollow,
            activePercent,
          )
        )
      );
    }

    final COLUMN_WIDTH = 45.0;
    var translation = (viewModel.pages.length * COLUMN_WIDTH / 2) - COLUMN_WIDTH / 2 - COLUMN_WIDTH * viewModel.activeIndex;
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += COLUMN_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= COLUMN_WIDTH * viewModel.slidePercent;
    }

    return new Column(
      children: [
        new Expanded(child: new Container()),
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        )
      ]
    );
  }
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 45.0,
      height: 65.0,
      child: new Center(
        child: new Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          child: new Opacity(
            opacity: viewModel.activePercent,
            child: new Image.asset(
              viewModel.iconAssetPath,
              color: viewModel.color,
            ),
          ),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow 
              ? const Color(0x88FFFFFF).withAlpha((0x88 * viewModel.activePercent).round()) 
              : const Color(0x88FFFFFF),
            border: new Border.all(
              width: 3.0,
              color: viewModel.isHollow 
                ? const Color(0x88FFFFFF).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round())
                : Colors.transparent,
            )
          ),
          
        ),
      ),
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PageIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PageIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent
  );
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
    this.iconAssetPath,
    this.color,
    this.isHollow,
    this.activePercent,
  );
}