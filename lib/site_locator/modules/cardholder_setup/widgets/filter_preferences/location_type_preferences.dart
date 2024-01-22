part of cardholder_setup_module;

class LocationTypePreferences extends StatelessWidget {
  const LocationTypePreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText,
        Column(
          children: [
            ...SiteFilters.cardholderLocationTypePreferences
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
          CardholderSetupConstants.locationTypeTitle,
          style: f16ExtraBoldBlackDark,
        ),
      );
}
