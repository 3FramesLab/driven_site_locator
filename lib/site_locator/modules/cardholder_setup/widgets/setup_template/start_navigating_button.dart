part of cardholder_setup_module;

class StartNavigatingButton extends StatelessWidget {
  final CardholderSetupController _cardholderSetupController = Get.find();

  StartNavigatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: _cardholderSetupController.onCompleteSetup,
      text: CardholderSetupConstants.startNavigating,
    );
  }
}
