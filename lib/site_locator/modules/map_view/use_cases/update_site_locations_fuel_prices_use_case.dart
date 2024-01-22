part of map_view_module;

class UpdateSiteLocationsFuelPricesUseCase
    extends BaseFutureUseCase<void, UpdateSiteLocationsFuelPricesParams> {
  final SiteLocatorController? siteLocatorController;
  final SiteLocationsService siteLocationsService;
  final GetAccessTokenForSitesUseCase getAccessTokenForSitesUseCase =
      Get.put(GetAccessTokenForSitesUseCase());

  UpdateSiteLocationsFuelPricesUseCase({
    required this.siteLocationsService,
    this.siteLocatorController,
  });

  // will be remove this usecase
  // whenever we will decide to move this caching logic to BFF in future.
  GetSitesUncachedFuelPriceUseCase sitesUncachedFuelPriceUseCase = Get.find();

  @override
  Future<void> execute(UpdateSiteLocationsFuelPricesParams param) async {
    try {
      final siteLocationsParamSource =
          List<SiteLocation>.from(param.siteLocations ?? []);
      final truckStopSiteLocations =
          getTruckStopSiteLocations(siteLocationsParamSource);
      List<SiteLocation> uncachedSiteLocations = [];

      // Fuel Price Caching Mechanism usecase interface starts
      // will be remove this from UI when we have caching at BFF, in future.
      if (ManageCacheFuelPrices.isCachingFuelPricesAllowed) {
        final cacheParam = GetSitesUncachedFuelPriceUseCaseParams(
          siteLocatorController: siteLocatorController!,
          truckStopLocations: truckStopSiteLocations,
          siteLocationsParamSource: siteLocationsParamSource,
        );
        uncachedSiteLocations =
            await sitesUncachedFuelPriceUseCase.execute(cacheParam);
      } else {
        uncachedSiteLocations = truckStopSiteLocations;
      }
      // Fuel Price Caching Mechanism usecase interface ends

      if (uncachedSiteLocations.isNotEmpty) {
        ManageCacheFuelPrices.showRetrieveFuelPricesFuelGaugeMessage(
            siteLocatorController!);
        final fuelPricesApiCallBatchesCount =
            getFuelPricesApiCallBatchesCount(uncachedSiteLocations.length);

        for (var i = 0; i < fuelPricesApiCallBatchesCount; i++) {
          await _fetchAndUpdateFuelPrices(
            param,
            siteLocationsBatchToFetchFuelPrice: uncachedSiteLocations
                .skip(i * SiteLocatorApiConstants.defaultFuelPricesApiLimit)
                .take(SiteLocatorApiConstants.defaultFuelPricesApiLimit)
                .toList(),
          );
        }
      }

      siteLocatorController?.siteLocations = param.siteLocations!;
      await siteLocatorController
          ?.processSiteLocations(siteLocatorController?.siteLocations ?? []);
      await siteLocatorController?.validateSiteLocationWithFilters();
    } on Exception catch (e) {
      Globals().dynatrace.logError(
            name: DynatraceErrorMessages.getFuelPricesAPIErrorName,
            value: DynatraceErrorMessages.getFuelPricesAPIErrorValue,
            reason: e.toString(),
          );
    }
  }

  List<SiteLocation> getTruckStopSiteLocations(
      List<SiteLocation> siteLocationsParamSource) {
    return siteLocationsParamSource
        .where((item) => item.locationType?.truckStop == Status.Y)
        .toList();
  }

  int getFuelPricesApiCallBatchesCount(int sitesCount) =>
      sitesCount % SiteLocatorApiConstants.defaultFuelPricesApiLimit == 0
          ? sitesCount ~/ SiteLocatorApiConstants.defaultFuelPricesApiLimit
          : (sitesCount ~/ SiteLocatorApiConstants.defaultFuelPricesApiLimit) +
              1;

  Future<void> _fetchAndUpdateFuelPrices(
      UpdateSiteLocationsFuelPricesParams param,
      {required List<SiteLocation> siteLocationsBatchToFetchFuelPrice}) async {
    final accessToken = await getAccessTokenForSitesUseCase.execute();
    final fuelPrices = await siteLocationsService.getFuelPrices(
      _getFuelPricesJson(param, siteLocationsBatchToFetchFuelPrice),
      headerQueryParams: accessToken,
    );

    if (fuelPrices != null) {
      // will be removing this from UI when we have caching at BFF, in future.
      if (ManageCacheFuelPrices.isCachingFuelPricesAllowed) {
        ManageCacheFuelPrices.setStoreCachedTime();
      }

      param.siteLocations?.forEach((siteLocation) {
        final fuelPriceData = fuelPrices.firstWhereOrNull(
            (p) => p.locationId == siteLocation.siteIdentifier);
        if (fuelPriceData != null) {
          siteLocation.dieselRetail =
              double.parse(fuelPriceData.dieselRetail ?? '0');
          siteLocation.dieselNet = double.parse(fuelPriceData.dieselNet ?? '0');
          siteLocation.asOfDate = fuelPriceData.asOfDate;

          // will be removing this from UI when we have caching at BFF, in future.
          _saveNewPricesToCache(siteLocation, fuelPriceData);
        }
      });
    }
  }

  void _saveNewPricesToCache(
      SiteLocation siteLocation, FuelPrices fuelPriceData) {
    // will be removing this from UI when we have caching at BFF, in future.
    if (ManageCacheFuelPrices.isCachingFuelPricesAllowed) {
      final priceData = CachedFuelPriceData(
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        siteIdentifier: siteLocation.siteIdentifier,
        asOfDate: fuelPriceData.asOfDate,
        dieselNet: double.parse(fuelPriceData.dieselNet ?? '0'),
        dieselRetail: double.parse(fuelPriceData.dieselRetail ?? '0'),
      );
      ManageCacheFuelPrices.saveSiteFuelPriceData(
        priceData: priceData,
      );
    }
  }

  Map<String, dynamic> _getFuelPricesJson(
      UpdateSiteLocationsFuelPricesParams param,
      List<SiteLocation> siteLocationsBatchToFetchFuelPrice) {
    final fuelPricesJson = {
      'scLocationIds': _getSiteLocationIds(siteLocationsBatchToFetchFuelPrice),
      'sysAccountId': SiteLocatorApiConstants.defaultSysAccountId,
    };

    // Checking for comdata user login and preparing json.
    if (param.isUserAuthenticated) {
      if (Globals().isCardHolderLogin) {
        _getCardholderFuelPrices(fuelPricesJson);
      } else {
        _getFleetManagerFuelPrices(fuelPricesJson);
      }
    } else {
      ManageCacheFuelPrices.setSelectedCardCustomerIdEmpty();
    }
    return fuelPricesJson;
  }

  void _getFleetManagerFuelPrices(Map<String, Object?> fuelPricesJson) {
    final ExtractAccessTokenDataUseCase extractAccessTokenDataUseCase =
        Get.put(ExtractAccessTokenDataUseCase());
    // final LoginController loginController = Get.find();
    final accessToken = DrivenSiteLocator.instance.getFleetManagerAccessToken();
    final accessTokenData = extractAccessTokenDataUseCase.execute(
        // AccessTokenData(loginController.tokenDetails?.accessToken ?? ''));
        AccessTokenData(accessToken));
    fuelPricesJson.update('sysAccountId',
        (value) => _getSysAccountId(accessTokenData['FNAccountCode']));
    final fleetId = _getFleetId(accessTokenData['CustomerId']);
    fuelPricesJson['fleetId'] = _getFleetId(accessTokenData['CustomerId']);
    ManageCacheFuelPrices.setSelectedCardCustomerId(fleetId);
  }

  void _getCardholderFuelPrices(Map<String, Object?> fuelPricesJson) {
    if (DrivenSiteLocator.instance.hasCards()) {
      fuelPricesJson.update(
        'sysAccountId',
        (value) => _getSysAccountId(DrivenSiteLocator.instance.accountCode),
      );
      final fleetId = _getFleetId(DrivenSiteLocator.instance.customerId);
      fuelPricesJson['fleetId'] = fleetId;
      ManageCacheFuelPrices.setSelectedCardCustomerId(fleetId);
    } else {
      ManageCacheFuelPrices.setSelectedCardCustomerIdEmpty();
    }
  }

  String _getSysAccountId(String accountCode) {
    return '${accountCode}_0000_3';
  }

  String _getFleetId(String customerId) {
    return customerId;
  }

  List<String?>? _getSiteLocationIds(List<SiteLocation> siteLocationsList) =>
      siteLocationsList.map((e) => e.siteIdentifier).toList();
}

class UpdateSiteLocationsFuelPricesParams {
  final List<SiteLocation>? siteLocations;
  final bool isUserAuthenticated;

  UpdateSiteLocationsFuelPricesParams({
    this.siteLocations,
    this.isUserAuthenticated = false,
  });
}
