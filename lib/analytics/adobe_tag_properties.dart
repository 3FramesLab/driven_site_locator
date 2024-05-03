class AdobeTagMappings {
  static const String fleetAdmin = 'FLEET_ADMIN';
  static const String enhancedFilters = 'ENHANCED_FILTERS';
  static const String listView = 'LIST_VIEW';
  static const String login = 'LOGIN';
  static const String mapView = 'MAP_VIEW';
  static const String mfa = 'MFA';
  static const String modals = 'MODALS';
  static const String siteInfo = 'SITE_INFO';
  static const String slMenu = 'SL_MENU';
  static const String welcome = 'WELCOME';
}

enum AdobeTagProperties {
  fleetAdmin(AdobeTagMappings.fleetAdmin),
  enhancedFilters(AdobeTagMappings.enhancedFilters),
  listView(AdobeTagMappings.listView),
  login(AdobeTagMappings.login),
  mapView(AdobeTagMappings.mapView),
  mfa(AdobeTagMappings.mfa),
  modals(AdobeTagMappings.modals),
  siteInfo(AdobeTagMappings.siteInfo),
  slMenu(AdobeTagMappings.slMenu),
  welcome(AdobeTagMappings.welcome);

  final String value;
  const AdobeTagProperties(this.value);
}
