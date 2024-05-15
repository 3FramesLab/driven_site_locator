part of map_view_module;

class FuelCardsSelectionPage extends GetView<FuelCardsController> {
  @override
  Widget build(BuildContext context) {
    return BaseDrivenScaffold(
      disableBack: true,
      goesInactive: false,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      appBar: DrivenAppBar(
        leading: const DrivenBackButton(),
      ),
      body: _bodyContainer(child: FuelCardsSelectionForm()),
    );
  }

  Widget _bodyContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _title(),
          const SizedBox(height: 32),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ViewLargeTitle(
          title: ViewText.chooseACard,
          padding: EdgeInsets.zero,
        ),
        _changeCardText(),
      ],
    );
  }

  Widget _changeCardText() => Obx(
        () => GestureDetector(
          onTap: !controller.hasTenCards()
              ? SiteLocatorNavigation.instance.addFuelCard
              : null,
          child: Text(
            ViewText.addNewCard,
            style: controller.hasTenCards()
                ? f16SemiBoldGrey
                : f16SemiboldWBlackUnderline,
          ),
        ),
      );
}
