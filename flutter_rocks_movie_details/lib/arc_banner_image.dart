import 'package:flutter/material.dart';

class ArcBannerImage extends StatelessWidget {
  final String imageUrl;
  
  ArcBannerImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return new ClipPath(
      clipper: new ArcClipper(),
      child: new Image.asset(
        imageUrl,
        width: screenWidth,
        height: 230.0,
        fit: BoxFit.cover,
      )
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    Offset startpoint = new Offset(size.width * 3 / 4, size.height);
    Offset endpoint = new Offset(size.width, size.height - 30.0);
    path.quadraticBezierTo(
      startpoint.dx, 
      startpoint.dy,
      endpoint.dx,
      endpoint.dy,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  // @override
  // Path getClip(Size size) {
  //   Path path = new Path();
  //   path.moveTo(0.0, 0.0);
  //   path.moveTo(0.0, size.height - 30.0);
    
  //   Offset startpoint = new Offset(size.width / 2, size.height);
  //   Offset endpoint = new Offset(size.width, size.height - 20.0);
  //   // path.quadraticBezierTo(
  //   //   startpoint.dx, 
  //   //   startpoint.dy,
  //   //   endpoint.dx,
  //   //   endpoint.dy,
  //   // );
  //   // path.moveTo(size.width, size.height - 20.0);
  //   path.moveTo(size.width, 0.0);
  //   // path.moveTo(0.0, 0.0);
  //   path.close();
  //   return path;
  // }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
