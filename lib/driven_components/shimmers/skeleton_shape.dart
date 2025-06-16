import 'package:driven_common/styles/styles_module.dart';
import 'package:flutter/material.dart';

class SkeletonShape extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonShape({
    required this.height,
    this.borderRadius = 16,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DrivenColors.shimmerBarColor,
          borderRadius: BorderRadius.all(Radius.circular(
            borderRadius,
          )),
        ),
      );
}
