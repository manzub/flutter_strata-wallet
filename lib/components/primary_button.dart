import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool outlined;
  final Widget child;
  final double width, circular;
  final Function onPressed;
  final Color color;

  PrimaryButton({
    @required this.outlined,
    @required this.child,
    this.onPressed,
    this.width,
    this.circular,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50.0,
      minWidth: width ?? double.infinity,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circular ?? 5.0),
        side: BorderSide(color: color),
      ),
      color: !outlined ? color : null,
      disabledColor: !outlined ? color : null,
      textColor: !outlined ? Colors.white : Colors.black,
      disabledTextColor: !outlined ? Colors.white : Colors.black,
      child: child,
    );
  }
}
