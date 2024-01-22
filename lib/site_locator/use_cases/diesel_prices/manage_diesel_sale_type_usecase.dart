import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_preferences.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/get_diesel_prices_pack_usecase.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:get/get.dart';

class ManageDieselSaleTypeUseCase
    extends BaseUseCase<DieselPriceDisplay, DieselPricesPackParam> {
  late SiteLocatorController siteLocatorController;

  @override
  DieselPriceDisplay execute(DieselPricesPackParam param) {
    siteLocatorController = Get.find();
    final siteLocation = param.siteLocation;

    if (siteLocatorController.isUserAuthenticated) {
      return authenticatedUserSaleType(siteLocation);
    } else {
      return unauthenticatedUserSaleType(siteLocation);
    }
  }

  DieselPriceDisplay authenticatedUserSaleType(SiteLocation siteLocation) {
    if (!Globals().isCardHolderLogin) {
      return getSaleTypeForFleetAdmin(siteLocation);
    } else {
      return getSaleTypeForCardHolder(siteLocation);
    }
  }

  DieselPriceDisplay getSaleTypeForFleetAdmin(SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.both;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.netOnly;
    } else if (_whenSiteHasRetailPriceOnly(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

  DieselPriceDisplay getSaleTypeForCardHolder(SiteLocation siteLocation) {
    final hasCards = DrivenSiteLocator.instance.hasCards();

    if (hasCards) {
      return getSaleTypeWhenWalletHasCards(siteLocation);
    } else {
      return getSaleTypeWhenWalletHasNoCards(siteLocation);
    }
  }

  DieselPriceDisplay getSaleTypeWhenWalletHasNoCards(
      SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.nothing;
    } else if (_whenSiteHasRetailPriceOnly(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

// hasCards and preffered sale type logic starts
  DieselPriceDisplay getSaleTypeWhenWalletHasCards(SiteLocation siteLocation) {
    final fuelPreferenceType =
        siteLocatorController.selectedCardFuelPreferenceType;

    if (fuelPreferenceType == FuelPreferenceType.both) {
      return _hasCardsButPreferredBoth(siteLocation);
    } else if (fuelPreferenceType == FuelPreferenceType.net) {
      return _hasCardsButPreferredNetOnly(siteLocation);
    } else if (fuelPreferenceType == FuelPreferenceType.retail) {
      return _hasCardsButPreferredRetailOnly(siteLocation);
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

  DieselPriceDisplay _hasCardsButPreferredBoth(SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.both;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.netOnly;
    } else if (_whenSiteHasRetailPriceOnly(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

  DieselPriceDisplay _hasCardsButPreferredNetOnly(SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.netOnly;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.netOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

  DieselPriceDisplay _hasCardsButPreferredRetailOnly(
      SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.nothing;
    } else if (_whenSiteHasRetailPriceOnly(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }
// hasCards and preffered sale type logic ends

  DieselPriceDisplay unauthenticatedUserSaleType(SiteLocation siteLocation) {
    if (_whenSiteHasBothPrices(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else if (_whenSiteHasNetPriceOnly(siteLocation)) {
      return DieselPriceDisplay.nothing;
    } else if (_whenSiteHasRetailPriceOnly(siteLocation)) {
      return DieselPriceDisplay.retailOnly;
    } else {
      return DieselPriceDisplay.nothing;
    }
  }

  bool _whenSiteHasBothPrices(SiteLocation siteLocation) =>
      SiteInfoUtils.canDisplayDieselNetPrice(siteLocation) &&
      SiteInfoUtils.canDisplayDieselRetailPrice(siteLocation);

  bool _whenSiteHasNetPriceOnly(SiteLocation siteLocation) =>
      SiteInfoUtils.canDisplayDieselNetPrice(siteLocation) &&
      !SiteInfoUtils.canDisplayDieselRetailPrice(siteLocation);

  bool _whenSiteHasRetailPriceOnly(SiteLocation siteLocation) =>
      !SiteInfoUtils.canDisplayDieselNetPrice(siteLocation) &&
      SiteInfoUtils.canDisplayDieselRetailPrice(siteLocation);
}
