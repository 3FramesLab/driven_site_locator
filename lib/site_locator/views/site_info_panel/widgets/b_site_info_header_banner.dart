import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/header_banner_content/header_banner_content.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/header_banner_content/header_banner_content_dfc.dart';
import 'package:flutter/material.dart';

class SiteInfoHeaderBanner extends StatelessWidget {
  const SiteInfoHeaderBanner(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;

  @override
  Widget build(BuildContext context) {
    return AppUtils.isComdata
        ? SiteInfoHeaderBannerContentDFC(
            selectedSiteLocation, FuelPriceAsOfDateBannerViewType.infoPanel)
        : SiteInfoHeaderBannerContent(selectedSiteLocation);
  }
}
