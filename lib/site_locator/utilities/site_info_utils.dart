import 'dart:ui' as ui;

import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/widgets/site_info_detail.dart';

class SiteInfoUtils {
  static BorderRadius infoPanelTopBorder = const BorderRadius.only(
      topLeft: Radius.circular(10), topRight: Radius.circular(10));

  static const cardPadding =
      EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 10);

  static Color getCardBgColor(int index) =>
      index % 2 == 0 ? Colors.white : SiteLocatorColors.grey100;

  static bool isFuelBrandNameAvailable(SiteLocation siteLocation) =>
      isFuelBrandFieldAvailable(siteLocation);

  static bool isFuelBrandFieldAvailable(SiteLocation siteLocation) =>
      siteLocation.fuelBrand != null &&
      ((siteLocation.fuelBrand?.isNotEmpty ?? false) &&
          siteLocation.fuelBrand?.toLowerCase() !=
              SiteLocatorConstants.unbranded.toLowerCase());

  static bool isFuelPriceEmpty(SiteLocation siteLocation) =>
      getFuelPrice(siteLocation).isEmpty;

  static String displayFuelBrandName(SiteLocation siteLocation) =>
      getDisplayFuelBrand(siteLocation);

  static String getDisplayFuelBrand(SiteLocation siteLocation) =>
      isFuelBrandFieldAvailable(siteLocation)
          ? siteLocation.fuelBrand ?? ''
          : siteLocation.locationName ?? '';

  static String getLocationName(SiteLocation siteLocation) =>
      siteLocation.locationName ?? '';

  static String getStreetAddress(SiteLocation siteLocation) =>
      siteLocation.locationStreetAddress ?? '';

  static bool hasDiscountNetwork(SiteLocation siteLocation) =>
      SiteLocatorConfig.hasDiscountNetwork(siteLocation);

  static bool canDisplayDiscount(SiteLocation siteLocation) =>
      SiteLocatorConfig.hasDiscountNetwork(siteLocation) &&
      SiteLocatorConfig.isDiscountFeatureEnabled;

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

  static String getFuelTitle(SiteLocation siteLocation) {
    return SiteLocatorConfig.getFuelTitle(siteLocation);
  }

  static String getFuelPrice(SiteLocation siteLocation) {
    final priceNumeric = SiteLocatorConfig.getFuelPrice(siteLocation);
    final price = getFuelPriceString(priceNumeric);
    return price == '0.00' ? '' : '\$$price';
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

  // Diesel Discount price and Retail price utilities
  static bool canDisplayDieselNetPrice(SiteLocation siteLocation) {
    return isDieselNetFieldAvailable(siteLocation);
  }

  static bool isDieselNetFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.dieselNet ?? 0) > 0;

  static String getDieselNetPrice(SiteLocation siteLocation) {
    final price = getDieselNetPriceNumeric(siteLocation);
    final priceString = getFuelPriceString(price);
    return price > 0 ? '\$$priceString' : '';
  }

  static double getDieselNetPriceNumeric(SiteLocation siteLocation) {
    if (isDieselNetFieldAvailable(siteLocation)) {
      return siteLocation.dieselNet?.truncateToDecimalPlaces(2) ?? 0;
    }
    return 0;
  }

  static bool canDisplayDieselRetailPrice(SiteLocation siteLocation) {
    return isDieselRetailFieldAvailable(siteLocation);
  }

  static bool isDieselRetailFieldAvailable(SiteLocation siteLocation) =>
      (siteLocation.dieselRetail ?? 0) > 0;

  static String getDieselRetailPrice(SiteLocation siteLocation) {
    final price = getDieselRetailPriceNumeric(siteLocation);
    final priceString = getFuelPriceString(price);
    return price > 0 ? '\$$priceString' : '';
  }

  static double getDieselRetailPriceNumeric(SiteLocation siteLocation) {
    if (isDieselRetailFieldAvailable(siteLocation)) {
      return siteLocation.dieselRetail?.truncateToDecimalPlaces(2) ?? 0;
    }
    return 0;
  }

  // Moved those Diesel Price Utils methods to Usecases files
  // Reusable widgets methods

  static Widget defaultBrandLogo() {
    return Image.asset(
      SiteLocatorConfig.defaultBrandLogoPath,
      width: SiteLocatorAssets.logoSize,
      height: SiteLocatorAssets.logoSize,
    );
  }

  static Widget displayRawImageWidget(ui.Image? rawImage) {
    return rawImage != null
        ? RawImage(
            image: rawImage,
            width: SiteLocatorAssets.logoSize,
            height: SiteLocatorAssets.logoSize,
          )
        : const SizedBox.shrink();
  }

  static Widget computeDisplayLogoWidget(SiteLocation siteLocation) {
    final brandLogoIdentifier = getPinDropBrandLogoIdentifier(siteLocation);
    final rawImage = CustomPin.brandLogosImageCacheStore[brandLogoIdentifier];
    return displayRawImageWidget(rawImage);
  }

  static Widget getDisplayBrandLogo(SiteLocation siteLocation) =>
      isFuelBrandFieldAvailable(siteLocation)
          ? computeDisplayLogoWidget(siteLocation)
          : const SizedBox.shrink();

  static Widget getPhoneWidget(SiteLocation siteLocation) => Semantics(
        container: true,
        label: SemanticStrings.siteInfoPhoneNumber,
        child: SiteInfoDetail(
          iconData: Icons.phone_outlined,
          description: formatPhone(siteLocation.locationPhone ?? ''),
        ),
      );

  static Widget getServiceWidget(SiteLocation siteLocation) =>
      siteLocation.locationType?.maintenanceService == Status.Y
          ? Semantics(
              container: true,
              label: SemanticStrings.siteInfoService,
              child: const SiteInfoDetail(
                iconData: Icons.build_outlined,
                description: SiteLocatorConstants.service,
              ),
            )
          : const SizedBox();

  static Widget getTimeWidget(SiteLocation siteLocation) =>
      _canShowTimeWidget(siteLocation)
          ? Semantics(
              container: true,
              label: SemanticStrings.siteInfoTime,
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

  static Widget divider() => Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: DrivenDivider(height: 5, color: Colors.grey[300]),
      );

  static int getFuelGaugePeriodicInterval(int sitesCount) {
    final timeInterval = sitesCount < 100
        ? 300
        : sitesCount < 200
            ? 450
            : sitesCount < 300
                ? 700
                : 1000;
    return sitesCount == 0 ? 0 : timeInterval;
  }
}
