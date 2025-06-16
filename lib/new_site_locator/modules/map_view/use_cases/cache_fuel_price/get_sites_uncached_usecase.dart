import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:driven/new_site_locator/modules/map_view/use_cases/cache_fuel_price/manage_cache_fuel_prices.dart';
import 'package:driven/new_site_locator/modules/map_view/use_cases/cache_fuel_price/model/cached_fuel_prices_store.dart';
import 'package:driven/new_site_locator/new_site_locator_module.dart';

class GetSitesUncachedFuelPriceUseCase extends BaseFutureUseCase<
    GetSitesPriceCachedResult, GetSitesUncachedFuelPriceUseCaseParams> {
  @override
  Future<GetSitesPriceCachedResult> execute(
      GetSitesUncachedFuelPriceUseCaseParams param) async {
    List<SiteLocation> uncachedSiteLocations = [];
    GetSitesPriceCachedResult result = GetSitesPriceCachedResult.blank();
    final truckStopSiteLocations = param.truckStopLocations;

    if (ManageCacheFuelPrices.isStoreCachPeriodExpired()) {
      ManageCacheFuelPrices.forceToRemoveAllFuelPrices();
      ManageCacheFuelPrices.showRetrieveFuelPricesMessage(
          param.siteLocatorController);
      uncachedSiteLocations = truckStopSiteLocations;
    } else {
      result = await getAllUncachedSiteLocations(
        siteLocationListParam: param.siteLocationsParamSource,
        truckStopSiteLocations: truckStopSiteLocations,
      );
      uncachedSiteLocations = result.priceUncachedSiteLocations;
    }

    return GetSitesPriceCachedResult(
      priceUncachedSiteLocations: uncachedSiteLocations,
      priceCachedSiteLocations: result.priceCachedSiteLocations,
    );
  }

  Future<GetSitesPriceCachedResult> getAllUncachedSiteLocations({
    required List<SiteLocation> siteLocationListParam,
    required List<SiteLocation> truckStopSiteLocations,
  }) async {
    final List<SiteLocation> priceUncachedSiteList = [];
    final List<SiteLocation> priceCachedSiteList = [];

    for (final siteLocation in truckStopSiteLocations) {
      final cachedFuelPriceData =
          getCachedFuelPriceDataForSite(siteLocation.siteIdentifier ?? '');
      if (cachedFuelPriceData == null) {
        priceUncachedSiteList.add(siteLocation);
      } else {
        final siteLocation = await getCachedPriceSiteLocation(
            siteLocationListParam, cachedFuelPriceData);
        priceCachedSiteList.add(siteLocation);
      }
    }

    return GetSitesPriceCachedResult(
      priceUncachedSiteLocations: priceUncachedSiteList,
      priceCachedSiteLocations: priceCachedSiteList,
    );
  }

  Future<SiteLocation> getCachedPriceSiteLocation(
      List<SiteLocation> siteLocationListParam,
      CachedFuelPriceData fuelPriceData) async {
    SiteLocation priceCachedSiteLocation = SiteLocation.blank();
    final siteLocation = siteLocationListParam.firstWhere(
        (item) => item.siteIdentifier == fuelPriceData.siteIdentifier);
    if (siteLocation.siteIdentifier != null) {
      siteLocation.dieselRetail = fuelPriceData.dieselRetail ?? 0;
      siteLocation.dieselNet = fuelPriceData.dieselNet ?? 0;
      siteLocation.asOfDate = fuelPriceData.asOfDate;

      /// gas
      siteLocation.gasRetail = fuelPriceData.gasRetail ?? 0;
      siteLocation.gasNet = fuelPriceData.gasNet ?? 0;
      siteLocation.gasAsOfDate = fuelPriceData.gasAsOfDate;

      siteLocation.fuelPriceSourceEntity?.dieselRetail =
          fuelPriceData.dieselRetail != null
              ? '${fuelPriceData.dieselRetail}'
              : '0';
      siteLocation.fuelPriceSourceEntity?.dieselNet =
          fuelPriceData.dieselNet != null ? '${fuelPriceData.dieselNet}' : '0';
      siteLocation.fuelPriceSourceEntity?.asOfDate = fuelPriceData.asOfDate;

      /// gas
      siteLocation.fuelPriceSourceEntity?.gasRetail =
          fuelPriceData.gasRetail != null ? '${fuelPriceData.gasRetail}' : '0';
      siteLocation.fuelPriceSourceEntity?.gasNet =
          fuelPriceData.gasNet != null ? '${fuelPriceData.gasNet}' : '0';
      siteLocation.fuelPriceSourceEntity?.gasAsOfDate =
          fuelPriceData.gasAsOfDate;

      priceCachedSiteLocation = siteLocation;
    }
    return priceCachedSiteLocation;
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

class GetSitesPriceCachedResult {
  final List<SiteLocation> priceUncachedSiteLocations;
  final List<SiteLocation> priceCachedSiteLocations;

  GetSitesPriceCachedResult({
    required this.priceUncachedSiteLocations,
    required this.priceCachedSiteLocations,
  });

  factory GetSitesPriceCachedResult.blank() => GetSitesPriceCachedResult(
        priceUncachedSiteLocations: [],
        priceCachedSiteLocations: [],
      );
}
