import 'package:flutter/material.dart';

class CauseBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height,
        size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height* 0.6,
        0, size.height * 0.8);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}