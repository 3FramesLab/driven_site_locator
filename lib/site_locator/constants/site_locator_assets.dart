import 'package:flutter/foundation.dart';

class SiteLocatorAssets {
  static const packagePath = 'packages/driven_site_locator';
  static const interimAssetPath = '$packagePath/assets/site_locator';
  static const assetPath = kIsWeb ? '$interimAssetPath/web' : interimAssetPath;

// assets/packages/driven_site_locator/assets/site_locator/loginIcon
  // static const assetJsonPath = 'assets/site_locator';

  static const fuelmanBrandFilePath = '$assetPath/site-fuelman-logo.png';
  static const pinBgFilePath = '$assetPath/white-pin-drop.png';
  static const pinBgDiscountFilePath = '$assetPath/yellow-pin-drop.png';

  static const selectedPinBgFilePath = '$assetPath/white-pin-drop-selected.png';
  static const selectedPinBgDiscountFilePath =
      '$assetPath/yellow-pin-drop-selected.png';

  static const normalPriceBannerPinFilePath = '$assetPath/regular-marker.png';
  static const discountPriceBannerPinFilePath =
      '$assetPath/discount-marker.png';
  static const fuelManBrandLogo = '$assetPath/site-fuelman-logo.png';
  static const selectedFuelManBrandLogo =
      '$assetPath/site-fuelman-logo-big.png';
  static const double logoSize = 40;
  static const discountPriceBannerMapPinFilePath =
      '$assetPath/discount_marker.png';
  static const networkFeePriceBannerMapPinFilePath =
      '$assetPath/network_fee_marker.png';
  static const clusterMapPinFilePath = '$assetPath/cluster_marker.png';

  static const iFleetBrandFilePath = '$assetPath/site-ifleet-logo.png';
  static const radioButtonOff = '$packagePath/assets/images/radioButtonOff.png';
  static const radioButtonOn =
      '$packagePath/assets/images/radioButtonSelected.png';
  static const radioButtonDisabled =
      '$packagePath/assets/images/radioButtonDisabled.png';
  static const backupBrandLogoUrlsPath = '$assetPath/brand_logo_urls.json';
  static const fuelPriceDisclaimerInfoIcon =
      '$assetPath/fuel_price_disclaimer_info_icon.png';
  static const loginIcon = '$assetPath/loginIcon.png';
  static const logoutIcon = '$assetPath/logoutIcon.png';
  static const preferencesFilterIcon = '$assetPath/preferencesFilterIcon.png';
  static const icUps = '$assetPath/ic_ups.png';
  static const icFedex = '$assetPath/ic_fedex.png';
  static const gpsIcon = '$packagePath/assets/images/ic_gps.png';

  // COMDATA ASSET PATHS

  static const assetPathComdata = '$packagePath/assets/site_locator/comdata';
  // static const assetJsonPathComdata = 'assets/site_locator/comdata';
  static const comdataSiteBrandLogoDFC =
      '$assetPathComdata/site-comdata-logo.png';
  static const pinBgNormalFilePathDFC = '$assetPathComdata/normal-pin-drop.png';
  static const pinBgGallonUpFilePathDFC =
      '$assetPathComdata/gallonup-pin-drop.png';
  static const normalPriceBannerPinFilePathDFC =
      '$assetPathComdata/normal-marker.png';
  static const gallonUpPriceBannerPinFilePathDFC =
      '$assetPathComdata/gallonup-marker.png';

  // Json Files
  static const comdataSitesResponseJsonPath =
      '$assetPathComdata/sites_response.json';
  static const enhancedFilterConfig =
      'assets/site_locator/config/enhanced_filter_config.json';
  static const enhancedFilterConfigEmptyAminities =
      'assets/site_locator/config/enhanced_filter_config_test.json';

  // Common assets images
  static const exitSign = '$packagePath/assets/images/exit_sign.png';

  // Clusters
  static const icClusterMarker = '$assetPath/ic_cluster_marker.png';

  // Card holder setup page
  static const cardHolderSetupPageStepThree =
      '$assetPath/cardholder_setup_page_step_three.png';

  // Top header route icon
  static const routeIcon = '$assetPath/route_icon.png';


  // Zoom In/Out icon
  static const zoomInIcon = '$assetPath/zoom_in_icon.png';
  static const zoomOutIcon = '$assetPath/zoom_out_icon.png';

  //web app assets
  static const badge = '$interimAssetPath/badge.png';
  static const helpCenter = '$interimAssetPath/help_center.png';
  static const mapPin = '$interimAssetPath/map_pin.png';
  static const mobilePhone = '$interimAssetPath/mobile_phone.png';
  static const privacyPolicy = '$interimAssetPath/privacy_policy.png';
  static const appleStore = '$interimAssetPath/apple.png';
  static const googleStore = '$interimAssetPath/google_play.png';

  static String getAccuratePath(String path) {
    return path;
  }

}
