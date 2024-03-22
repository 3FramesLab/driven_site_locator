import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/listview/list_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/search_locations/search_location_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiteLocationList extends StatefulWidget {
  final Function()? onListViewSiteInfoDetailsTap;
  final Function()? onListViewSiteInfoDetailsBackTap;
  final Widget? stickyHeaderWidget;
  final Widget? scrollingHeaderWidget;
  final bool? canAppendToScroll;
  final bool? canShowLeftTopHeader;

  const SiteLocationList({
    super.key,
    this.onListViewSiteInfoDetailsTap,
    this.onListViewSiteInfoDetailsBackTap,
    this.stickyHeaderWidget,
    this.scrollingHeaderWidget,
    this.canAppendToScroll = false,
    this.canShowLeftTopHeader = true,
  });

  @override
  State<SiteLocationList> createState() => _SiteLocationListState();
}

class _SiteLocationListState extends State<SiteLocationList> {
  final SiteLocatorController controller = Get.find();
  late ScrollController listScrollcontroller;

  final SearchPlacesController searchPlacesController = Get.find();

  @override
  void initState() {
    super.initState();
    controller.onListViewSiteInfoDetailsTap =
        widget.onListViewSiteInfoDetailsTap;
    controller.onListViewSiteInfoDetailsBackTap =
        widget.onListViewSiteInfoDetailsBackTap;
    listScrollcontroller = ScrollController()
      ..addListener(listViewScrollEventListener);
  }

  void listViewScrollEventListener() =>
      controller.listViewScrollHandler(listScrollcontroller);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int present = controller.presentPageIndex();
      final originalItems = controller.siteLocations ?? [];
      final items = controller.listViewItems();
      final itemCount =
          (present <= originalItems.length) ? items.length + 1 : items.length;
      return _buildHeaderSectionWithSiteList(items, itemCount);
    });
  }

  Widget _buildHeaderSectionWithSiteList(
      List<SiteLocation> items, int itemCount) {
    if (items.isEmpty) {
      return NoLocationsFound();
    } else {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            displayStickyHeaderSection(),
            Expanded(
              child: ListView.builder(
                primary: false,
                controller: listScrollcontroller,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if ((widget.canAppendToScroll ?? false) && index == 0) {
                    return Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          displayScrollingHeaderSection(),
                          SiteLocationInfoCard(items[index], index),
                        ],
                      ),
                    );
                  }
                  return displaySiteLocationInfoCard(index, items);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget displayStickyHeaderSection() {
    if ((widget.canShowLeftTopHeader ?? false) &&
        !(widget.canAppendToScroll ?? false)) {
      return widget.stickyHeaderWidget ?? const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget displayScrollingHeaderSection() {
    return widget.scrollingHeaderWidget ?? const SizedBox.shrink();
  }

  Widget displaySiteLocationInfoCard(int index, List<SiteLocation> items) {
    return (index == items.length)
        ? ViewMoreSitesLoadingProgress()
        : SiteLocationInfoCard(items[index], index);
  }
}
