import 'package:driven/site_locator/configuration/site_locator_config.dart';

class MCSitesGovernor {
  // MasterCard - CardType currently it is 'N' from API;
  // configured from remote-config
  static String cardType = SiteLocatorConfig.sitelocatorMasterCardTypeCode;
  static String mcSitesPayloadKey = 'mcLocationIds';
  static bool isMCSitesViewEnabled = false;
  static bool isMcUnleadedSelected = false;
  static String mcLabel = '';
  static bool isUnauthSLFlow = true;

  static bool get isMcUnleadedQuickFilterSelected =>
      isMCSitesViewEnabled && isMcUnleadedSelected;

  static void setMCLabel() {
    mcLabel = isMCSitesViewEnabled ? 'MasterCard ' : '';
  }
}
