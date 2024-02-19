import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:flutter/material.dart';

class RoutePlannerButton extends StatelessWidget {
  const RoutePlannerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 158,
      child: OutlinedButton(
        onPressed: () {
          // TODO
        },
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          foregroundColor: Colors.black,
          side: const BorderSide(width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              SiteLocatorAssets.routeIcon,
              height: SiteLocatorDimensions.dp24,
              width: SiteLocatorDimensions.dp24,
            ),
            const SizedBox(width: 2),
            const Text('Route Planner'),
          ],
        ),
      ),
    );
  }
}
