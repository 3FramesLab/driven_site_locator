class SiteLocatorTrackActionName {
  // Site Locator: Mapview
  static const executeSearchEvent = 'map view screen : Execute Search';
  static const recenterButtonClickedEvent =
      'map view screen : recenter button click';
  static const locationPinClickedEvent = 'map view screen : location pin click';
  static const mapZoomInEvent = 'map view screen : zoom in';
  static const mapZoomOutEvent = 'map view screen : zoom out';
  static const repositionEvent = 'map view screen : reposition';
  static const cardholderNavSiteLocator = 'cardholder nav : site locator';
  static const walletSiteLocatorClick = 'wallet : site locator map';

  // Site Locator: Filters
  static const filtersButtonClickedEvent =
      'map view screen : filters button click';
  static const listviewButtonsClickedEvent =
      'map view screen : listview button click';

  // Site Locator: Location api
  static const locationSummaryApiSuccessEvent =
      'api : location summary : success';
  static const locationSummaryApiFailEvent = 'api : location summary : failure';

  // Site locator: No location modal
  static const noLocationModalExpandSearchEvent =
      'no location modal : expand search by 5 miles button click';
  static const noLocationModalClearNewFilterLinkClickEvent =
      'no location modal : clear new filter link click';
  static const noLocationModalCancelLinkClickEvent =
      'no location modal : cancel link click';

  // Site locator: Site Info Drawer
  static const siteInfoDrawerFeesMayApplyLinkClickEvent =
      'site info drawer : fees may apply link click';
  static const siteInfoDrawerViewAllDiscountsLinkClickEvent =
      'site info drawer : view all discounts link click';
  static const siteInfoDrawerAddToFavoritesLinkClickEvent =
      'site info drawer : add to favorites link click';
  static const siteInfoDrawerRemoveFromFavoritesLinkClickEvent =
      'site info drawer : remove from favorites link click';
  static const siteInfoDrawerDirectionsButtonLinkClickEvent =
      'site info drawer : directions button link click';
  static const siteInfoDrawerCallButtonLinkClickEvent =
      'site info drawer : call button link click';
  static const siteInfoDrawerSlideToFullScreenEvent =
      'site info drawer : slide to full screen click';

  // Site locator: List View Screen
  static const listViewScreenExecuteSearchEvent =
      'list view screen : list view screen execute search';
  static const listViewFiltersButtonClickEvent =
      'list view screen : filters button click';
  static const listViewViewMoreSitesLinkClickEvent =
      'list view screen : view more sites link click';
  static const listViewDirectionsLinkClickEvent =
      'list view screen : directions link click';
  static const listViewDetailsLinkClickEvent =
      'list view screen : details link click';
  static const listViewAddToFavoritesLinkClickEvent =
      'list view screen : add to favorites link click';
  static const listViewRemoveFromFavoritesLinkClickEvent =
      'list view screen : remove from favorites link click';

  // Site locator: Enhanced Filters Screen
  static const enhancedFiltersApplyFiltersButtonClickEvent =
      'enhanced filters screen : apply filters button click';
  static const enhancedFiltersClearFiltersLinkClickEvent =
      'enhanced filters screen : clear filters link click';
  static const enhancedFiltersBackLinkClickEvent =
      'enhanced filters screen : back link click';

  // Site locator: Menu Drawer
  static const menuDrawerVisitEvent = 'menu drawer : menu drawer visit';
  static const menuDrawerLoginLinkClickEvent = 'menu drawer : login link click';
  static const menuDrawerLogoutLinkClickEvent =
      'menu drawer : logout link click';
  static const menuDrawerPreferencesFiltersLinkClickEvent =
      'menu drawer : preferences & filters link click';
  static const menuDrawerHelpCenterLinkClickEvent =
      'menu drawer : help center link click';
  static const menuDrawerLegalPrivacyLinkClickEvent =
      'menu drawer : legal/privacy link click';

  // welcome screen
  static const mapClick = 'welcome : map';

  // Preferred Home Screen Modal
  static const preferredHomeScreenYesButtonEvent =
      'preferred home screen modal : yes';
  static const preferredHomeScreenNoButtonEvent =
      'preferred home screen modal : no thanks';
}
