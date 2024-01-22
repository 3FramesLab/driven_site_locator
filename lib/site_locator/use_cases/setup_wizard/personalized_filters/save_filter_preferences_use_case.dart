import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_storage_keys.dart';

class SaveFilterPreferencesUseCase
    extends BaseFutureUseCase<void, List<String>> {
  @override
  Future<void>? execute(List<String> param) async {
    await PreferenceUtils.setStringList(
      SiteLocatorStorageKeys.selectedSiteFilters,
      value: param,
    );
  }
}
