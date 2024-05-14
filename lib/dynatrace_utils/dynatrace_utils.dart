import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';

class DynatraceUtils {
  static void logError({
    required String name,
    required String value,
    String reason = '',
    String? stackTrace,
    int? errorCode,
  }) {
    logErrorForMobileApp(
      name: name,
      value: value,
      reason: reason,
      stackTrace: stackTrace,
    );
  }

  static void logErrorForMobileApp({
    required String name,
    required String value,
    String reason = '',
    String? stackTrace,
  }) {
    Globals().dynatrace.logError(
          name: DynatraceErrorMessages.getSitesAPIErrorName,
          value: DynatraceErrorMessages.getSitesAPIErrorValue,
          reason: reason,
        );
  }

  // Tag User
  static void tagUser(String userTag) {
    Globals().dynatrace.tagUser(userTag);
  }

  // Tag Event
  static void tagEvent(String eventName) {
    Globals().dynatrace.tagEvent(eventName);
  }
}
