import 'package:driven_site_locator/config/web_globals.dart';

class SiteLocatorAssets {
  static const packagePath = 'packages/driven_site_locator';
  static const interimAssetPath = '$packagePath/assets/site_locator';
  static final assetPath =
      WebGlobals.kIsWeb ? '$interimAssetPath/web' : interimAssetPath;

// assets/packages/driven_site_locator/assets/site_locator/loginIcon
  // static const assetJsonPath = 'assets/site_locator';

  static final fuelmanBrandFilePath = '$assetPath/site-fuelman-logo.png';
  static final pinBgFilePath = '$assetPath/white-pin-drop.png';
  static final pinBgDiscountFilePath = '$assetPath/yellow-pin-drop.png';

  static final selectedPinBgFilePath = '$assetPath/white-pin-drop-selected.png';
  static final selectedPinBgDiscountFilePath =
      '$assetPath/yellow-pin-drop-selected.png';

  static final normalPriceBannerPinFilePath = '$assetPath/regular-marker.png';
  static final discountPriceBannerPinFilePath =
      '$assetPath/discount-marker.png';
  static final fuelManBrandLogo = '$assetPath/site-fuelman-logo.png';
  static final selectedFuelManBrandLogo =
      '$assetPath/site-fuelman-logo-big.png';
  static const double logoSize = 40;
  static final discountPriceBannerMapPinFilePath =
      '$assetPath/discount_marker.png';
  static final networkFeePriceBannerMapPinFilePath =
      '$assetPath/network_fee_marker.png';
  static final clusterMapPinFilePath = '$assetPath/cluster_marker.png';

  static final iFleetBrandFilePath = '$assetPath/site-ifleet-logo.png';
  static const radioButtonOff = '$packagePath/assets/images/radioButtonOff.png';
  static const radioButtonOn =
      '$packagePath/assets/images/radioButtonSelected.png';
  static const radioButtonDisabled =
      '$packagePath/assets/images/radioButtonDisabled.png';
  static final backupBrandLogoUrlsPath = '$assetPath/brand_logo_urls.json';
  static final fuelPriceDisclaimerInfoIcon =
      '$assetPath/fuel_price_disclaimer_info_icon.png';
  static final loginIcon = '$assetPath/loginIcon.png';
  static final logoutIcon = '$assetPath/logoutIcon.png';
  static final preferencesFilterIcon = '$assetPath/preferencesFilterIcon.png';
  static final icUps = '$assetPath/ic_ups.png';
  static final icFedex = '$assetPath/ic_fedex.png';
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
  static final icClusterMarker = '$assetPath/ic_cluster_marker.png';

  // Card holder setup page
  static final cardHolderSetupPageStepThree =
      '$assetPath/cardholder_setup_page_step_three.png';

  // Top header route icon
  static final routeIcon = '$assetPath/route_icon.png';

  // Zoom In/Out icon
  static const zoomInIcon = '$interimAssetPath/zoom_in_icon.png';
  static const zoomOutIcon = '$interimAssetPath/zoom_out_icon.png';

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
