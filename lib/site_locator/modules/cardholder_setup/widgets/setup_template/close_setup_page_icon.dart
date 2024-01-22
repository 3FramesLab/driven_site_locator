part of cardholder_setup_module;

class CloseSetupPageIcon extends StatelessWidget {
  final CardholderSetupController _cardholderSetupController = Get.find();

  CloseSetupPageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticStrings.closePageIconButton,
      child: GestureDetector(
        onTap: _cardholderSetupController.onCloseClick,
        child: const Icon(
          Icons.close,
          size: 32,
          color: DrivenColors.black,
        ),
      ),
    );
  }
}
