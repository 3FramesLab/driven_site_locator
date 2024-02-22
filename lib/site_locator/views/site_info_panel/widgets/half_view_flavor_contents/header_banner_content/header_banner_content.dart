import 'package:driven_site_locator/config/site_locator_routes.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class SiteInfoHeaderBannerContent extends StatelessWidget {
  const SiteInfoHeaderBannerContent(this.selectedSiteLocation);

  final SiteLocation selectedSiteLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SiteLocatorConstants.infoDiscountFeesBannerHeight,
      margin: getMargin(),
      decoration: boxDecoration(),
      child: !SiteLocatorConfig.hasDiscountNetwork(selectedSiteLocation)
          ? feeApplyButtonBanner()
          : fuelmanDiscountsNetworkLocationBanner(),
    );
  }

  Widget feeApplyButtonBanner() {
    return TextButton(
      onPressed: _feesMayApplyTap,
      child: const Text(
        SiteLocatorConstants.feesMayApply,
        style: f16SemiboldWhiteUnderline,
      ),
    );
  }

  Widget fuelmanDiscountsNetworkLocationBanner() {
    final showFmDiscountNetwork =
        selectedSiteLocation.locationType?.fmDiscountNetwork!.value == 'Y';
    return Visibility(
      visible: showFmDiscountNetwork,
      child: const Center(
        child: Text(
          SiteLocatorConstants.fuelmanDiscountNetworkLocation,
          textAlign: TextAlign.center,
          style: f16SemiboldBlack,
        ),
      ),
    );
  }

  EdgeInsets getMargin() {
    return const EdgeInsets.only(top: 8);
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: SiteInfoUtils.infoPanelTopBorder,
      color: bannerHeaderBackGroundColor(),
    );
  }

  Color bannerHeaderBackGroundColor() {
    if (SiteLocatorConfig.hasDiscountNetwork(selectedSiteLocation)) {
      return SiteLocatorColors.discountBg;
    } else {
      return Colors.black;
    }
  }

  void _feesMayApplyTap() {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerFeesMayApplyLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.siteInfo,
    );
    Get.toNamed(SiteLocatorRoutes.extendedNetworkFeesPage);
  }
}
