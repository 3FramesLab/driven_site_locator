part of sl_constants_module;

class DynatraceError {
  // Amazon
  static const scannedCardValidationFailed =
      'scanned card number validation failed';
  static const scannedCardInvalidate =
      'scanned card number does not match the card number validation';
  static const cardScannerListenerFailed = 'card scanner listener failed';
  static const scannedCardListenerFailed = 'scanned card onListenCard() failed';
  static const accessTokenExpiredError = 'Access Token Expired Error';
  static const fcmGetTokenError = 'error while fetching fcm token';
}
