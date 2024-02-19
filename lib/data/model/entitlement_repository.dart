class SiteLocatorEntitlementRepository {
  // SiteLocator Entitlement
  final bool isAmenitiesFilterEnabled;
  final bool isDiscountsQuickFilterEnabled;
  final bool isDisplaySettingsEnabled;
  final bool isFavoriteQuickFilterEnabled;
  final bool isSiteLocatorFeatureEnabled;
  final bool isFuelBrandsFilterEnabled;
  final bool isFuelQuickFilterEnabled;
  final bool isFuelsFilterEnabled;
  final bool isLegalPrivacySettingEnabled;
  final bool isLocationFeatureFilterEnabled;
  final bool isLocationTypeFilterEnabled;
  final bool isLoginLogoutSettingsEnabled;
  final bool isPreferenceFilterEnabled;
  final bool isServiceQuickFilterEnabled;
  final bool isGallonUpQuickFilterEnabled;
  final bool isDiscountFeatureEnabled;
  final bool isFeeDisclaimerEnabled;
  final bool isClusterFeatureEnabled;
  final bool isEnhancedFilterEnabled;

  // Account Entitlement
  final bool isHelpCenterEnabled;

  const SiteLocatorEntitlementRepository({
    required this.isAmenitiesFilterEnabled,
    required this.isDiscountsQuickFilterEnabled,
    required this.isDisplaySettingsEnabled,
    required this.isFavoriteQuickFilterEnabled,
    required this.isSiteLocatorFeatureEnabled,
    required this.isFuelBrandsFilterEnabled,
    required this.isFuelQuickFilterEnabled,
    required this.isFuelsFilterEnabled,
    required this.isLegalPrivacySettingEnabled,
    required this.isLocationFeatureFilterEnabled,
    required this.isLocationTypeFilterEnabled,
    required this.isLoginLogoutSettingsEnabled,
    required this.isPreferenceFilterEnabled,
    required this.isServiceQuickFilterEnabled,
    required this.isGallonUpQuickFilterEnabled,
    required this.isDiscountFeatureEnabled,
    required this.isFeeDisclaimerEnabled,
    required this.isClusterFeatureEnabled,
    required this.isHelpCenterEnabled,
    required this.isEnhancedFilterEnabled,
  });
}

class SiteLocatorEntitlementUtils {
  SiteLocatorEntitlementUtils._internal();
  static final SiteLocatorEntitlementUtils _instance =
      SiteLocatorEntitlementUtils._internal();
  static SiteLocatorEntitlementUtils get instance => _instance;

  SiteLocatorEntitlementRepository? siteLocatorEntitlementRepository;

  bool get isAmenitiesFilterEnabled =>
      siteLocatorEntitlementRepository?.isAmenitiesFilterEnabled ?? false;
  bool get isDiscountsQuickFilterEnabled =>
      siteLocatorEntitlementRepository?.isDiscountsQuickFilterEnabled ?? false;
  bool get isDisplaySettingsEnabled =>
      siteLocatorEntitlementRepository?.isDisplaySettingsEnabled ?? false;
  bool get isFavoriteQuickFilterEnabled =>
      siteLocatorEntitlementRepository?.isFavoriteQuickFilterEnabled ?? false;
  bool get isSiteLocatorFeatureEnabled =>
      siteLocatorEntitlementRepository?.isSiteLocatorFeatureEnabled ?? false;
  bool get isFuelBrandsFilterEnabled =>
      siteLocatorEntitlementRepository?.isFuelBrandsFilterEnabled ?? false;
  bool get isFuelQuickFilterEnabled =>
      siteLocatorEntitlementRepository?.isFuelQuickFilterEnabled ?? false;
  bool get isFuelsFilterEnabled =>
      siteLocatorEntitlementRepository?.isFuelsFilterEnabled ?? false;
  bool get isLegalPrivacySettingEnabled =>
      siteLocatorEntitlementRepository?.isLegalPrivacySettingEnabled ?? false;
  bool get isLocationFeatureFilterEnabled =>
      siteLocatorEntitlementRepository?.isLocationFeatureFilterEnabled ?? false;
  bool get isLocationTypeFilterEnabled =>
      siteLocatorEntitlementRepository?.isLocationTypeFilterEnabled ?? false;
  bool get isLoginLogoutSettingsEnabled =>
      siteLocatorEntitlementRepository?.isLoginLogoutSettingsEnabled ?? false;
  bool get isPreferenceFilterEnabled =>
      siteLocatorEntitlementRepository?.isPreferenceFilterEnabled ?? false;
  bool get isServiceQuickFilterEnabled =>
      siteLocatorEntitlementRepository?.isServiceQuickFilterEnabled ?? false;
  bool get isGallonUpQuickFilterEnabled =>
      siteLocatorEntitlementRepository?.isGallonUpQuickFilterEnabled ?? false;
  bool get isDiscountFeatureEnabled =>
      siteLocatorEntitlementRepository?.isDiscountFeatureEnabled ?? false;
  bool get isFeeDisclaimerEnabled =>
      siteLocatorEntitlementRepository?.isFeeDisclaimerEnabled ?? false;
  bool get isClusterFeatureEnabled =>
      siteLocatorEntitlementRepository?.isClusterFeatureEnabled ?? false;
  bool get isHelpCenterEnabled =>
      siteLocatorEntitlementRepository?.isHelpCenterEnabled ?? false;
  bool get isEnhancedFilterEnabled =>
      siteLocatorEntitlementRepository?.isEnhancedFilterEnabled ?? false;
}
