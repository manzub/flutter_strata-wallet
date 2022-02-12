import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final double width;
  final EdgeInsetsGeometry padding;
  final BoxDecoration decoration;

  CustomCard(
      {@required this.child,
      this.margin,
      this.decoration,
      this.width,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? null,
      margin: margin ?? null,
      padding: padding ?? EdgeInsets.all(20.0),
      decoration: decoration,
      child: child,
    );
  }
}
