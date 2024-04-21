import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Color? color;
  final double? roundedRadius;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final Widget child;
  const CustomInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.roundedRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundedRadius ?? 0),
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            height: height,
            width: width,
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
