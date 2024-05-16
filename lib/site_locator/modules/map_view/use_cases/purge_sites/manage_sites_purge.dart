part of map_view_module;

class ManageSitesPurge {
  // If “As Of” date is older than 2 days, do not show site pricing
  static const daysLimitToshowAsOfDateAndPrice = 1; // in days
  //“As Of” date is older than 6 days or if there is no “As Of” date at all, do not show pin drop at all
  static const daysLimitToPurgeSites = 7; // in days
  static const priceValueLimit = 3.0;

  static List<SiteLocation>? removeSitesPerAsOfDate(
      List<SiteLocation>? siteLocations) {
    siteLocations?.removeWhere(_hasToRemove);
    return siteLocations ?? [];
  }

  static bool _hasToRemove(SiteLocation siteLocation) {
    final asOfDateSource = siteLocation.fuelPriceSourceEntity?.asOfDate;
    if (siteLocation.locationType?.truckStop == Status.Y) {
      if (asOfDateSource != null) {
        final parsedAsOfDate = parseToDate(asOfDateSource);
        if (parsedAsOfDate != null) {
          final daysDiff = getDaysDiff(
              fromDate: parseToDate(asOfDateSource)!, toDate: DateTime.now());
          if (daysDiff >= daysLimitToPurgeSites) {
            return true; // remove this Site
          } else {
            return _hasToRemoveForLessPrice(siteLocation);
          }
        }
      } else {
        return true; // asOfDate null so remove this site
      }
      return _hasToRemoveForLessPrice(siteLocation);
    } else {
      return false; // retain the Service Locations Sites;
    }
  }

  static bool checkForPriceLimitToRemove(SiteLocation siteLocation) {
    final dieselPriceRetailSource =
        siteLocation.fuelPriceSourceEntity?.dieselRetail ?? '0.0';
    final dieselPriceNetSource =
        siteLocation.fuelPriceSourceEntity?.dieselNet ?? '0.0';
    if (Globals().isCardHolderLogin) {
      if (double.parse(dieselPriceRetailSource) < priceValueLimit ||
          double.parse(dieselPriceNetSource) < priceValueLimit) {
        return true; // remove this site
      }
    } else {
      if (double.parse(dieselPriceRetailSource) < priceValueLimit) {
        return true; // remove this site
      }
    }
    return false; // Retain this site
  }

  static bool _hasToRemoveForLessPrice(SiteLocation siteLocation) {
    bool removeFlag = false; // retain this site as default
    if (checkForPriceLimitToRemove(siteLocation)) {
      removeFlag = true; // remove this site
    }
    return removeFlag;
  }

  static void setFuelPriceSourceEntity(
      SiteLocation siteLocation, FuelPrices fuelPriceData) {
    siteLocation.fuelPriceSourceEntity = FuelPrices(
      asOfDate: fuelPriceData.asOfDate,
      dieselRetail: fuelPriceData.dieselRetail,
      dieselNet: fuelPriceData.dieselNet,
      locationId: fuelPriceData.locationId,
    );
  }

  static int getDaysDiff(
          {required DateTime fromDate, required DateTime toDate}) =>
      toDate.difference(fromDate).inDays;

  static FuelPrices? fuelPriceEntityToUI(FuelPrices fuelPriceData) {
    String? asOfDateToUI = fuelPriceData.asOfDate;
    String? dieselRetailToUI = fuelPriceData.dieselRetail;
    String? dieselNetToUI = fuelPriceData.dieselNet;
    if (asOfDateToUI != null) {
      final parsedAsOfDate = parseToDate(asOfDateToUI);
      if (parsedAsOfDate != null) {
        final daysDiff = getDaysDiff(
            fromDate: parseToDate(asOfDateToUI)!, toDate: DateTime.now());
        if (daysDiff > daysLimitToshowAsOfDateAndPrice) {
          asOfDateToUI = null;
          dieselRetailToUI = null;
          dieselNetToUI = null;
        }
      }
    }
    return FuelPrices(
        asOfDate: asOfDateToUI,
        dieselRetail: dieselRetailToUI,
        dieselNet: dieselNetToUI,
        locationId: fuelPriceData.locationId);
  }
}
