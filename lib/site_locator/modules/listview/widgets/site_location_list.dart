import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/listview/list_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/search_locations/search_location_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiteLocationList extends StatelessWidget {
  final SiteLocatorController controller = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();
  SiteLocationList({super.key});

  @override
  Widget build(BuildContext context) {
    final int present = controller.presentPageIndex();
    final originalItems = controller.siteLocations ?? [];
    final items = controller.listViewItems();
    final itemCount =
        (present <= originalItems.length) ? items.length + 1 : items.length;
    return _siteLocationCards(items, itemCount);
  }

  Widget _siteLocationCards(List<SiteLocation> items, int itemCount) {
    if (items.isEmpty) {
      return NoLocationsFound();
    } else {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return (index == items.length)
              ? ViewMoreSitesButton()
              : SiteLocationInfoCard(items[index], index);
        },
      );
    }
  }
}
