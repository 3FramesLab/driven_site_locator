enum SiteLocatorAnalyticsSiteSection {
  noLocationModel('no location model'),
  siteLocator('site locator');

  const SiteLocatorAnalyticsSiteSection(this.value);

  final String value;
}

enum SiteLocatorAnalyticsScreenName {
  noLocationModalScreen(
      'no location modal', SiteLocatorAnalyticsSiteSection.noLocationModel),
  mapviewScreen('map view', SiteLocatorAnalyticsSiteSection.siteLocator);

  const SiteLocatorAnalyticsScreenName(this._value, this.section);

  final String _value;
  final SiteLocatorAnalyticsSiteSection section;

  String get value => _value;
}
