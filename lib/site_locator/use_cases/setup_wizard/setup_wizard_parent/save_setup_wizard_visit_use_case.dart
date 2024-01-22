import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_storage_keys.dart';

class SaveSetUpWizardVisitStatusUseCase extends BaseNoParamUseCase<void> {
  @override
  void execute() =>
      PreferenceUtils.setBool(SiteLocatorStorageKeys.firstVisitToSiteLocator,
          value: false);
}
