import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';

class SiteLocatorDiscount {
  static final discountIndicator = SiteLocatorConfig.discountIndicator;

  static bool isEligible(SiteLocation siteLocation) {
    final discountIndicator = SiteLocatorConfig.discountIndicator;
    if (discountIndicator != SiteLocatorConfig.notApplicable) {
      if (isEligibleBoth()) {
        return siteLocation.locationType?.fmDiscountNetwork == Status.Y &&
            siteLocation.locationType?.mcDiscountNetwork == Status.Y;
      } else if (isEligibleForFM()) {
        return siteLocation.locationType?.fmDiscountNetwork == Status.Y;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static bool isEligibleBoth() => isEligibleForFM() && isEligibleForMC();

  static bool isEligibleForFM() =>
      discountIndicator.contains(SiteLocatorConfig.fmDiscountKey);

  static bool isEligibleForMC() =>
      discountIndicator.contains(SiteLocatorConfig.mcDiscountKey);
}
