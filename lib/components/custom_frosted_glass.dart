// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
//import 'dart:ui';

class CustomFrostedGlassBox extends StatelessWidget {
  const CustomFrostedGlassBox({
    super.key,
    this.theWidth,
    this.theHeight,
    this.theChild,
    required this.theColor,
  });

  final theWidth;
  final theHeight;
  final theChild;
  final Color theColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: theWidth,
          height: theHeight,
          decoration: BoxDecoration(
            color: theColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: theChild,
        ),
      ),
    );
  }
}
