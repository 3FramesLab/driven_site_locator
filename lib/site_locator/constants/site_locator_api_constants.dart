import 'dart:io';

import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SiteLocatorApiConstants {
  //site-locator url's
  static final siteLocatorAccessTokenBaseUrl =
      DrivenSiteLocator.instance.env[EnvKeys.siteLocatorAccessTokenUrl]!;
  static final siteLocationBaseUrl =
      DrivenSiteLocator.instance.env[EnvKeys.siteLocationBaseUrl]!;
  static final fuelPricesBaseUrl =
      DrivenSiteLocator.instance.env[EnvKeys.fuelPricesBaseUrl]!;
  static final fuelmanWebUrl =
      DrivenSiteLocator.instance.env[EnvKeys.fuelmanWebURL]!;

  static final siteLocatorAccessTokenJson = {
    'client_id': DrivenSiteLocator.instance.env[EnvKeys.siteLocatorClientId],
    'client_secret':
        DrivenSiteLocator.instance.env[EnvKeys.siteLocatorClientSecret],
    'grant_type': 'client_credentials'
  };
  static final googleAPIKey = DrivenSiteLocator.instance.env[Platform.isIOS
      ? EnvKeys.googleIosKey
      : kIsWeb
          ? EnvKeys.googleWebKey
          : EnvKeys.googleAndroidKey];

  static const radiusForFetchingPlaces = 5000; //in meters
  static const componentsForFetchingPlaces =
      'country:us'; //restricting other country data

  // Google places API
  static final googlePlacesAutoCompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$googleAPIKey&components=$componentsForFetchingPlaces&radius=$radiusForFetchingPlaces';

  static final googleGeoCodingUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?key=$googleAPIKey';

  //fuel prices
  static const defaultSysAccountId = '0_0000_3';
  static const defaultFuelPricesApiLimit = 5;

  //mobile app store links
  static const fuelmanAppGoogleStoreLink =
      'https://play.google.com/store/apps/details?id=com.fuelman.driven&hl=en&gl=US&pli=1';
  static const fuelmanAppAppleStoreLink =
      'https://apps.apple.com/us/app/driven-for-fuelman/id6443817640';
}

class EnvKeys {
  static const siteLocatorAccessTokenUrl = 'SITE_LOCATOR_ACCESS_TOKEN_URL';
  static const siteLocationBaseUrl = 'SITE_LOCATION_BASE_URL';
  static const fuelPricesBaseUrl = 'FUEL_PRICES_BASE_URL';
  static const siteLocatorClientId = 'SITE_LOCATOR_CLIENT_ID';
  static const siteLocatorClientSecret = 'SITE_LOCATOR_CLIENT_SECRET';
  static const googleIosKey = 'GOOGLE_IOS_KEY';
  static const googleAndroidKey = 'GOOGLE_ANDROID_KEY';
  static const googleWebKey = 'GOOGLE_WEB_KEY';
  static const fuelmanWebURL = 'FUELMAN_WEB_URL';
}
