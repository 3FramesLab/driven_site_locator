import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class SiteLocatorApiConstants {
  //site-locator url's
  static final siteLocatorAccessTokenBaseUrl =
      dotenv.env['SITE_LOCATOR_ACCESS_TOKEN_URL']!;
  static final siteLocationBaseUrl = dotenv.env['SITE_LOCATION_BASE_URL']!;
  static final fuelPricesBaseUrl = dotenv.env['FUEL_PRICES_BASE_URL']!;

  static final siteLocatorAccessTokenJson = {
    'client_id': dotenv.env['SITE_LOCATOR_CLIENT_ID'],
    'client_secret': dotenv.env['SITE_LOCATOR_CLIENT_SECRET'],
    'grant_type': 'client_credentials'
  };
  static final googleAPIKey =
      dotenv.env[Platform.isIOS ? 'GOOGLE_IOS_KEY' : 'GOOGLE_ANDROID_KEY'];
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
}
