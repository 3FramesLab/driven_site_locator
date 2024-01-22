import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/c_site_info_header.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/d_site_info_add_fav.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/e_site_info_short_details.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/site_info_half_view_contents_dfc.dart';
import 'package:flutter/material.dart';

class SiteInfoHalfViewContents extends StatelessWidget {
  const SiteInfoHalfViewContents(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;

  @override
  Widget build(BuildContext context) {
    return (AppUtils.isComdata)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SiteInfoHalfViewContentsDFC(selectedSiteLocation),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SiteInfoHeader(selectedSiteLocation),
              const SizedBox(height: 16),
              SiteInfoAddFav(selectedSiteLocation),
              const SizedBox(height: 12),
              SiteInfoShortDetails(selectedSiteLocation),
              const SizedBox(height: 12),
            ],
          );
  }
}
