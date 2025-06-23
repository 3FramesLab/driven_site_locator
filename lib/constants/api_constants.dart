class ApiConstants {
  // // Distance Matrix
  // static const distanceMatrixGoogleUrl =
  //     'https://maps.googleapis.com/maps/api/distancematrix/json?mode=driving&units=imperial';

  // // Welcome screen
  // static const fuelmanLegalUrl =
  //     'https://resourcecenter.comdata.com/driven-mobile-app/fmn-menu/';

  // TODO(Smeet): important pass value from super-app
  static String baseUrl = ''; // SL
  static String mwBaseUrl = '';
  static String packageId = '';
  static String androidSignature = '';
  static String basicAuthSecret = '';
  static String googleAPIKey = '';
  static String clientId = '';
  static String clientSecret = '';

  static const radiusForFetchingPlaces = 5000; //in meters

  static final jwtAccessTokenJson = {
    'client_id': clientId,
    'client_secret': clientSecret,
    'grant_type': 'client_credentials'
  };

  //api header constants
  static const deviceId = 'deviceid';
  static const authorization = 'authorization';
  static const versionName = 'versionname';
  static const versionCode = 'Versioncode';
  static const versionNumber = 'versionnumber';
  static const flavor = 'flavor';
  static const applicationName = 'applicationname';
  static const userName = 'username';
  static const role = 'role';
  static const roleId = 'roleid';
  static const userId = 'userid';
  static const dfcToken = 'dfcToken';
  static const sysAccId = 'sysaccountid';
  static const mobileDeviceToken = 'mobileDeviceToken';

  static const accessTokenPath = '/token';

  static const googlePlacesSearchUrl =
      'https://places.googleapis.com/v1/places:searchText';
  static const googlePlaceDetailsUrl =
      'https://places.googleapis.com/v1/places';
  static const distanceMatrixGoogleUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?mode=driving&units=imperial';
  static final googleGeoCodingUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?key=$googleAPIKey';
}
