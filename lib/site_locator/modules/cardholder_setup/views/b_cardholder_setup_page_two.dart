part of cardholder_setup_module;

class CardholderSetupPageTwo extends StatelessWidget {
  const CardholderSetupPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return CardholderSetupPageTemplate(
      currentPageIndex: 2,
      pageTitle: CardholderSetupConstants.weMadeItEasy,
      onNextPressed: SiteLocatorNavigation.instance.cardholderSetupPageThree,
      child: FeatureInfoWizardCardholder(),
    );
  }
}
