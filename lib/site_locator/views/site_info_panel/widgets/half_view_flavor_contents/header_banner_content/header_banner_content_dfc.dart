import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/header_banner_content/fuel_price_as_of_date.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/header_banner_content/fuel_price_not_available_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiteInfoHeaderBannerContentDFC extends StatelessWidget {
  SiteInfoHeaderBannerContentDFC(this.selectedSiteLocation, this.type);

  final SiteLocation selectedSiteLocation;
  final FuelPriceAsOfDateBannerViewType type;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isPriceNotAvailableFlag = siteLocatorController
        .canShowFuelPriceNotAvailableBanner(selectedSiteLocation);
    if (isPriceNotAvailableFlag) {
      return FuelPriceNotAvailableBanner(selectedSiteLocation, type);
    } else {
      return selectedSiteLocation.asOfDate != null
          ? FuelPriceAsOfDateBanner(selectedSiteLocation, type)
          : const SizedBox(height: 16);
    }
  }
}
