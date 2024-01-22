import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/a_site_info_miles.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/b_site_info_adddress.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/c_site_info_phone_service.dart';
import 'package:get/get.dart';

class SiteInfoShortDetails extends StatelessWidget {
  SiteInfoShortDetails(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SiteInfoMiles(selectedSiteLocation),
        const VerticalSpacer(size: 12),
        SiteInfoAddress(selectedSiteLocation),
        const VerticalSpacer(size: 12),
        SiteInfoPhoneService(selectedSiteLocation),
        const VerticalSpacer(size: 12),
      ],
    );
  }
}
