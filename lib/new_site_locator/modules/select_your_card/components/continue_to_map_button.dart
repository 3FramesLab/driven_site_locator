part of select_your_card_module;

class ContinueToMapButton extends StatelessWidget {
  final SelectYourCardController selectYourCardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isSelected = selectYourCardController.isAnyCardSelected();
        return PrimaryButton(
          onPressed:
              isSelected ? selectYourCardController.onContinueToMapClick : null,
          text: SLViewText.continueToMap,
          backgroundColor: isSelected
              ? DrivenColors.primaryButtonColor
              : const Color(0xFFE0E0E0),
          foregroundColor: isSelected
              ? DrivenColors.primaryButtonTextColor
              : const Color(0xff9E9E9E),
        );
      },
    );
  }
}
