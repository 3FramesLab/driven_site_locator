part of inactivity_module;

class SLInactivityController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final bool enabled = DrivenSiteLocator.instance.isInactivityWrapperEnabled;

  VoidCallback? sessionExpiryWarningTimerCallback;
  VoidCallback? sessionExpiryTimerCallback;

  Timer? sessionExpiryTimer;
  Timer? sessionExpiryWarningTimer;

  final RxBool applicationActive = true.obs;

  bool isSessionExpired = false;

  void initializeTimers() {
    if (enabled) {
      cancelTimers();
      isSessionExpired = false;
      if (!isExcludedInactivityRoutes()) {
        _initSessionExpiryWarningTimer();
        _initSessionExpiryTimer();
      }
    }
  }

  void _initSessionExpiryWarningTimer() {
    final sessionExpiryWarningTimeInMinutes =
        DrivenSiteLocator.instance.inactivityWarningTimeoutValue;

    if (sessionExpiryWarningTimeInMinutes > 0) {
      sessionExpiryWarningTimer = Timer(
        Duration(minutes: sessionExpiryWarningTimeInMinutes),
        _sessionExpiryWarningTimerCallback,
      );
    }
  }

  void _initSessionExpiryTimer() {
    final sessionExpiryTimeInMinutes =
        DrivenSiteLocator.instance.inactivityLogoutTimeoutValue;
    if (sessionExpiryTimeInMinutes > 0) {
      sessionExpiryTimer = Timer(
        Duration(minutes: sessionExpiryTimeInMinutes),
        _sessionExpiryTimerCallback,
      );
    }
  }

  void _sessionExpiryWarningTimerCallback() {
    if (isExcludedInactivityRoutes()) {
      cancelTimers();
      return;
    }
    if (sessionExpiryWarningTimerCallback != null) {
      sessionExpiryWarningTimerCallback?.call();
    } else {
      _warn();
    }
  }

  void _sessionExpiryTimerCallback() {
    if (isExcludedInactivityRoutes()) {
      cancelTimers();
      return;
    }
    if (sessionExpiryTimerCallback != null) {
      sessionExpiryTimerCallback?.call();
    } else {
      DrivenSiteLocator.instance.onLogout!(expired: true);
    }
  }

  bool isExcludedInactivityRoutes() {
    final excludedRoutes = [
      Routes.notFound,
      Routes.welcome,
      Routes.login,
      Routes.dcLogin,
      Routes.createProfile,
      //amazon
      Routes.routeId,
      Routes.amazonWelcome,
      Routes.amazonWallet,
      Routes.removeAmazonCard,
      SLRoutes.unauthSiteLocator,
    ];
    return excludedRoutes.contains(Get.currentRoute);
  }

  void handleUserInteraction([_]) {
    initializeTimers();
  }

  void _cancelWarningTimer() {
    if (sessionExpiryWarningTimer != null) {
      sessionExpiryWarningTimer?.cancel();
    }
  }

  void _cancelLogoutTimer() {
    if (sessionExpiryTimer != null) {
      sessionExpiryTimer?.cancel();
    }
  }

  void cancelTimers() {
    _cancelLogoutTimer();
    _cancelWarningTimer();
  }

  void _warn() {
    if (applicationActive.value) {
      Get.dialog(
        DrivenDialog(
          text: const [
            TextSpan(text: ViewText.youHaveBeenInactive),
          ],
          primaryButton: const DefaultDialogCloseButton(),
          secondaryButton: _inactivityLogoutButton(),
        ),
      ).then((_) => initializeTimers());
    }
  }

  Widget _inactivityLogoutButton() {
    return UnderlinedButton.black(
      onPressed: DrivenSiteLocator.instance.onLogout,
      text: ViewText.logOut,
    );
  }

  void _resumeApplication() {
    applicationActive.value = true;

    if (sessionExpiryTimer != null && sessionExpiryTimer!.isActive) {
      initializeTimers();
    }
  }

  void _suspendApplication() {
    applicationActive.value = false;
  }

  @override
  void onDetached() {
    _suspendApplication();
  }

  @override
  void onInactive() {
    _suspendApplication();
  }

  @override
  void onPaused() {
    _suspendApplication();
  }

  @override
  void onResumed() {
    _resumeApplication();
  }

  @override
  Future<void> onClose() async {
    cancelTimers();
    super.onClose();
  }

  @override
  void onHidden() {}
}
