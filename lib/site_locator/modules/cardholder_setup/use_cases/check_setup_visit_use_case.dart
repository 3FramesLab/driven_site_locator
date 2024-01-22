part of cardholder_setup_module;

class CheckSetupVisitUseCase extends BaseNoParamUseCase<bool> {
  @override
  bool execute() {
    if (AppUtils.isComdata) {
      return Globals()
              .sharedPreferences
              .getBool(SiteLocatorStorageKeys.firstVisitToSiteLocator) ??
          true;
    } else {
      return false;
    }
  }
}
