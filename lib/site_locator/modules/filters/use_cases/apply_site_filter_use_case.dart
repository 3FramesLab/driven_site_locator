// ignore_for_file: long-method

part of filter_module;

class ApplySiteFilterUseCase
    extends BaseUseCase<List<SiteLocation>, ApplyEnhancedFilterParams> {
  late List<SiteLocation> filteredLocations;

  ApplySiteFilterUseCase();

  @override
  List<SiteLocation> execute(ApplyEnhancedFilterParams param) {
    final selectedFilters =
        param.selectedFilters.map(SiteFilter.clone).toList();
    final favoriteSites = param.favoriteSites;

    filteredLocations = param.siteLocations ?? [];

    _filterFuelBrands(selectedFilters);

    for (final filter in selectedFilters) {
      switch (filter.serviceType) {
        case ServiceTypeEnum.amenities:
          _amenitiesSwitch(filter.key);
          break;
        case ServiceTypeEnum.features:
          _locationFeatureSwitch(filter.key);
          break;
        case ServiceTypeEnum.fuelType:
          _fuelTypeSwitch(filter.key);
          break;
        case ServiceTypeEnum.locationType:
          _locationTypeSwitch(filter.key);
          break;
        default:
          _filterByFavorites(filter.key, favoriteSites);
      }
    }

    return filteredLocations;
  }

  void _filterFuelBrands(List<SiteFilter> selectedFilters) {
    // Extracts List of keys for type fuel brands.
    final _fuelBrandFilterKeys = selectedFilters
        .where((filter) => filter.serviceType == ServiceTypeEnum.fuelBrand)
        .map((filter) => filter.key.toLowerCase())
        .toList();

    // Remove fuel brands filter, as they are extracted above.
    selectedFilters.removeWhere(
        (filter) => filter.serviceType == ServiceTypeEnum.fuelBrand);

    // filter sites wrt selected fuel brands keys.
    if (_fuelBrandFilterKeys.isNotEmpty) {
      filteredLocations = filteredLocations
          .where((site) => _fuelBrandFilterKeys
              .contains(SiteInfoUtils.formatFuelBrandKeyIdentifier(site)))
          .toList();
    }
  }

  void _amenitiesSwitch(String key) {
    switch (key) {
      case AmenitiesFilterKeys.atm:
        filteredLocations = filteredLocations
            .where((site) => site.services?.atm == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.convenienceStore:
        filteredLocations = filteredLocations
            .where((site) => site.services?.convStore == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.restaurant24Hr:
        filteredLocations = filteredLocations
            .where((site) => site.services?.restaurant24Hr == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.shower:
        filteredLocations = filteredLocations
            .where((site) => site.services?.shower == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.truckStop:
        filteredLocations = filteredLocations
            .where((site) => site.services?.truckStop == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.restaurant:
        filteredLocations = filteredLocations
            .where((site) => site.services?.restaurant == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.lounge:
        filteredLocations = filteredLocations
            .where((site) => site.services?.lounge == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.laundry:
        filteredLocations = filteredLocations
            .where((site) => site.services?.laundry == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.motel:
        filteredLocations = filteredLocations
            .where((site) => site.services?.motel == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.cashAdvance:
        filteredLocations = filteredLocations
            .where((site) => site.services?.cashAdvance == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.deli:
        filteredLocations = filteredLocations
            .where((site) => site.services?.deli == Status.Y)
            .toList();
        break;
      case AmenitiesFilterKeys.gameRoom:
        filteredLocations = filteredLocations
            .where((site) => site.services?.gameRoom == Status.Y)
            .toList();
        break;
    }
  }

  void _locationFeatureSwitch(String key) {
    switch (key) {
      case LocationFeatureFilterKeys.services24Hr:
        filteredLocations = filteredLocations
            .where((site) => site.services?.services24Hr == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.payAtPump:
        filteredLocations = filteredLocations
            .where((site) => site.services?.payAtPump == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.highwayAccess:
        filteredLocations = filteredLocations
            .where((site) => site.services?.hwyAccess == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.rigAccess:
        filteredLocations = filteredLocations
            .where((site) => site.services?.rigAccess == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.rigParking:
        filteredLocations = filteredLocations
            .where((site) => site.services?.rigParking == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.unattended:
        filteredLocations = filteredLocations
            .where((site) => site.services?.unattended == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.truckWash:
        filteredLocations = filteredLocations
            .where((site) => site.services?.truckWash == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.scales:
        filteredLocations = filteredLocations
            .where((site) => site.services?.scales == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.highSpeedPump:
        filteredLocations = filteredLocations
            .where((site) => site.services?.highSpeedPump == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.tankReader:
        filteredLocations = filteredLocations
            .where((site) => site.services?.tankReader == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.permits:
        filteredLocations = filteredLocations
            .where((site) => site.services?.permits == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.repairs:
        filteredLocations = filteredLocations
            .where((site) => site.services?.repairs == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.safeHaven:
        filteredLocations = filteredLocations
            .where((site) => site.services?.safeHaven == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.truckersStore:
        filteredLocations = filteredLocations
            .where((site) => site.services?.truckersStore == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.tireRepair:
        filteredLocations = filteredLocations
            .where((site) => site.services?.tireRepair == Status.Y)
            .toList();
        break;
      case LocationFeatureFilterKeys.wreckerService:
        filteredLocations = filteredLocations
            .where((site) => site.services?.wreckerService == Status.Y)
            .toList();
        break;
    }
  }

  void _fuelTypeSwitch(String key) {
    switch (key) {
      case FuelTypeFilterKeys.diesel:
        filteredLocations = filteredLocations
            .where((site) => site.fuelTypes?.diesel == Status.Y)
            .toList();
        break;
      case FuelTypeFilterKeys.unleadedRegular:
        filteredLocations = filteredLocations
            .where((site) => site.fuelTypes?.unleadedRegular == Status.Y)
            .toList();
        break;
      case FuelTypeFilterKeys.unleadedPremium:
        filteredLocations = filteredLocations
            .where((site) => site.fuelTypes?.unleadedPremium == Status.Y)
            .toList();
        break;
      case FuelTypeFilterKeys.unleadedPlus:
        filteredLocations = filteredLocations
            .where((site) => site.fuelTypes?.unleadedPlus == Status.Y)
            .toList();
        break;
    }
  }

  void _locationTypeSwitch(String key) {
    switch (key) {
      case QuickFilterKeys.fuel:
        filteredLocations = filteredLocations
            .where((site) => site.locationType?.fuelStation == Status.Y)
            .toList();
        break;
      case QuickFilterKeys.truckStop:
        filteredLocations = filteredLocations
            .where((site) => site.locationType?.truckStop == Status.Y)
            .toList();
        break;
      case QuickFilterKeys.service:
        filteredLocations = filteredLocations
            .where((site) => site.locationType?.maintenanceService == Status.Y)
            .toList();
        break;
      case QuickFilterKeys.discounts:
        filteredLocations = filteredLocations
            .where((site) => site.locationType?.fmDiscountNetwork == Status.Y)
            .toList();
        break;
      case QuickFilterKeys.gallonUp:
        filteredLocations = filteredLocations
            .where((site) => site.locationType?.gallonUp == Status.Y)
            .toList();
        break;
    }
  }

  void _filterByFavorites(String key, List<String> favoriteSites) {
    if (key == QuickFilterKeys.favorites) {
      filteredLocations = filteredLocations
          .where((site) => favoriteSites.contains(site.siteIdentifier.toString()))
          .toList();
    }
  }
}

class ApplyEnhancedFilterParams {
  final List<SiteLocation>? siteLocations;
  final List<SiteFilter> selectedFilters;
  final List<String> favoriteSites;

  ApplyEnhancedFilterParams({
    required this.siteLocations,
    required this.selectedFilters,
    required this.favoriteSites,
  });
}
