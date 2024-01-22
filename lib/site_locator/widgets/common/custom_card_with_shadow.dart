import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:flutter/material.dart';

class CustomCardWithShadow extends StatelessWidget {
  final Widget child;

  const CustomCardWithShadow({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: SiteLocatorDimensions.dp3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SiteLocatorDimensions.dp30),
      ),
      child: child,
    );
  }
}
