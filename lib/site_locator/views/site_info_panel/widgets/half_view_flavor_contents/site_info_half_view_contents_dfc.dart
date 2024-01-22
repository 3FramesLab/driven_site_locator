import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/d_site_info_add_fav.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/a_site_info_miles.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/b_site_info_adddress.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/half_view_flavor_contents/c_site_info_phone_service.dart';
import 'package:get/get.dart';

class SiteInfoHalfViewContentsDFC extends StatelessWidget {
  SiteInfoHalfViewContentsDFC(this.selectedSiteLocation);

  final SiteLocatorController siteLocatorController = Get.find();
  final SiteLocation selectedSiteLocation;
  @override
  Widget build(BuildContext context) => headerContent();

  Widget headerContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftColumnHolder(),
              rightColumnHolder(),
            ],
          ),
          const SizedBox(height: 12),
          SiteInfoAddress(selectedSiteLocation),
          const SizedBox(height: 12),
          SiteInfoPhoneService(selectedSiteLocation),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget leftColumnHolder() {
    return SizedBox(
      width: adjustedWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brandLogoTitle(),
          locationName(),
          const SizedBox(height: 20),
          SiteInfoAddFav(selectedSiteLocation),
          const SizedBox(height: 12),
          SiteInfoMiles(selectedSiteLocation),
        ],
      ),
    );
  }

  double get adjustedWidth =>
      canShowRightColumn() ? Get.width - 140 : Get.width - 35;

  Widget brandLogoTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _brandLogo(),
        const HorizontalSpacer(size: 4),
        fuelBrandNameWidget(),
      ],
    );
  }

  Semantics _brandLogo() {
    return Semantics(
      container: true,
      label: SemanticStrings.siteInfoBrandLogo,
      child: SiteInfoUtils.getDisplayBrandLogo(selectedSiteLocation),
    );
  }

  Widget fuelBrandNameWidget() {
    return Flexible(
      child: SizedBox(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoFuelBrandName,
          child: Text(
            SiteInfoUtils.displayFuelBrandName(selectedSiteLocation),
            style: canDisplayLocationName()
                ? f28ExtraboldBlackDark
                : f16SemiboldBlack,
            overflow: TextOverflow.ellipsis,
            maxLines: canDisplayLocationName() ? 1 : 2,
          ),
        ),
      ),
    );
  }

  Widget locationName() {
    if (canDisplayLocationName()) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          child: Semantics(
            container: true,
            label: SemanticStrings.siteInfoLocationName,
            child: Text(
              SiteInfoUtils.getLocationName(selectedSiteLocation),
              style: f16SemiboldBlack,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 12);
    }
  }

  bool canShowRightColumn() => siteLocatorController
      .canDisplayRightColumnDieselPrice(selectedSiteLocation);

  Widget rightColumnHolder() {
    return canShowRightColumn()
        ? SizedBox(
            width: 100,
            child: dieselPricePacks(),
          )
        : const SizedBox.shrink();
  }

  Widget dieselPricePacks() {
    final dieselPacks =
        siteLocatorController.getDieselPricesPack(selectedSiteLocation);
    final whichPrice = dieselPacks.whichPrice;
    final bool isNetAsPrimary = whichPrice == DieselPriceDisplay.both ||
        whichPrice == DieselPriceDisplay.netOnly;
    final bool isRetailAsPrimary = whichPrice == DieselPriceDisplay.retailOnly;

    return Semantics(
      container: true,
      label: SemanticStrings.siteInfoFuelPriceWithType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasToShowDiscountPrice(whichPrice))
            _displayNetPrice(primary: isNetAsPrimary),
          if (hasToShowRetailPrice(whichPrice))
            _displayRetailPrice(primary: isRetailAsPrimary),
        ],
      ),
    );
  }

  bool hasToShowDiscountPrice(DieselPriceDisplay whichPrice) =>
      whichPrice == DieselPriceDisplay.both ||
      whichPrice == DieselPriceDisplay.netOnly;

  bool hasToShowRetailPrice(DieselPriceDisplay whichPrice) =>
      whichPrice == DieselPriceDisplay.both ||
      whichPrice == DieselPriceDisplay.retailOnly;

// Discount Price
  Widget _displayNetPrice({required bool primary}) {
    if (SiteInfoUtils.canDisplayDieselNetPrice(selectedSiteLocation)) {
      return _dieselNetPriceContent(primary: primary);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _dieselNetPriceContent({required bool primary}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          SiteLocatorConstants.diesel,
          style: f14BoldBlackDark,
          textAlign: TextAlign.right,
        ),
        Text(
          dieselNetPrice,
          style: f28ExtraboldBlackDark,
        ),
        const Text(
          SiteLocatorConstants.discountPrice,
          style: f14RegularGrey,
        ),
      ],
    );
  }

  Widget _displayRetailPrice({required bool primary}) {
    if (SiteInfoUtils.canDisplayDieselRetailPrice(selectedSiteLocation)) {
      return _dieselRetailPriceContent(primary: primary);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _dieselRetailPriceContent({required bool primary}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!primary) const SizedBox(height: 10),
        if (primary)
          const Text(
            SiteLocatorConstants.diesel,
            style: f14BoldBlackDark,
            textAlign: TextAlign.right,
          ),
        Text(
          dieselRetailPrice,
          style: primary ? f28ExtraboldBlackDark : f20BoldBlackDark,
        ),
        const Text(
          SiteLocatorConstants.retailPrice,
          style: f14RegularGrey,
        ),
      ],
    );
  }

  String get dieselNetPrice =>
      SiteInfoUtils.getDieselNetPrice(selectedSiteLocation);

  String get dieselRetailPrice =>
      SiteInfoUtils.getDieselRetailPrice(selectedSiteLocation);

  bool canDisplayLocationName() =>
      selectedSiteLocation.fuelBrand != null &&
      SiteInfoUtils.isFuelBrandNameAvailable(selectedSiteLocation);
}
