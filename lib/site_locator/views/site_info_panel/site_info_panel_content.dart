import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/additional_details/a_additional_details_container.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/a_panel_handle.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/b_site_info_header_banner.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/f_site_info_short_actions.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/g_site_info_show_more_arrow.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/site_info_half_view_contents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiteInfoPanelContent extends GetView<SiteLocatorController> {
  const SiteInfoPanelContent(
    this.scrollController, {
    this.showExtraData = false,
  });

  final ScrollController scrollController;
  final bool showExtraData;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Obx(
        () {
          final selectedSiteLocation = controller.selectedSiteLocation();
          return ListView(
            controller: scrollController,
            children: <Widget>[
              PanelHandle(),
              SiteInfoHeaderBanner(selectedSiteLocation),
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SiteInfoHalfViewContents(selectedSiteLocation),
                    if (AppUtils.isComdata) const SizedBox(height: 16),
                    SiteInfoShortActions(selectedSiteLocation),
                    _iconShowMoreArrow,
                    _containerAdditionalDetail(selectedSiteLocation),
                    // add additional contents / widgets here
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _iconShowMoreArrow => AnimatedOpacity(
        opacity: controller.showFullViewExtraData() ? 0 : 1,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 800),
        child: SiteInfoShowMoreArrow(),
      );

  Widget _containerAdditionalDetail(SiteLocation selectedSiteLocation) =>
      AnimatedOpacity(
        opacity: controller.showFullViewExtraData() ? 1 : 0,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 800),
        child: AdditionalDetailsContainer(selectedSiteLocation),
      );
}
