part of map_view_module;

class ChangeFuelCard extends StatelessWidget {
  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(_changeCardLink);
  }

  Widget _changeCardLink() {
    return Semantics(
      label: SemanticStrings.changeFuelCards,
      container: true,
      child: InkWell(
        onTap: controller.onAddCardClicked,
        child: _changeCardText(),
      ),
    );
  }

  Widget _changeCardText() => Text(
        changeCardText,
        style: f16SemiboldBlackUnderline,
      );

  void navigateFromChangeCardLink() {
    if (controller.hasNoCards()) {
      DrivenSiteLocator.instance.addCardNavigation?.call();
    } else {
      Get.toNamed(SiteLocatorRoutes.fuelCardsSelection);
    }
  }

  String get changeCardText {
    if (controller.hasAtLeastTwoCards()) {
      return ViewText.changeCard;
    } else {
      return ViewText.addCard;
    }
  }
}
