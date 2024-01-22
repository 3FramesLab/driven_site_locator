import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/site_info_detail.dart';
import 'package:get/get.dart';

class SiteInfoMiles extends StatelessWidget {
  SiteInfoMiles(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return drivingDistanceMilesWidget(selectedSiteLocation);
  }

  Widget drivingDistanceMilesWidget(SiteLocation selectedSiteLocation) => Obx(
        () => siteLocatorController.milesDisplay().isNotEmpty
            ? Semantics(
                container: true,
                label: SemanticStrings.siteInfoDrivingDistance,
                child: SiteInfoDetail(
                  iconData: Icons.drive_eta_outlined,
                  description: siteLocatorController.milesDisplay(),
                ),
              )
            : const SizedBox(height: 18),
      );
}
