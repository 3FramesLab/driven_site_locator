part of cardholder_setup_module;

class LocationBrandsPreferences extends StatelessWidget {
  const LocationBrandsPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText,
        Column(
          children: [
            ...SiteFilters.cardholderLocationBrandsPreferences
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
          CardholderSetupConstants.locationBrandsTitle,
          style: f16ExtraBoldBlackDark,
        ),
      );
}
