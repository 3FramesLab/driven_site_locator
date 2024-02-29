// ignore_for_file: use_setters_to_change_properties

import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/model/cached_fuel_prices_store.dart';

class ManageCacheFuelPrices {
  static int thresholdPeriod = SiteLocatorConfig.fuelPriceCacheDuration;
  static String? selectedCardCustomerIdCached;
  static CachedAllFuelPricesStore cachedAllFuelPricesDataStore =
      CachedAllFuelPricesStore(data: {}, recentTimeStamp: null);
  static bool isCachingFuelPricesAllowed = !(thresholdPeriod == 0);

  static void setSelectedCardCustomerId(String customerIdKey) {
    selectedCardCustomerIdCached = customerIdKey.toLowerCase();
  }

  static void setSelectedCardCustomerIdEmpty() {
    selectedCardCustomerIdCached = '';
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
    return CachedFuelPriceKey(customerId, siteIdentifier).toString();
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
    return selectedCardCustomerIdCached ?? '';
  }

  static CachedFuelPriceData? getCachedFuelPrice({
    required String siteIdentifier,
  }) {
    final allCachedFuelPricesData = getAllCachedFuelPricesData();
    final customerId = selectedCardCustomerIdCached ?? '';
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
            isUserAuthenticated: siteLocatorController.isUserAuthenticated);
  }
}
