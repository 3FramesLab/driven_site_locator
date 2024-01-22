import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';

class ChangeFilterPreferencesStatusUseCase extends BaseUseCase<List<String>,
    ChangeFilterPreferenceStatusUseCaseParam> {
  @override
  List<String> execute(ChangeFilterPreferenceStatusUseCaseParam param) {
    final siteFilter = param.siteFilter;
    final isChecked = param.isChecked;
    final selectedPreferences = param.selectedPreferences;
    if (isChecked) {
      if (!selectedPreferences.contains(siteFilter.key)) {
        selectedPreferences.add(siteFilter.key);
      }
    } else {
      if (selectedPreferences.contains(siteFilter.key)) {
        selectedPreferences.remove(siteFilter.key);
      }
    }

    return List<String>.from(selectedPreferences);
  }
}

class ChangeFilterPreferenceStatusUseCaseParam {
  final SiteFilter siteFilter;
  final bool isChecked;
  final List<String> selectedPreferences;

  ChangeFilterPreferenceStatusUseCaseParam({
    required this.siteFilter,
    required this.selectedPreferences,
    required this.isChecked,
  });
}
