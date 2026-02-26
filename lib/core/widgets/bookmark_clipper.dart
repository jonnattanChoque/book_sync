import 'package:flutter/material.dart';

class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0); 
    path.lineTo(25, 0); 
    path.lineTo(0, size.height * 0.5); 
    path.lineTo(25, size.height); 
    path.lineTo(size.width, size.height); 
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldDelegate) {
    return false;
  }
}