import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/header_banner_content/fuel_price_as_of_date.dart';
import 'package:flutter/material.dart';

class SiteInfoHeaderBannerContentDFC extends StatelessWidget {
  const SiteInfoHeaderBannerContentDFC(this.selectedSiteLocation, this.type);

  final SiteLocation selectedSiteLocation;
  final FuelPriceAsOfDateBannerViewType type;

  @override
  Widget build(BuildContext context) {
    return selectedSiteLocation.asOfDate != null
        ? FuelPriceAsOfDateBanner(selectedSiteLocation, type)
        : const SizedBox(height: 16);
  }
}
