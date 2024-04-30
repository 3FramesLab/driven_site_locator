part of map_view_module;

class AddFuelCardPage extends StatelessWidget {
  final FuelCardsController controller = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();
  final AddFuelCardUseCase addFuelCardUseCase = AddFuelCardUseCase();
  final GetFuelCardsUseCase getFuelCardsUseCase = GetFuelCardsUseCase();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearData();
      controller.setUpFavorite();
      controller.isOnBackPress(false);
    });
    return BaseDrivenScaffold(
      disableBack: true,
      goesInactive: siteLocatorController.isUserAuthenticated,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      appBar: DrivenAppBar(
        leading: DrivenBackButton(onPressed: controller.onBackPressed),
      ),
      body: PageContent(
        leading: const [ViewLargeTitle(title: ViewText.addNewCardUnAuthorized)],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(),
              const SizedBox(height: 25),
              AddFuelCardForm(),
              const SizedBox(height: 20),
              FuelCardFavoriteCheckbox(),
              const SizedBox(height: 35),
              _addCardButton()
            ],
          ),
        ),
      ),
    );
  }

  Row _subTitle() {
    return Row(
      children: const [
        SubTitleText(
          title: ViewText.pleaseEnterCardNumberNickname,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _addCardButton() {
    return Obx(
      () => PrimaryButton(
        onPressed: controller.canAddCard
            ? controller.onAddUnAuthorizedCardClicked
            : null,
        text: ViewText.addCard,
      ),
    );
  }
}
