import 'package:driven_common/common/driven_dimensions.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/instance_manager.dart';

class NoLocationsDialog extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final String errorMessage;
  NoLocationsDialog({
    this.errorMessage = SiteLocatorConstants.noLocationsErrorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: contentText,
      ),
    );
  }

  Widget get contentText => Body1Regular14(
        errorMessage,
        height: DrivenDimensions.lineHeight,
      );
}
