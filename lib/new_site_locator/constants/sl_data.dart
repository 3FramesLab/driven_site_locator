class SLData {
  int inactivityLogoutTimeoutValue = 0;
  int inactivityWarningTimeoutValue = 0;
  bool isInactivityWrapperEnabled = true;
  void Function({bool expired})? onLogout;

  // Private constructor
  SLData._internal();
  static final SLData _instance = SLData._internal();

  // Public singleton accessor
  static SLData get instance => _instance;

  // Init method
  void init({
    required int inactivityLogoutTimeoutValue,
    required int inactivityWarningTimeoutValue,
    required bool isInactivityWrapperEnabled,
    void Function({bool expired})? onLogout,
  }) {
    this.inactivityLogoutTimeoutValue = inactivityLogoutTimeoutValue;
    this.inactivityWarningTimeoutValue = inactivityWarningTimeoutValue;
    this.isInactivityWrapperEnabled = isInactivityWrapperEnabled;
     this.onLogout = onLogout;
  }
}
