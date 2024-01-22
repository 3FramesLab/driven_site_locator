import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:flutter/material.dart';

class SiteLocatorDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;

  const SiteLocatorDivider({
    this.height = 0,
    this.thickness = 1,
    this.color = SiteLocatorColors.lightGreyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      height: height,
    );
  }
}
