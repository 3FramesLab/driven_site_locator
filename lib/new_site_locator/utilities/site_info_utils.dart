part of site_locator_module;

class SiteInfoUtils {
  static BorderRadius infoPanelTopBorder = const BorderRadius.only(
      topLeft: Radius.circular(10), topRight: Radius.circular(10));

  static const cardPadding =
      EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 10);

  static Color getCardBgColor(int index) =>
      index % 2 == 0 ? Colors.white : SLColors.grey100;

  static bool isFuelBrandNameAvailable(SiteLocation siteLocation) =>
      isFuelBrandFieldAvailable(siteLocation);

  static bool isFuelBrandFieldAvailable(SiteLocation siteLocation) =>
      siteLocation.fuelBrand != null &&
      ((siteLocation.fuelBrand?.isNotEmpty ?? false) &&
          siteLocation.fuelBrand?.toLowerCase() !=
              SLInternalText.unbranded.toLowerCase());

  static String displayFuelBrandName(SiteLocation siteLocation) =>
      getDisplayFuelBrand(siteLocation);

  static String getDisplayFuelBrand(SiteLocation siteLocation) =>
      // isFuelBrandFieldAvailable(siteLocation)
      (siteLocation.fuelBrand ?? '').toUpperCase();
  // : siteLocation.locationName ?? '';

  static String getLocationName(SiteLocation siteLocation) =>
      siteLocation.locationName ?? '';

  static bool isGallonUpPreferredLocation(SiteLocation siteLocation) =>
      siteLocation.amenities?.contains(SLInternalText.gallonUpFeeKey) ?? false;

  static String getStreetAddress(SiteLocation siteLocation) =>
      siteLocation.locationStreetAddress ?? '';

  static String getFullAddress(SiteLocation siteLocation) {
    final List<String> result = [];
    final street = siteLocation.locationStreetAddress ?? '';
    final city = siteLocation.locationCity ?? '';
    final state = siteLocation.locationState ?? '';
    final zipSrc = siteLocation.locationZip ?? '';
    final String? zipSplit = zipSrc.split('-')[0];
    final zip = zipSplit ?? '';

    if (street.isNotEmpty) {
      result.add(street);
    }
    if (city.isNotEmpty) {
      result.add(city);
    }
    if (state.isNotEmpty) {
      result.add(state);
    }
    if (zip.isNotEmpty) {
      result.add(zip);
    }

    return result.join(', ');
  }

  static bool isNotNullAndNotEmpty(String? val) =>
      val != null && val.isNotEmpty;

  static String goodAddressData(String? data, {bool trailComma = true}) =>
      isNotNullAndNotEmpty(data) ? (trailComma ? '$data, ' : '$data') : '';

  static String linearFullAddress(SiteLocation siteLocation) {
    final String street = goodAddressData(siteLocation.locationStreetAddress);
    final String city = goodAddressData(siteLocation.locationCity);
    final String state = goodAddressData(siteLocation.locationState);
    final String zipCodeExtension =
        goodAddressData(siteLocation.locationZip, trailComma: false);
    final zipCode = onlyZipCode(zipCodeExtension);

    return '$street$city$state$zipCode';
  }

  static String onlyZipCode(String zipCodeExtension) {
    String zipCode = zipCodeExtension;
    if (isNotNullAndNotEmpty(zipCodeExtension) &&
        zipCodeExtension.contains('-')) {
      final zipSegments = zipCodeExtension.split('-');
      zipCode = zipSegments.first;
    }
    return zipCode;
  }

  static bool canDisplayBrandLogo(SiteLocation siteLocation) {
    return isFuelBrandFieldAvailable(siteLocation);
  }

  static String getDieselPrice(SiteLocation siteLocation) {
    if (siteLocation.dieselPrice != null && siteLocation.dieselPrice != 0) {
      final price = getFuelPriceString(siteLocation.dieselPrice!);
      return '\$$price';
    } else {
      return '';
    }
  }

  static String getFuelPriceString(double price) =>
      price.truncateDecimalsToString(2);

  static String getPinDropBrandLogoIdentifier(SiteLocation siteLocation) {
    final String brandLogoIdentifierData =
        siteLocation.fuelBrand?.toLowerCase() ?? '';
    return removeQuoteChars(brandLogoIdentifierData);
  }

  static String removeQuoteChars(String dataString) {
    return dataString.replaceAll("'", '');
  }

  static String formatFuelBrandKeyIdentifier(SiteLocation siteLocation) =>
      getPinDropBrandLogoIdentifier(siteLocation);

  static bool isGasNetFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.gasNet ?? 0) > 0;

  static bool isDieselNetFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.dieselNet ?? 0) > 0;

  // static double _getDieselNetPriceNumeric(SiteLocation siteLocation) {
  //   if (isDieselNetFieldAvailable(siteLocation)) {
  //     return siteLocation.dieselNet?.truncateToDecimalPlaces(2) ?? 0;
  //   }
  //   return 0;
  // }

  // static double _getGasNetPriceNumeric(SiteLocation siteLocation) {
  //   if (isGasNetFieldAvailable(siteLocation)) {
  //     return siteLocation.gasNet?.truncateToDecimalPlaces(2) ?? 0;
  //   }
  //   return 0;
  // }

  // static bool _canDisplayDieselRetailPrice(SiteLocation siteLocation) {
  //   return isDieselRetailFieldAvailable(siteLocation);
  // }

  // static bool _canDisplayGasRetailPrice(SiteLocation siteLocation) {
  //   return isGasRetailFieldAvailable(siteLocation);
  // }

  static bool isDieselRetailFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.dieselRetail ?? 0) > 0;

  static bool isGasRetailFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.gasRetail ?? 0) > 0;

  // Moved those Diesel Price Utils methods to Usecases files
  // Reusable widgets methods
  static Widget displayRawImageWidget(ui.Image? rawImage) {
    return rawImage != null
        ? RawImage(
            image: rawImage,
            width: SLAssets.logoSize,
            height: SLAssets.logoSize,
          )
        : const SizedBox.shrink();
  }

  static Widget computeDisplayLogoWidget(SiteLocation siteLocation) {
    final brandLogoIdentifier = getPinDropBrandLogoIdentifier(siteLocation);
    final rawImage = CustomPin.brandLogosImageCacheStore[brandLogoIdentifier];
    return displayRawImageWidget(rawImage);
  }

  static Widget getDisplayBrandLogo(SiteLocation siteLocation,
          {bool hasToSwitchMCSites = false}) =>
      hasToSwitchMCSites
          ? const SizedBox.shrink()
          : isFuelBrandFieldAvailable(siteLocation)
              ? computeDisplayLogoWidget(siteLocation)
              : const SizedBox.shrink();

  static Widget getPhoneWidget(SiteLocation siteLocation) => Semantics(
        container: true,
        label: SLSemanticStrings.siteInfoPhoneNumber,
        child: SiteInfoDetail(
          iconData: Icons.phone_outlined,
          description: formatPhone(siteLocation.locationPhone ?? ''),
        ),
      );

  static Widget getServiceWidget(SiteLocation siteLocation) =>
      siteLocation.locationType?.maintenanceService == Status.Y
          ? Semantics(
              container: true,
              label: SLSemanticStrings.siteInfoService,
              child: const SiteInfoDetail(
                iconData: Icons.build_outlined,
                description: SLViewText.service,
              ),
            )
          : const SizedBox();

  static Widget getTimeWidget(SiteLocation siteLocation) =>
      _canShowTimeWidget(siteLocation)
          ? Semantics(
              container: true,
              label: SLSemanticStrings.siteInfoTime,
              child: SiteInfoDetail(
                iconData: Icons.access_time_outlined,
                description: siteLocation.hoursOfOperation!,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            )
          : const SizedBox();

  static bool _canShowTimeWidget(SiteLocation siteLocation) =>
      siteLocation.hoursOfOperation != null &&
      siteLocation.hoursOfOperation != 'null' &&
      siteLocation.hoursOfOperation!.isNotEmpty;

  static bool canShowPhoneNumber(SiteLocation siteLocation) =>
      siteLocation.locationPhone.isNotNullEmptyOrWhitespace &&
      _phoneHasAllZeros(siteLocation.locationPhone!);

  static bool _phoneHasAllZeros(String phone) {
    return phone.replaceAll(RegExp(r'[-()\s]'), '') !=
        SLInternalText.phoneNumberWithZeros;
  }

  static bool canShowServiceHours(SiteLocation siteLocation) =>
      siteLocation.hoursOfOperation != null ||
      (siteLocation.hoursOfOperation?.isNotEmpty ?? false);

  static Widget divider() => Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: DrivenDivider(height: 5, color: Colors.grey[300]),
      );
  static Widget slCardDivider() => const Padding(
        padding: EdgeInsets.only(top: 8),
        child: DrivenDivider(
          height: 1,
          thickness: 0.75,
        ),
      );

  static int getSitesLoadingPeriodicInterval(int sitesCount) {
    final timeInterval = sitesCount < 100
        ? 300
        : sitesCount < 200
            ? 450
            : sitesCount < 300
                ? 700
                : 1000;
    return sitesCount == 0 ? 0 : timeInterval;
  }

  static EdgeInsets paddingForFuelPriceTopBanner({required bool isInfoView}) =>
      EdgeInsets.only(
        top: isInfoView ? 12 : 0,
        bottom: isInfoView ? 0 : 12,
      );

  static String milesDescription(String milesData,
      {bool isLocationEnabled = false}) {
    return isLocationEnabled
        ? formatMiles(milesData)
        : SLViewText.shareYourLocation;
  }

  static String formatMiles(String milesData,
      {String defaultValue = SLViewText.unavailable}) {
    return (milesData.isNotEmpty &&
            double.parse(milesData.replaceFirst(' mi', '')) > 0.0)
        ? _formatMiles(milesData, defaultValue)
        : defaultValue;
  }

  static String _formatMiles(String milesData, String defaultValue) {
    final milesDataStr = milesData.replaceAll(' mi', '');
    final miles = double.tryParse(milesDataStr) ?? 0.0;
    if (miles == 0) {
      return defaultValue;
    } else if (miles < 2) {
      return '${miles.toStringAsFixed(1)} mi';
    } else {
      return '${miles.round()} mi';
    }
  }

  static TextStyle milesDescriptionTextStyle(String milesData,
      {bool isLocationEnabled = false}) {
    return isLocationEnabled
        ? f14RegularBlack
        : f14SemiBoldLink.copyWith(color: Colors.black);
  }

  static void showLocationEnableDialog({bool isLocationEnabled = false}) {
    if (!isLocationEnabled) {
      MapUtilities.showLocationEnableDialog();
    }
  }
}
