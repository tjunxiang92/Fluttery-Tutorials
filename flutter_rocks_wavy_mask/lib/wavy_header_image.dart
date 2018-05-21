import 'package:flutter/material.dart';

class WavyHeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ClipPath(
      child: new Container(
        height: 200.0,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/coffee_header.jpeg'),
            fit: BoxFit.cover,
            alignment: new Alignment(0.0, 0.0),
          )
        ),
      ),
      
      // new FractionalTranslation(
      //   translation: new Offset(0.0, -0.3),
      //   child: new Image.asset('assets/coffee_header.jpeg'),
      // ),

      clipper: new BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double clippedHeight = size.height;

    Path path = new Path();
    path.lineTo(0.0, clippedHeight - 20.0);
    var firstControlPoint = new Offset(size.width / 4, clippedHeight);
    var firstEndPoint = new Offset(size.width / 2.25, clippedHeight - 30.0);
    path.quadraticBezierTo(
      firstControlPoint.dx, 
      firstControlPoint.dy, 
      firstEndPoint.dx, 
      firstEndPoint.dy
    );
    
    var secondControlPoint = new Offset(size.width - (size.width / 3.25), clippedHeight - 80.0);
    var secondEndPoint = new Offset(size.width, clippedHeight - 40.0);

    path.quadraticBezierTo(
      secondControlPoint.dx, 
      secondControlPoint.dy, 
      secondEndPoint.dx, 
      secondEndPoint.dy
    );

    // path.lineTo(size.width, clippedHeight - 40.0);
    path.lineTo(size.width, 0.0);


    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}