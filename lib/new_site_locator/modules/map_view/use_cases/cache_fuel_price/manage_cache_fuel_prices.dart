// ignore_for_file: use_setters_to_change_properties

import 'package:driven/common/session_managers/driven_session_manager.dart';
import 'package:driven/common/utilities/app_utils.dart';
import 'package:driven/common_modules/add_fuel_card/fuel_card_module.dart';
import 'package:driven/driven_components.dart';
import 'package:driven/modules/wallet/controllers/wallet_controller.dart';
import 'package:driven/new_site_locator/modules/map_view/use_cases/cache_fuel_price/model/cached_fuel_prices_store.dart';
import 'package:driven/new_site_locator/new_site_locator_module.dart';
import 'package:driven/site_locator/configuration/site_locator_config.dart';
import 'package:get/get.dart';

class ManageCacheFuelPrices {
  static int thresholdPeriod = SiteLocatorConfig.fuelPriceCacheDuration;

  static CachedAllFuelPricesStore cachedAllFuelPricesDataStore =
      CachedAllFuelPricesStore(data: {}, recentTimeStamp: null);
  static bool isCachingFuelPricesAllowed = !(thresholdPeriod == 0);
  static bool isStandAloneFuelPriceCall = false;
  static bool isCheckForProgressor = true;
  static WalletController walletController = Get.put(WalletController());
  static FuelCardsController fuelcardController =
      Get.put(FuelCardsController());
  static SiteLocatorController slController = Get.put(SiteLocatorController());

  static String lowercaseCustomerId(String customerIdKey) {
    return customerIdKey.toLowerCase();
  }

  static bool isStoreCachPeriodExpired() {
    final cachedTimeStamp = cachedAllFuelPricesDataStore.recentTimeStamp;

    if (cachedTimeStamp == null) {
      return true;
    } else {
      final timeElapsed =
          getTimeDiff(cachedTimeStamp, unit: TimeDiffUnits.minutes);
      final isCachPeriodExpiredFlag = timeElapsed >= thresholdPeriod;

      return isCachPeriodExpiredFlag;
    }
  }

  static void setStoreCachedTime() {
    cachedAllFuelPricesDataStore.recentTimeStamp ??=
        DateTime.now().millisecondsSinceEpoch;
  }

  static void resetStoreCachedTime() {
    cachedAllFuelPricesDataStore.recentTimeStamp =
        DateTime.now().millisecondsSinceEpoch;
  }

  static String formatKey(
    String customerId,
    String siteIdentifier,
  ) {
    return CachedFuelPriceKey(lowercaseCustomerId(customerId), siteIdentifier)
        .toString();
  }

  static CachedAllFuelPricesStore getAllCachedFuelPricesData() {
    final cachedFuelPricesModelData = cachedAllFuelPricesDataStore;
    return cachedFuelPricesModelData;
  }

  static void saveSiteFuelPriceData({required CachedFuelPriceData priceData}) {
    final customerId = getSelectedCardCustomerId();
    cachedAllFuelPricesDataStore.data?.putIfAbsent(
      formatKey(customerId, priceData.siteIdentifier ?? ''),
      () => priceData,
    );
  }

  static String getSelectedCardCustomerId() {
    String fleetId = '';
    if (AppUtils.isComdata &&
        AppUtils.isCardHolderLogin &&
        DrivenSessionManager().isUserAuthenticated) {
      walletController = Get.find();
      if (walletController.wallet().hasCards()) {
        fleetId = walletController.wallet().activeCard.customerId;
      }
    }
    if (AppUtils.isComdata && !DrivenSessionManager().isUserAuthenticated) {
      fuelcardController = Get.find();

      fleetId = fuelcardController.selectedfuelCard().customerId ?? '';
    }

    return lowercaseCustomerId(fleetId);
  }

  static CachedFuelPriceData? getCachedFuelPrice({
    required String siteIdentifier,
  }) {
    final allCachedFuelPricesData = getAllCachedFuelPricesData();
    final customerId = getSelectedCardCustomerId();
    final cachedFuelPriceKey =
        CachedFuelPriceKey(customerId, siteIdentifier).toString();

    final cachedFuelPriceData =
        allCachedFuelPricesData.data?[cachedFuelPriceKey];

    return cachedFuelPriceData;
  }

  static void removeAllCachedFuelPricesData() {
    cachedAllFuelPricesDataStore = CachedAllFuelPricesStore(
      recentTimeStamp: null,
      data: {},
    );
  }

  static void forceToRemoveAllFuelPrices() {
    cachedAllFuelPricesDataStore =
        CachedAllFuelPricesStore(data: {}, recentTimeStamp: null);
  }

  static void purgeAllExpiredFuelPriceData() {
    cachedAllFuelPricesDataStore.data?.removeWhere((key, value) {
      final timeDiff = getTimeDiff(value?.timeStamp ?? 0);
      return timeDiff >= thresholdPeriod;
    });
  }

  static void showRetrieveFuelPricesMessage(
      SiteLocatorController siteLocatorController) {
    siteLocatorController.sitesLoadingProgressController
        .setRetrievingFuelPricesMessage(
            isUserAuthenticated: DrivenSessionManager().isUserAuthenticated);
  }

  static void removeByCustomerId(String customerId) {
    cachedAllFuelPricesDataStore.data
        ?.removeWhere((key, value) => key.contains(customerId.toLowerCase()));
    debugPrint(cachedAllFuelPricesDataStore.data?.toString());
  }
}
