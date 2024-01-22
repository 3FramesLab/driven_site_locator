class SiteLocatorConfigData {
  static Map<String, Map<String, dynamic>> store = {
    'isDisplayEnabled': {
      'fuelman': true,
      'comdata': false,
      'ifleet': false,
    },
    'defaultMapRadius': {
      'fuelman': 2.0,
      'comdata': 50.0,
      'ifleet': 5.0,
    },
    'defaultBrandLogo': {
      'fuelman': 'site-fuelman-logo.png',
      'comdata': 'site-comdata-logo.png',
      'ifleet': 'site-ifleet-logo.png',
    },
    'defaultFuelType': {
      'fuelman': 'Unleaded',
      'comdata': 'Diesel',
      'ifleet': 'Unleaded',
    },
    'summaryAPIQueryParam': {
      'fuelman': 'fuelman=y',
      'comdata': 'comdata=y',
      'ifleet': 'fuelman=y&mastercard=y',
    },
    'isDiscountFeatureEnabled': {
      'fuelman': true,
      'comdata': false,
      'ifleet': true,
    },
    'discountIndicator': {
      'fuelman': 'fmDiscountNetwork',
      'comdata': 'N/A',
      'ifleet': 'fmDiscountNetwork, mcDiscountNetwork',
    },
    'isFeeDisclaimerEnabled': {
      'fuelman': true,
      'comdata': false,
      'ifleet': true,
    },
    'quickFilterOptions': {
      'fuelman': ['fuel', 'service', 'discounts', 'favorites'],
      'comdata': ['fuel', 'service', 'gallon_up ', 'favorites'],
      'ifleet': ['fuel', 'service', 'discounts', 'favorites'],
    },
    'fuelBrandsTopShortList': {
      'fuelman': ['exxon', 'shell', 'bp', 'ta', 'circle k'],
      'comdata': ['shell', 'bp', 'ta', 'circle k', 'exxon'],
      'ifleet': ['ta', 'circle k', 'exxon', 'shell', 'bp'],
    },
  };
}
