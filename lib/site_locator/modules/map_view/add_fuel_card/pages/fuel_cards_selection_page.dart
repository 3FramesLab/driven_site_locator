part of map_view_module;

class FuelCardsSelectionPage extends StatelessWidget {
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
      body: Column(
        children: [
          UnderlinedButton.black(
            onPressed: SiteLocatorNavigation.instance.addUnAuthorizeCard,
            text: ViewText.addNewCard,
          ),
          const Center(
            child: ViewLargeTitle(
              title: ViewText.chooseACard,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
