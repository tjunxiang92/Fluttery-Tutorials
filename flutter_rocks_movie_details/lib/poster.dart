import 'package:flutter/material.dart';

class Poster extends StatelessWidget {
  final String url;
  final double height;

  final POSTER_RATIO = 0.7;

  const Poster({
    this.url,
    this.height = 100.0
  });



  @override
  Widget build(BuildContext context) {
    final width = height * POSTER_RATIO;

    return new Material(
      elevation: 2.0,
      borderRadius: new BorderRadius.circular(4.0),
      child: new Image.asset(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}