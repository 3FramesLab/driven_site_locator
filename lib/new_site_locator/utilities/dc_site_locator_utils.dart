part of site_locator_module;

class DcSiteLocatorUtils {
  static bool isFuelFilterSelectedSeparately = false;
  static bool representativePriceToggleValue = false;
  static final entitlementRepository = SiteLocatorEntitlementUtils.instance;

  static void hideKeyboard() {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}
  }

  static Future<bool> launchURL(
    String url,
    String errorMessage, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (await _canSafeLaunchUrl(url)) {
      await _safeLaunchUrl(url, mode);
      return true;
    }
    return false;
  }

  static Future<bool> _canSafeLaunchUrl(String url) async =>
      Globals().canLaunch(url);

  static Future<bool> _safeLaunchUrl(String url, LaunchMode mode) async =>
      Globals().launch(url, mode: mode);

  static Future<void> openExternalMapApp(
    AvailableMap selectedMap, {
    Coords? originLatLng,
    Coords? destinationLatLng,
  }) async {
    await _openExternalAppTap(selectedMap, originLatLng!, destinationLatLng!);
  }

  static Future<void> _openExternalAppTap(AvailableMap selectedMap,
      Coords originLatLng, Coords destinationLatLng) async {
    // trackAction(
    //   AnalyticsTrackActionName.siteInfoDrawerViewAllDiscountsLinkClickEvent,
    //   adobeCustomTag: AdobeTagProperties.siteInfo,
    // );
    await selectedMap.showDirections(
        origin: originLatLng, destination: destinationLatLng);
  }

  ///

  static void resetData() {
    try {
      final authSLTypeChoicesController =
          Get.find<AuthSLTypeChoicesController>();
      authSLTypeChoicesController.resetFilters();

      final siteLocatorController = Get.find<SLSiteLocatorController>();
      siteLocatorController.resetData();
    } catch (_) {}
  }

  static Future<void> callMerchSitesOnFilterChange({
    CardTypeModel? cardType,
  }) async {
    try {
      if (cardType != null) {
        final controller = Get.find<AuthSLTypeChoicesController>();
        controller.setFuelFilter(cardType.fuelType.value);
      }
      final siteLocatorController = Get.find<SLSiteLocatorController>();
      await siteLocatorController.onFilterSelected();
    } catch (_) {}
  }

  static void isGenerateMapPinsOnFiltering({bool value = false}) {
    try {
      final siteLocatorController = Get.find<SLSiteLocatorController>();
      siteLocatorController.isGenerateMapPinsOnFiltering = value;
    } catch (_) {}
  }

  static void applyMerchFilters() {
    try {
      final siteLocatorController = Get.find<SLSiteLocatorController>();
      siteLocatorController.filterSiteLocations(
        showNoFilterLocationDialog: true,
        shouldSortList: true,
      );
    } catch (_) {}
  }

  static List<String> getVisibleBrandFilterKeys() {
    try {
      final controller = Get.find<AuthSLTypeChoicesController>();
      return controller.visibleBrandFilterKeys;
    } catch (_) {}
    return [];
  }

  static Map<String, List<List<String>>> getSelectedFilters() {
    try {
      final controller = Get.find<AuthSLTypeChoicesController>();
      return controller.selectedSiteFiltersKeysMap();
    } catch (_) {}
    return {};
  }

  static bool isGallonUpFilterSelected() {
    try {
      final controller = Get.find<AuthSLTypeChoicesController>();
      return controller.isGallonUpFilterSelected;
    } catch (_) {}
    return false;
  }

  static bool isMerchFilterApplied() {
    try {
      final controller = Get.find<AuthSLTypeChoicesController>();
      return controller.isMerchFilterApplied();
    } catch (_) {}
    return false;
  }

  static String? getHours(SiteLocation location) {
    try {
      if (location.hours.isNotNullEmptyOrWhitespace) {
        if (location.hours == UmaSLProperties.merchSite24HoursMessage) {
          return '24 Hours';
        } else {
          return location.hours;
        }
      }
    } catch (_) {}
    return null;
  }

  static void setPreFilters() {
    _setPrimaryBusinessFilter();
    _setFuelFilter();
  }

  static void _setPrimaryBusinessFilter() {
    try {
      final controller = Get.find<AuthSLTypeChoicesController>();
      controller
          .setPrimaryBusinessFilter(UmaSLProperties.defaultPrimaryBusiness);
    } catch (_) {}
  }

  static void _setFuelFilter() {
    try {
      String defaultFuel = UmaSLProperties.defaultProductType;

      if (!isGuest) {
        if (SLSessionManager().selectedCardType != null) {
          final fuelType = SLSessionManager().selectedCardType?.fuelType;
          defaultFuel = fuelType?.value ?? UmaSLProperties.defaultProductType;
        }
      }

      final controller = Get.find<AuthSLTypeChoicesController>();
      controller.setFuelFilter(defaultFuel);
    } catch (_) {}
  }

  static Map<String, dynamic> getJsonData({
    required LatLng centerLatLng,
    required double radius,
    String fleetId = '',
    String cardToken = '',
    String siteSource = '',
    String? sysAccountId,
  }) {
    final Map<String, dynamic> jsonData = {
      SLInternalText.siteClusterParam: 'N',
      SLInternalText.sysAccountIdParam: sysAccountId ?? '0_0000_3',
      SLInternalText.latitudeStartHereParam: centerLatLng.latitude.toString(),
      SLInternalText.longitudeStartHereParam: centerLatLng.longitude.toString(),
      SLInternalText.radiusParam: radius.toStringAsFixed(5),
      SLInternalText.siteSourceParam: siteSource,
    };

    if (fleetId.isNotNullEmptyOrWhitespace) {
      jsonData[SLInternalText.fleetIdParam] = fleetId;
    }

    if (cardToken.isNotNullEmptyOrWhitespace) {
      jsonData[SLInternalText.cardToken] = cardToken;
    }

    final cardType = getCardType();
    if (cardType.isNotNullEmptyOrWhitespace) {
      jsonData[SLInternalText.acceptedCardTypeParam] = cardType;
    }

    jsonData[SLInternalText.primaryBusinessParam] = getPrimaryBusiness();

    jsonData[SLInternalText.productTypeParam] = getProductType();

    // TODO(Smeet): uncomment below line if you want to call the filter change API
    // final filterJson = getFilterJson();
    // if (filterJson.isNotEmpty) {
    //   jsonData.addAll(filterJson);
    // }

    return jsonData;
  }

  static String getPrimaryBusiness() {
    try {
      final filterController = Get.find<AuthSLTypeChoicesController>();
      final selectedFilters = filterController.selectedSiteFiltersKeysMap();

      if (selectedFilters.isNotEmpty &&
          selectedFilters[SLInternalText.primaryBusinessKey] != null) {
        final values = selectedFilters[SLInternalText.primaryBusinessKey];
        if (values != null && values.isNotEmpty) {
          return values.first.first;
        }
      }
    } catch (_) {}
    return UmaSLProperties.defaultPrimaryBusiness;
  }

  static String getProductType() {
    if (isFuelFilterSelectedSeparately) {
      try {
        final filterController = Get.find<AuthSLTypeChoicesController>();
        final selectedFilters = filterController.selectedSiteFiltersKeysMap();

        if (selectedFilters.isNotEmpty &&
            selectedFilters[SLInternalText.fuelKey] != null) {
          final values = selectedFilters[SLInternalText.fuelKey];
          if (values != null && values.isNotEmpty) {
            return values.first.first;
          }
        }
      } catch (_) {}
      isFuelFilterSelectedSeparately = false;
    } else {
      try {
        if (isGuest) {
          if (entitlementRepository.isCardTypeFilterEnabled) {
            try {
              final SelectYourCardController selectYourCardController =
                  Get.find();
              if (selectYourCardController.selectedCardType() != null) {
                return selectYourCardController
                    .selectedCardType()!
                    .fuelType
                    .value;
              }
            } catch (_) {}
          } else {
            return SLSessionManager().selectedCardType?.fuelType.value ??
                UmaSLProperties.defaultProductType;
          }
        }
      } catch (_) {}
    }

    return UmaSLProperties.defaultProductType;
  }

  static String? getCardType() {
    try {
      if (isGuest) {
        if (entitlementRepository.isCardTypeFilterEnabled) {
          try {
            final SelectYourCardController selectYourCardController =
                Get.find();
            return selectYourCardController.selectedCardType()?.key;
          } catch (_) {
            return '';
          }
        } else {
          return UmaSLProperties.defaultCardType;
        }
      } else {
        return SLSessionManager().selectedCardType?.key ?? '';
      }
    } catch (_) {
      return '';
    }
  }

  // TODO(Smeet): uncomment below line if you want to call the filter change API
  // static Map<String, dynamic> getFilterJson() {
  //   try {
  //     final AuthSLTypeChoicesController filterController = Get.find();
  //     return filterController.getFilterJson();
  //   } catch (_) {
  //     return {};
  //   }
  // }

  static double? getFuelPriceForMarker(SiteLocation location) {
    final displayFuelPrice = UmaSLProperties.displayFuelPrice;
    if (displayFuelPrice == SLInternalText.dieselKey) {
      return getFuelPrice(
        discountPrice: isGuest
            ? location.newDiscountPriceDiesel
            : location.discountPriceDiesel,
        retailPrice: location.retailPriceDiesel,
      );
    } else if (displayFuelPrice == SLInternalText.gasKey) {
      return getFuelPrice(
        discountPrice:
            displayDiscountedPrice() ? location.discountPriceGas : null,
        retailPrice: location.retailPriceGas,
      );
    } else if (displayFuelPrice == SLInternalText.cngKey) {
      return getFuelPrice(
        discountPrice:
            displayDiscountedPrice() ? location.discountPriceCng : null,
        retailPrice: location.retailPriceCng,
      );
    }

    return _getFuelPriceForMarker(location);
  }

  static double? _getFuelPriceForMarker(SiteLocation location) {
    final filterController = Get.find<AuthSLTypeChoicesController>();
    final selectedFilters = filterController.selectedSiteFiltersKeysMap();

    // First check for Fuel filter.
    if (selectedFilters.isNotEmpty &&
        selectedFilters[SLInternalText.fuelKey] != null) {
      final values = selectedFilters[SLInternalText.fuelKey];
      if (values != null && values.isNotEmpty) {
        if (values.contains(SLInternalText.dieselKey)) {
          return getFuelPrice(
            discountPrice: isGuest
                ? location.newDiscountPriceDiesel
                : location.discountPriceDiesel,
            retailPrice: location.retailPriceDiesel,
          );
        } else if (values.contains(SLInternalText.gasKey)) {
          return getFuelPrice(
            discountPrice:
                displayDiscountedPrice() ? location.discountPriceGas : null,
            retailPrice: location.retailPriceGas,
          );
        } else if (values.contains(SLInternalText.cngKey)) {
          return getFuelPrice(
            discountPrice:
                displayDiscountedPrice() ? location.discountPriceCng : null,
            retailPrice: location.retailPriceCng,
          );
        }
      }
    }

    try {
      final SelectYourCardController selectYourCardController = Get.find();
      if (selectYourCardController.isAnyCardSelected()) {
        switch (selectYourCardController.selectedCardType()?.fuelType) {
          case FuelType.diesel:
            return getFuelPrice(
              discountPrice: isGuest
                  ? location.newDiscountPriceDiesel
                  : location.discountPriceDiesel,
              retailPrice: location.retailPriceDiesel,
            );
          case FuelType.gas:
            return getFuelPrice(
              discountPrice:
                  displayDiscountedPrice() ? location.discountPriceGas : null,
              retailPrice: location.retailPriceGas,
            );
          case FuelType.cng:
            return getFuelPrice(
              discountPrice:
                  displayDiscountedPrice() ? location.discountPriceCng : null,
              retailPrice: location.retailPriceCng,
            );
          case null:
            break;
        }
      }
    } catch (_) {}

    return getFuelPrice(
      discountPrice: isGuest
          ? location.newDiscountPriceDiesel
          : location.discountPriceDiesel,
      retailPrice: location.retailPriceDiesel,
    );
  }

  static double? getFuelPrice({
    required double? discountPrice,
    required double? retailPrice,
  }) {
    if (discountPrice != null && discountPrice > 0) {
      return discountPrice;
    } else if (retailPrice != null && retailPrice > 0) {
      return retailPrice;
    }
    return null;
  }

  static void setNewDiscountedDieselPrice(List<SiteLocation> locations) {
    try {
      if (UmaSLProperties.discountAgainstBrands.isEmpty) {
        return;
      }
      for (final location in locations) {
        if (location.retailPriceDiesel != null &&
            location.retailPriceDiesel! > 0) {
          final brand = location.brandName;

          final discountAgainstBrand =
              UmaSLProperties.discountAgainstBrands.firstWhereOrNull(
            // (e) => e.brand.toLowerCase() == brand?.toLowerCase(),
            (e) => e.brands
                .map((e) => e.toLowerCase())
                .toList()
                .contains(brand?.toLowerCase()),
          );
          if (discountAgainstBrand != null) {
            final applyDiscount =
                double.tryParse(discountAgainstBrand.discount);

            if (applyDiscount != null && applyDiscount > 0) {
              final newDiscountPrice =
                  location.retailPriceDiesel! - applyDiscount;

              if (newDiscountPrice > 0) {
                location.newDiscountPriceDiesel = double.parse(
                    (double.tryParse(newDiscountPrice.toString()) ?? 0.0)
                        .toStringAsFixed(2));
              }
            }
          }
        }
      }
    } catch (_) {}
  }

  // static bool isDieselRetailAvailable(SiteLocation location) {
  //   return location.retailPriceDiesel != null &&
  //       location.retailPriceDiesel! > 0;
  // }

  // static bool isDieselDiscountAvailable(SiteLocation location) {
  //   return location.discountPriceDiesel != null &&
  //       location.discountPriceDiesel! > 0;
  // }

  static bool displayDiscountedPrice() {
    if (isGuest) {
      return false;
    } else {
      return true;
    }
  }

  static bool shouldInvokeGoogleRatingApi() {
    try {
      return entitlementRepository.isInvokeGoogleRatingApiEnabled;
    } catch (_) {}
    return false;
  }

  static bool displayRepresentativePricing() {
    try {
      return representativePriceToggleValue ||
          entitlementRepository.isRepresentativePriceDisclaimerEnabled;
    } catch (_) {}
    return false;
  }

  static List<SlListTabModel> siteLocationListTabs() {
    final List<SlListTabModel> tabs = [];
    try {
      if (entitlementRepository.isCheapestTabEnabled) {
        tabs.add(SlListTabModel(
          title: SLViewText.cheapest,
          sorting: ListViewSorting.cheapest,
        ));
      }
      if (entitlementRepository.isNearbyTabEnabled) {
        tabs.add(SlListTabModel(
          title: SLViewText.nearby,
          sorting: ListViewSorting.nearby,
        ));
      }
      if (entitlementRepository.isBestRatedTabEnabled) {
        tabs.add(SlListTabModel(
          title: SLViewText.bestRated,
          sorting: ListViewSorting.bestRated,
        ));
      }
      if (entitlementRepository.isRecentTabEnabled) {
        tabs.add(SlListTabModel(
          title: SLViewText.recent,
          sorting: ListViewSorting.recent,
        ));
      }
    } catch (_) {}
    return tabs;
  }

  static double generateRandomDouble() {
    return Random().nextInt(6).clamp(0, 5).toDouble();
  }

  static String getRepresentativePricingDate() {
    final dt = DateTime.now();
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String getGallonSavingText({
    required double retailPrice,
    required double discountPrice,
  }) {
    String result = '';
    double savings = retailPrice - discountPrice;

    String savingsStr = savings.toStringAsFixed(2);
    savings = double.parse(savingsStr);
    if (savings >= 0 && savings < 1) {
      savingsStr = savingsStr.substring(savingsStr.indexOf('.') + 1);
      savingsStr = savingsStr.replaceFirst(RegExp('^0+'), '');
      result = 'Save $savingsStr¢/gal';
    } else if (savings >= 1) {
      if (savings % 1 == 0) {
        savingsStr = savingsStr.substring(0, savingsStr.indexOf('.'));
      }
      result = 'Save $savingsStr\$/gal';
    }

    return result;
  }

  static List<SiteLocation> getSortedList({
    required SLSiteLocatorController siteLocatorController,
    required ListViewSorting listViewSorting,
  }) {
    // return siteLocatorController.sortedListViewData();
    switch (listViewSorting) {
      case ListViewSorting.cheapest:
        return siteLocatorController.sortListByPrice();
      case ListViewSorting.nearby:
        return siteLocatorController.sortListByDistance();
      case ListViewSorting.bestRated:
        return siteLocatorController.sortListByRatings();
      case ListViewSorting.recent:
        return siteLocatorController.recentViewSiteLocations();
    }
  }

  // static bool get isGuest => AppUtils.isGuest;

  // static bool get isCardholder => AppUtils.isCardHolder;
  static bool isGuest = false;
  static bool isCardholder = false;
}

class SlListTabModel {
  final String title;
  final ListViewSorting sorting;

  SlListTabModel({
    required this.title,
    required this.sorting,
  });
}

enum ListViewSorting {
  cheapest,
  nearby,
  bestRated,
  recent,
}


/*

Possibly amenities:
 
ATM
C-Store
CarWash
CashAdvnce
CourierFdX
CourierUPS
Diesel
EMV_CDProp
EMV_CFN
EMV_FMProp
EMV_MC
EMV_PP
EVCharge
FemaleShwr
FoodOutlet
FullServce
GallonupFe
GameRoom
Gas
Laundry
Lodging
Lounge
MaleShwrs
P97Crdless
ParkingFee
PayAtPump
Permits
RepairMajr
RepairMinr
RepairTire
RestRooms
SepTrkPmps
TrkPrkOvNt
TrkPrkPave
TrkPrkUnPv
TruckWash
TruckrsStr

*/