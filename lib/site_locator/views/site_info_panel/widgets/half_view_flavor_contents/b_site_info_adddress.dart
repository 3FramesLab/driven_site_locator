import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class SiteInfoAddress extends StatelessWidget {
  SiteInfoAddress(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return addressWidget();
  }

  Widget addressWidget() => Row(
        children: [
          _addressIcon(),
          const HorizontalSpacer(size: 7.5),
          _addressText()
        ],
      );

  Widget _addressIcon() => Semantics(
        container: true,
        label: SemanticStrings.siteInfoAddressIcon,
        child: const Icon(
          Icons.pin_drop_outlined,
          size: SiteLocatorConstants.siteInfoIconSize,
          color: DrivenColors.textColor,
        ),
      );

  Widget _addressText() => Expanded(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoAddressText,
          child: Text(
            SiteInfoUtils.linearFullAddress(selectedSiteLocation),
            style: f14RegularBlack,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
}
