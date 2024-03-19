import 'dart:js' as dart_js;

import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:flutter/foundation.dart';

class DynatraceUtils {
  static void logError({
    required String name,
    required String value,
    String reason = '',
    String? stackTrace,
    int? errorCode,
  }) {
    if (kIsWeb) {
      logErrorForWebApp(name, errorCode);
    } else {
      logErrorForMobileApp(
        name: name,
        value: value,
        reason: reason,
        stackTrace: stackTrace,
      );
    }
  }

  static void logErrorForWebApp(String? error, int? errorCode) {
    final err = error ?? 'Unknown Error';
    final errCode = errorCode ?? -99;
    dart_js.context.callMethod('createActionAndError', [err, errCode]);
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
    if (kIsWeb) {
      dart_js.context.callMethod('tagUser', [userTag]);
    } else {
      Globals().dynatrace.tagUser(userTag);
    }
  }

  // Tag Event
  static void tagEvent(String eventName) {
    if (kIsWeb) {
      dart_js.context.callMethod('tagEvent', [eventName]);
    } else {
      Globals().dynatrace.tagEvent(eventName);
    }
  }
}
