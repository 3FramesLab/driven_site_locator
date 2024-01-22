import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_storage_keys.dart';

class CheckFuelPriceDisclaimerStatusUseCase extends BaseNoParamUseCase<bool> {
  @override
  bool execute() =>
      PreferenceUtils.getBool(SiteLocatorStorageKeys.showFuelPriceDisclaimer,
          defaultValue: AppUtils.isFuelman || AppUtils.isIFleet) ??
      true;
}
