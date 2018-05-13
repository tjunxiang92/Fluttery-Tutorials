import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page/page_dragger.dart';
import 'package:material_page/page_indicator.dart';
import 'package:material_page/page_reveal.dart';
import 'package:material_page/pages.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Material Page Reveal',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // This widget is the root of your application.

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activePage = 0;
  int nextPage = 1;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.dragging == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
          if (slideDirection == SlideDirection.leftToRight) {
            nextPage = activePage - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPage = activePage + 1;
          } else {
            nextPage = activePage;
          }

          if (nextPage < 0 || nextPage > pages.length - 1) {
            slideDirection = SlideDirection.none;
            slidePercent = 0.0;
            nextPage = activePage;
          }
        } else if (event.dragging == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection, 
              transitionGoal: TransitionGoal.open, 
              slidePercent: slidePercent, 
              slideUpdateStream: slideUpdateStream, 
              vsync: this,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection, 
              transitionGoal: TransitionGoal.close, 
              slidePercent: slidePercent, 
              slideUpdateStream: slideUpdateStream, 
              vsync: this,
            );

            nextPage = activePage;
          }

          animatedPageDragger.run();
        } else if (event.dragging == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.dragging == UpdateType.doneAnimating) {
          animatedPageDragger.dispose();
          activePage = nextPage;
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new Page(
            viewModel: pages[activePage],
            percentVisible: 1.0,
          ),
          new PageReveal(
            slideDirection: slideDirection,
            revealPercent: slidePercent,
            child: new Page(
              viewModel: pages[nextPage],
              percentVisible: slidePercent,
            ),
          ),
          new PageIndicator(
            viewModel: new PageIndicatorViewModel(
              pages,
              activePage,
              slideDirection,
              slidePercent,
            )
          ),
          new PageDragger(
            slideUpdateStream: slideUpdateStream,
          ),
        ],
      )
    );
  }
}
