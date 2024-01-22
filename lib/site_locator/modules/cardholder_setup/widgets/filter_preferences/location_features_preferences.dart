part of cardholder_setup_module;

class LocationFeaturesPreferences extends StatelessWidget {
  const LocationFeaturesPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText,
        Column(
          children: [
            ...SiteFilters.cardholderFeaturesPreferences
                .map(
                  (filter) => CardholderPreferenceCheckbox(
                    filter: filter,
                  ),
                )
                .toList()
          ],
        ),
      ],
    );
  }

  Widget get _titleText => const Padding(
        padding: EdgeInsets.only(top: 24),
        child: Text(
          CardholderSetupConstants.truckingNeeds,
          style: f16ExtraBoldBlackDark,
        ),
      );
}
