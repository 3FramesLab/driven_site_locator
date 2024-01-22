part of cardholder_setup_module;

class CardholderSetupPageTemplate extends StatelessWidget {
  final int totalSteps = 3;
  final SiteLocatorController _siteLocatorController = Get.find();
  final int currentPageIndex;
  final String pageTitle;
  final Widget child;
  final Function()? onNextPressed;

  CardholderSetupPageTemplate({
    required this.currentPageIndex,
    required this.pageTitle,
    required this.child,
    this.onNextPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: BaseDrivenScaffold(
        goesInactive: _siteLocatorController.isUserAuthenticated,
        backgroundColor: DrivenColors.white,
        body: _bodyContent(context),
        isInactivityWrapperActivated:
            DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
        onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      ),
    );
  }

  Widget _bodyContent(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _closePageIcon,
              _stepperIndicator(context),
              _pageTitleText,
              const SizedBox(height: 16),
              _scrollableChild,
              const SizedBox(height: 22),
              _nextOrStartNavigatingButton,
              _closeButton,
            ],
          ),
        ),
      );

  Widget get _closePageIcon => Visibility(
        key: const Key(InternalText.cardholderSetupCloseIconKey),
        visible: !_isLastStep,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Align(
          alignment: Alignment.centerRight,
          child: CloseSetupPageIcon(),
        ),
      );

  Widget _stepperIndicator(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: StepperProgressIndicator(currentStep: currentPageIndex),
      );

  Widget get _pageTitleText => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          pageTitle,
          style: f28ExtraboldBlackDark,
        ),
      );

  Widget get _scrollableChild => Expanded(
        child: SingleChildScrollView(child: child),
      );

  Widget get _nextOrStartNavigatingButton =>
      _isLastStep ? StartNavigatingButton() : _nextButton;

  Widget get _nextButton => NextButton(onNextPressed: onNextPressed);

  Widget get _closeButton => Visibility(
        key: const Key(InternalText.cardholderSetupCloseTextKey),
        visible: !_isLastStep,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CloseSetupPageText(),
        ),
      );

  bool get _isLastStep => currentPageIndex == totalSteps;
}
