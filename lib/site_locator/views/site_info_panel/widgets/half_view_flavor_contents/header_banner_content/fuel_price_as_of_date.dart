import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class FuelPriceAsOfDateBanner extends StatelessWidget {
  FuelPriceAsOfDateBanner(this.selectedSiteLocation, this.type);

  final SiteLocation selectedSiteLocation;
  final FuelPriceAsOfDateBannerViewType type;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return selectedSiteLocation.asOfDate != null
        ? displayAsOfDateBanner()
        : emptyBox();
  }

  Widget displayAsOfDateBanner() {
    final asOfdateEntity = siteLocatorController
        .checkFuelPriceAsOfDisplayEntity(selectedSiteLocation);
    final displayDate = asOfdateEntity.displayDate;
    return asOfdateEntity.canShow
        ? Padding(
            padding: EdgeInsets.only(
              top: isInfoView ? 12 : 0,
              bottom: isInfoView ? 0 : 12,
            ),
            child: Semantics(
              container: true,
              label: SemanticStrings.siteInfoFuelPriceAsOfDate,
              child: Text(
                '${SiteLocatorConstants.fuelPriceAsOfBannerText} $displayDate',
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
