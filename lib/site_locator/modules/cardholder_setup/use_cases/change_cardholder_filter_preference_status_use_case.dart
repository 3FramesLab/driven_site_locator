part of cardholder_setup_module;

class ChangeCardholderFilterPreferenceStatusUseCase extends BaseUseCase<
    List<String>, ChangeCardholderFilterPreferenceStatusParam> {
  @override
  List<String> execute(ChangeCardholderFilterPreferenceStatusParam param) {
    final siteFilter = param.siteFilter;
    final selectedPreferences = param.selectedPreferences;

    if (selectedPreferences.contains(siteFilter.key)) {
      selectedPreferences.remove(siteFilter.key);
    } else {
      _evaluateLocationTypeSingleSelection(siteFilter, selectedPreferences);

      selectedPreferences.add(siteFilter.key);
    }

    return List<String>.from(selectedPreferences);
  }

  // apply radio button logic for filter location-type
  void _evaluateLocationTypeSingleSelection(
    SiteFilter siteFilter,
    List<String> selectedPreferences,
  ) {
    if (siteFilter.serviceType == ServiceTypeEnum.locationType) {
      final locationTypeFilterKeys = SiteFilters
          .cardholderLocationTypePreferences
          .map((filter) => filter.key)
          .toList();
      selectedPreferences.removeWhere(locationTypeFilterKeys.contains);
    }
  }
}

class ChangeCardholderFilterPreferenceStatusParam {
  final SiteFilter siteFilter;
  final List<String> selectedPreferences;

  ChangeCardholderFilterPreferenceStatusParam({
    required this.siteFilter,
    required this.selectedPreferences,
  });
}
