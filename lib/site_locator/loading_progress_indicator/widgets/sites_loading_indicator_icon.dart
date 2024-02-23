import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_props.dart';
import 'package:flutter/material.dart';

class SitesLoadingIndicatorIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const imagePath = SitesLoadingProgressProps.fuelPumpIconPath;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Image.asset(imagePath),
    );
  }
}
