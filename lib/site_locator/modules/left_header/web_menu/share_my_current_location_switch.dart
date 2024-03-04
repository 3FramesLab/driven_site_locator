import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class ShareMyCurrentLocationSwitch extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  ShareMyCurrentLocationSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Semantics(
        container: true,
        label: SemanticStrings.shareMyCurrentLocationSwitch,
        child: ToggleSwitchContainer(
          child: DrivenCupertinoSwitch(
            value: siteLocatorController.shareMyCurrentLocationStatus(),
            activeColor: DrivenColors.flashGreen,
            onChanged: siteLocatorController.onToggleShareMyCurrentLocation,
            inactiveColor: Colors.white,
            thumbColor: siteLocatorController.shareMyCurrentLocationStatus()
                ? Colors.white
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
