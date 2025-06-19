class Routes {
  // Route App Starts on.
  static const String initial = forceUpdateApp;

  // Utility
  static const String notFound = '/notFound';

  // Pages
  static const String forceUpdateApp = '/forceUpdateApp';
  static const String comingSoon = '/comingSoon';
  static const String welcome = '/welcome';
  static const String createProfile = '/createProfile';
  static const String dcLogin = '/dcLogin';
  static const String guestLanding = '/guestLanding';
  static const String guestHome = '/guestHome';
  static const String joinAFleet = '/joinAFleet'; // Add card
  static const String adminHome = '/adminHome';
  static const String login = '/login';
  static const String retrieveUsername = '/retrieveUsername';
  static const String signupSelectCardType = '/signup/selectCardType';
  static const String cardHolderSignup = '/cardHolderSignup';
  static const String home = '/home';
  static const String homeNoRefresh = '/homeNoRefresh';
  static const String wallet = '/wallet';
  static const String account = '/account';
  static const String deleteAccount = '/deleteAccount';
  static const String reportProblem = '/reportProblem';
  static const String notifications = '/notifications';
  static const String forgotPasswordCardholder = '/forgotPasswordCardholder';
  static const String resetPin = '/resetPin';
  static const String removeCard = '/removeCard';
  static const String settings = '/settings';
  static const String dcSettings = '/dcSettings';
  static const String findingInstruction = '/findingInstruction';
  static const String dcNotificationsSettings = '/dcNotificationsSettings';
  static const String dcLoginPreferencesSettings =
      '/dcLoginPreferencesSettings';
  static const String dcUpdateName = '/dcUpdateName';
  static const String updatePasscode = '/updatePassCode';
  static const String dcChangePasswordSettings = '/dcChangePasswordSettings';
  static const String dcNeedHelp = '/dcNeedHelp';
  static const String shareFeedback = '/shareFeedback';
  static const String dcDeleteUser = '/dcDeleteUser';
  static const String dcVerifyCodeForDeleteUser = '/dcVerifyCodeForDeleteUser';
  static const String dcTempSettingsScreen = '/dcTempSettingsScreen';
  static const String dcHelpCenter = '/dcHelpCenter';
  static const String productOffers = '/productOffers';
  static const String learnDriven = '/learnDriven';
  static const String mainMenu = '/mainMenu';
  static const String productMenu = '/productMenu';
  static const String productInAppView = '/productInAppView';
  static const String updateEmail = '/updateEmail';
  static const String updateMobile = '/updateMobile';
  static const String transactions = '/transactions';
  static const String transaction = '/transaction';
  static const String cardSelection = '/cardSelection';
  static const String changeNickname = '/changeNickname';
  static const String createComchek = '/createComchek';
  static const String createComchekConfirm = '/createComchekConfirm';
  static const String transactionsFilter = '/transactionsFilter';
  static const String transferFunds = '/transfer';
  static const String transferBank = '/transferBank';
  static const String transferBankConfirm = '/transferBankConfirm';
  static const String transferP2P = '/transferP2P';
  static const String transferP2PConfirm = '/transferP2PConfirm';
  static const String transferExpressCode = '/transferExpressCode';
  static const String expressCodePageRoute = '/expressCodePageRoute';
  static const String cardToCardPageRoute = '/cardToCardPageRoute';
  static const String peerToPeerPageRoute = '/peerToPeerPageRoute';
  static const String comchekPageRoute = '/comchekPageRoute';
  static const String transferCard2Card = '/transferCard2Card';
  static const String transferExpressCodeConfirm =
      '/transferExpressCodeConfirm';
  static const String expressCodeDetails = '/transferExpressCodeDetails';
  static const String changeBank = '/changeBank';
  static const String changeBankAccountReviewConfirm =
      '/changeBankAccountReviewConfirm';
  static const String legalDocs = '/legalDocs';
  static const String addCard = '/addCard';
  static const String pendingUser = '/pendingUser';
  static const String cmorLegal = '/cmorLegal';
  static const String eula = '/eula';
  static const String privacyPolicy = '/privacyPolicy';
  static const String pendingCip = '/pendingCip';
  static const String changePassword = '/changePassword';
  static const String learnMoreAboutMfa = '/learnMoreAboutMfa';
  static const String selectYourCard = '/selectYourCard';
  static const String bankTransfer = '/bankTransfer';
  static const String transferFundsSuccess = '/transferFundsSuccess';
  static const String expressCheckSettings = '/expressCheckSettings';

  // OnRoad Sign Up
  static const String onroadSignupCardInformation =
      '/onroadSignup/cardInformation';
  static const String onroadSignupCardVerified = '/onroadSignup/cardVerified';
  static const String onroadSignupCreateAccount = '/onroadSignup/createAccount';
  static const String onroadSignupCreateAccountSuccess =
      '/onroadSignup/createAccountSuccess';
  static const String onroadSignupBasicInfo = '/onroadSignup/basicInfo';
  static const String onroadSignupSelectUserType =
      '/onroadSignup/selectUserType';
  static const String onroadSignupBusinessInfo = '/onroadSignup/businessInfo';
  static const String onroadSignupBusinessReview =
      '/onroadSignup/businessReview';
  static const String signupDataCollection = '/onroadSignup/dataCollection';

  // Incomplete signup Flow routes
  static const String incompleteSignupIndividual =
      '/incompleteSignupIndividual/createAccount';
  static const String incompleteSignupBusiness =
      '/incompleteSignupBusiness/createAccount';

  // Comchek Sign Up
  static const String comchekSignupCreateAccount =
      '/comchekSignup/createAccount';
  static const String comchekSignupCreateBusinessAccount =
      '/comchekSignup/createBusinessAccount';
  static const String comchekSignupCreateAccountSuccess =
      '/comchekSignup/createAccountSuccess';
  static const String comchekSignupIndividualInfo1 =
      '/comchekSignup/individualInfo1';
  static const String comchekSignupIndividualInfo2 =
      '/comchekSignup/individualInfo2';
  static const String comchekSignupIndividualReview =
      '/comchekSignup/individualReview';
  static const String comchekSignupBusinessInfo = '/comchekSignup/businessInfo';
  static const String comchekSignupManagerInfo = '/comchekSignup/managerInfo';
  static const String comchekSignupOwnerInfo = '/comchekSignup/ownerInfo/:id';
  static const String comchekSignupOwnerInfo1 = '/comchekSignup/ownerInfo/1';
  static const String comchekCardFeeSchedule = '/comchekSignup/cardFeeSchedule';
  static const String comchekSignupBusinessReview =
      '/comchekSignup/businessReview';
  static const String comcheckCardholderAgreement =
      '/comcheckSignup/cardholder';
  static const String shouldReceiveCard = '/comcheckSignup/shouldReceiveCard';
  static const String signUp = '/signUp';
  static const String signupComplete = '/onroadSignup/registrationComplete';
  static const String comdataSetupEmailMfa = '/comdataSetupEmailMfa';

  // CIP Check Individual Flow
  static const String cipCheckIndividual = '/cipCheckIndividual';
  static const String cipCheckIndividualReviewInfo =
      '/cipCheckIndividual/reviewInfo';

  // CIP Check Business Flow
  static const String cipCheckBusinessTypes = '/cipCheckBusiness/businessTypes';
  static const String cipCheckBusinessInfo = '/cipCheckBusiness/businessInfo';
  static const String cipCheckManagerInfo = '/cipCheckBusiness/managerInfo';
  static const String cipCheckOwnerInfo = '/cipCheckBusiness/ownerInfo';
  static const String employmentInformation =
      '/cipCheckBusiness/employmentInfo';
  static const String cipCheckBusinessReviewInfo =
      '/cipCheckBusiness/reviewInfo';
  static const String cipApplyForCardReviewInfo =
      '/cipCheckBusiness/cipApplyForCardReviewInfo';
  static const String addNewCard = '/addNewCard';

  // Apply for Card
  static const String applyForCard = '/applyForCard';
  static const String shippingAddress = '/shippingAddress';
  static const String cipCardFeeSchedule = '/cipCardFeeSchedule';
  static const String cipComplete = '/cipComplete';
  static const String taxIdCipCheck = '/taxIdCipCheck';
  static const String newIndividualReviewInfo = '/individualReviewInfo';

  // Remote Config
  static const String remoteMessageDetail = '/remoteMessageDetail';

  // Common PDF Viewer
  static const String pdfViewer = '/pdfViewer';

  // Common Web View
  static const String commonWebView = '/commonWebView';

  // Fraud Alerts
  static const String turnOnSmsFraudAlerts = '/turnOnSmsFraudAlerts';
  static const String turnOffSmsFraudAlerts = '/turnOffSmsFraudAlerts';
  static const String fraudAlertTermsAndConditions =
      '/fraudAlertTermsAndConditions';

  // Prop card
  static const String addNewPropCardDetails = '/addNewPropCardDetails';
  static const String c2cTransferReviewConfirm = '/c2cTransferReviewConfirm';

  // Reset New Password
  static const passwordReset = '/passwordReset';
  static const forgotPasswordVerification = '/forgotPasswordVerification';

  // One Click tutorial
  static const oneClickTutorial = '/oneClickTutorial';

  // Add card for unauthenticated user
  static const String getFuelCardToken = '/getFuelCardToken';
  static const String addFuelCard = '/addFuelCard';
  static const String editFuelCard = '/editFuelCard';
  static const String fuelCardsSelection = '/fuelCardsSelection';

  // Report an Issue SiteLocator
  static const String reportAnIssueUnauthSL = '/reportAnIssueUnauthSL';
  static const String reportAnIssueAuthSL = '/reportAnIssueAuthSL';

  // Amazon
  static const String routeId = '/routeId';
  static const String amazonWelcome = '/amazonWelcome';
  static const String letsGetStarted = '/letsGetStarted';
  static const String reusableComponents = '/reusableComponents';
  static const String addCardManually = '/addCardManually';
  static const String manualVINEnter = '/manualVinEnter';
  static const String scanCard = '/scanCard';
  static const String vinIntro = '/vinIntro';
  static const String qrCodeScanner = '/qrCodeScanner';
  static const String amazonWallet = '/amazonWallet';
  static const String removeAmazonCard = '/removeAmazonCard';
  static const String needHelp = '/needHelp';

  // Driven Connect Unauth SL
  static const String unauthSiteLocator = '/unauthSiteLocatorMap';
  static const String mobileFactorSetting = '/dcMobileFactorSetting';
  static const String emailFactorSetting = '/dcEmailFactorSetting';
  static const String searchPlace = '/searchPlace';

  // MFA
  static const enrollEmailInfo = '/enrollEmailInfo';
  static const mfaSetupComplete = '/mfaSetupComplete';
  static const setUpMfaEmail = '/setupMfaEmail';
  static const setUpMfaSMS = '/setupMfaSMS';
  static const mobileSetupInfo = '/mobileSetupInfo';
  static const verificationCode = '/verificationCode';

  // Self Registration
  static const adminApprovalInformation = '/adminApprovalInformation';
  static const amazonWebView = '/amazonWebView';

  // Admin
  static const dcAdminDashboard = '/dcAdminDashboard';
  static const selectCustomerId = '/selectCustomerId';
  static const adminAccountsList = '/adminAccountsList';
  static const accountSettings = '/accountSettings';
  static const cardholderRequests = '/cardholderRequests';

  // Create profile
  static const createProfileSuccess = '/createProfileSuccess';

  // Settings factor verification
  static const factorVerificationCode = '/factorVerificationCode';
  static const String locationRequired = '/locationRequired';

  // DFC Chat
  static const String chatPage = '/chatPage';

  // Cardholder
  static const cardholderDashboard = '/cardholderDashboard';
  static const cardholderHome = '/cardholderHome';
  static const cardholderWallet = '/cardholderWallet';
  static const cardholderActivity = '/cardholderActivity';
  static const turnOnFraudAlert = '/turnOnFraudAlert';
  static const turnOffFraudAlert = '/turnOffFraudAlert';
  static const cardholderFilterActivity = '/cardholderFilterActivity';
  static const addOrEditBankAccount = '/addOrEditBankAccount';

  // Driven Connect Auth SL
  static const String brandQuickFilter = '/brandQuickFilter';

  // Forgot password
  static const dcForgotPassword = '/dcForgotPassword';
  static const dcForgotPasswordVerification = '/dcForgotPasswordVerification';
  static const dcCreatePassword = '/dcCreatePassword';
}
