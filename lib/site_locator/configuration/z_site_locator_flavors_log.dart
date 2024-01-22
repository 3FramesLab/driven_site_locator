import 'dart:developer';

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:flutter/foundation.dart';

class SiteLocatorFlavorsLog {
  static void configInfo(
      List<String> quickFilters, List<String> fuelBrandsTopShortList) {
    if (kDebugMode) {
      final String infoContent = '''
     =====================================================================
     SiteLocator Configuration Info:
     ---------------------------------------------------------------------
     App Flavor: ${AppUtils.flavor.toUpperCase()}
     isDisplayEnabled: ${SiteLocatorConfig.isDisplayMapEnabled}
     defaultMapRadius: ${SiteLocatorConfig.defaultMapRadius} mi
     defaultBrandLogoPath: ${SiteLocatorConfig.defaultBrandLogoPath}
     defaultFuelType: ${SiteLocatorConfig.defaultFuelType}
     summaryAPIQueryParam: ${SiteLocatorConfig.summaryAPIQueryParam}
     isDiscountFeatureEnabled: ${SiteLocatorConfig.isDiscountFeatureEnabled}
     discountIndicator: ${SiteLocatorConfig.discountIndicator}
     isFeeDisclaimerEnabled: ${SiteLocatorConfig.isFeeDisclaimerEnabled}
     quickFilterOptions: $quickFilters
     fuelBrandsTopShortList: $fuelBrandsTopShortList
     =====================================================================
     ''';

      log(infoContent);
    }
  }
}
