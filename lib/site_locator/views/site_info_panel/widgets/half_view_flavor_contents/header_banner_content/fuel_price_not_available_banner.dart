import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class FuelPriceNotAvailableBanner extends StatelessWidget {
  FuelPriceNotAvailableBanner(this.selectedSiteLocation, this.type);

  final SiteLocation selectedSiteLocation;
  final FuelPriceAsOfDateBannerViewType type;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    final canShowFlag = siteLocatorController
        .canShowFuelPriceNotAvailableBanner(selectedSiteLocation);

    return canShowFlag
        ? Padding(
            padding: SiteInfoUtils.paddingForFuelPriceTopBanner(
                isInfoView: isInfoView),
            child: Semantics(
              container: true,
              label: SemanticStrings.siteInfoFuelPriceNotAvailable,
              child: const Text(
                SiteLocatorConstants.fuelPriceNotAvailableBannerText,
                style: f14RegularBlack,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : emptyBox();
  }

  Widget emptyBox() =>
      isInfoView ? const SizedBox(height: 25) : const SizedBox.shrink();

  bool get isInfoView => type == FuelPriceAsOfDateBannerViewType.infoPanel;
}
