part of cardholder_setup_module;

class CardholderSetupPageThree extends StatelessWidget {
  final CardholderSetupController _cardholderSetupController = Get.find();

  CardholderSetupPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return CardholderSetupPageTemplate(
      currentPageIndex: 3,
      pageTitle: CardholderSetupConstants.letTheMapDoTheWork,
      onNextPressed: _cardholderSetupController.onCloseClick,
      child: Image.asset(
        SiteLocatorAssets.cardHolderSetupPageStepThree,
        scale: 1,
      ),
    );
  }
}
