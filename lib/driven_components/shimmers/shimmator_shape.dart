import 'package:driven_common_sl_pkg/styles/styles_module.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ShimmatorShape extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final bool isTeal;
  double? borderRadius;
  Color? baseColor;
  Color? highlightColor;
  Color? shapeColor;

  ShimmatorShape.rectangular({
    required this.height,
    this.width = double.infinity,
    this.isTeal = false,
    this.baseColor,
    this.highlightColor,
  }) : shapeBorder = const RoundedRectangleBorder();

  ShimmatorShape.roundedRectangular({
    required this.height,
    this.width = double.infinity,
    this.isTeal = false,
    this.baseColor,
    this.highlightColor,
  }) : shapeBorder = const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)));

  ShimmatorShape.circular({
    required this.height,
    this.width = double.infinity,
    this.isTeal = false,
    this.shapeBorder = const CircleBorder(),
    this.baseColor,
    this.highlightColor,
  });

  ShimmatorShape.roundedRectangularWithRadius({
    required this.height,
    this.width = double.infinity,
    this.isTeal = false,
    this.baseColor,
    this.highlightColor,
    this.borderRadius = 16,
  }) : shapeBorder = RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 16)));

  @override
  Widget build(BuildContext context) {
    if (isTeal) {
      baseColor = Colors.teal[100]!;
      highlightColor = DrivenColors.primary;
      shapeColor = Colors.teal[100]!;
    }
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFF0F0F0),
      highlightColor: highlightColor ?? Colors.grey[300]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: shapeColor ?? Colors.grey[100]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
