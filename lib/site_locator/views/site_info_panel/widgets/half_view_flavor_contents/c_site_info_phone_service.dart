import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class SiteInfoPhoneService extends StatelessWidget {
  SiteInfoPhoneService(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return getPhoneAndServiceWidget();
  }

  Widget getPhoneAndServiceWidget() {
    if (selectedSiteLocation.locationPhone == null &&
        selectedSiteLocation.locationType?.maintenanceService == Status.N) {
      return const SizedBox();
    } else {
      return Row(
        children: [
          SiteInfoUtils.getPhoneWidget(selectedSiteLocation),
          const HorizontalSpacer(size: 48),
          Expanded(child: getServiceOrTime()),
        ],
      );
    }
  }

  Widget getServiceOrTime() {
    return AppUtils.isComdata
        ? SiteInfoUtils.getTimeWidget(selectedSiteLocation)
        : SiteInfoUtils.getServiceWidget(selectedSiteLocation);
  }
}
