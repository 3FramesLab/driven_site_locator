part of map_view_module;

class EditFuelCardPage extends StatelessWidget {
  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getArguments();
      controller.isOnBackPress(false);
    });
    return BaseDrivenScaffold(
      disableBack: true,
      goesInactive: false,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      appBar: DrivenAppBar(
        leading: DrivenBackButton(onPressed: controller.onBackPressed),
      ),
      body: PageContent(
        leading: const [ViewLargeTitle(title: ViewText.editCard)],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FuelCardNumberTextField(),
              const SizedBox(height: 25),
              const LabelText(ViewText.cardNickname),
              const SizedBox(height: 5),
              FuelCardNickNameField(),
              const SizedBox(height: 20),
              FuelCardFavoriteCheckbox(),
              const SizedBox(height: 35),
              _updateButton(),
              const SizedBox(height: 46),
              Center(child: CancelText(onCancelTap: controller.onBackPressed))
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return Obx(
      () => PrimaryButton(
        onPressed:
            controller.canUpdateCard ? controller.onUpdateButtonClicked : null,
        text: ViewText.updateCard,
      ),
    );
  }

  void _getArguments() {
    if (Get.arguments != null &&
        Get.arguments[SiteLocatorRouteArguments.fuelCard] != null) {
      final fuelCard =
          Get.arguments[SiteLocatorRouteArguments.fuelCard] as FuelCard;
      controller.editableFuelCard(fuelCard);
      controller.isValidNickname(true);
      controller.nickNameEditController.text = fuelCard.cardNickName ?? '';
      controller.isFavoriteCard(fuelCard.isFavoriteCard);
      controller.isAnyDataUpdated.value = false;
      controller.initialFavoriteCardStatus = controller.isFavoriteCard();
      controller.initialNickNameValue = controller.nickNameEditController.text;
    }
  }
}
