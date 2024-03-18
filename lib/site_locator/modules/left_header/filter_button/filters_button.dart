import 'package:driven_common/driven_common_resources_module.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/filters/filter_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiltersButton extends StatelessWidget {
  FiltersButton({Key? key}) : super(key: key);

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [filterButton(), _filterCountBadge],
    );
  }

  Container filterButton() {
    return Container(
      height: 40,
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
            Icon(Icons.filter_alt_outlined),
            SizedBox(width: 2),
            Text(
              SiteLocatorConstants.filters,
              style: f14SemiboldBlack,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _filterCountBadge => Positioned(
        right: -1,
        top: -1,
        child: SelectedFilterCountBadge(),
      );
}
