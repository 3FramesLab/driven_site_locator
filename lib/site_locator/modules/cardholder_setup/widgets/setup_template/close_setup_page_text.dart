part of cardholder_setup_module;

class CloseSetupPageText extends StatelessWidget {
  final CardholderSetupController _cardholderSetupController = Get.find();

  CloseSetupPageText({super.key});

  @override
  Widget build(BuildContext context) {
    return ClickableText(
      onTap: _cardholderSetupController.onCloseClick,
      title: ViewText.close,
    );
  }
}
