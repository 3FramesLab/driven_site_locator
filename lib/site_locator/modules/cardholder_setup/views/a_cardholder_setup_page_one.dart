part of cardholder_setup_module;

class CardholderSetupPageOne extends StatelessWidget {
  const CardholderSetupPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return CardholderSetupPageTemplate(
      currentPageIndex: 1,
      pageTitle: CardholderSetupConstants.personalizeYourApp,
      onNextPressed: SiteLocatorNavigation.instance.cardholderSetupPageTwo,
      child: _bodyContent,
    );
  }

  Widget get _bodyContent => Column(
        children: const [
          FilterDescriptionText(),
          LocationTypePreferences(),
          LocationBrandsPreferences(),
          LocationFeaturesPreferences(),
          AddOrRemoveFilterText(),
        ],
      );
}
