import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/manage_cache_fuel_prices.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/model/cached_fuel_prices_store.dart';

class GetSitesUncachedFuelPriceUseCase extends BaseFutureUseCase<
    List<SiteLocation>, GetSitesUncachedFuelPriceUseCaseParams> {
  @override
  Future<List<SiteLocation>> execute(
      GetSitesUncachedFuelPriceUseCaseParams param) async {
    List<SiteLocation> uncachedSiteLocations = [];
    final truckStopSiteLocations = param.truckStopLocations;

    if (ManageCacheFuelPrices.isStoreCachPeriodExpired()) {
      ManageCacheFuelPrices.forceToRemoveAllFuelPrices();
      ManageCacheFuelPrices.showRetrieveFuelPricesFuelGaugeMessage(
          param.siteLocatorController);
      uncachedSiteLocations = truckStopSiteLocations;
    } else {
      uncachedSiteLocations = await getAllUncachedSiteLocations(
        siteLocationListParam: param.siteLocationsParamSource,
        truckStopSiteLocations: truckStopSiteLocations,
      );
    }
    return uncachedSiteLocations;
  }

  Future<List<SiteLocation>> getAllUncachedSiteLocations({
    required List<SiteLocation> siteLocationListParam,
    required List<SiteLocation> truckStopSiteLocations,
  }) async {
    final List<SiteLocation> uncachedList = [];

    for (final siteLocation in truckStopSiteLocations) {
      final cachedFuelPriceData =
          getCachedFuelPriceDataForSite(siteLocation.siteIdentifier ?? '');
      if (cachedFuelPriceData == null) {
        uncachedList.add(siteLocation);
      } else {
        await setCachedPriceDataToSiteLocation(
            siteLocationListParam, cachedFuelPriceData);
      }
    }
    return uncachedList;
  }

  Future<void> setCachedPriceDataToSiteLocation(
      List<SiteLocation> siteLocationListParam,
      CachedFuelPriceData fuelPriceData) async {
    final siteLocation = siteLocationListParam.firstWhere(
        (item) => item.siteIdentifier == fuelPriceData.siteIdentifier);
    if (siteLocation.siteIdentifier != null) {
      siteLocation.dieselRetail = fuelPriceData.dieselRetail ?? 0;
      siteLocation.dieselNet = fuelPriceData.dieselNet ?? 0;
      siteLocation.asOfDate = fuelPriceData.asOfDate;
    }
  }

  CachedFuelPriceData? getCachedFuelPriceDataForSite(String siteIdentifier) {
    return ManageCacheFuelPrices.getCachedFuelPrice(
        siteIdentifier: siteIdentifier);
  }
}

class GetSitesUncachedFuelPriceUseCaseParams {
  final List<SiteLocation> truckStopLocations;
  final SiteLocatorController siteLocatorController;
  final List<SiteLocation> siteLocationsParamSource;

  GetSitesUncachedFuelPriceUseCaseParams({
    required this.truckStopLocations,
    required this.siteLocatorController,
    required this.siteLocationsParamSource,
  });
}
