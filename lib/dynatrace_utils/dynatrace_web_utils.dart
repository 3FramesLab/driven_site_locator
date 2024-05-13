// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as dart_js;

class DynatraceWebUtils {
  static void logError({
    required String name,
    required String value,
    String reason = '',
    String? stackTrace,
    int? errorCode,
  }) {
    logErrorForWebApp(name, errorCode);
  }

  static void logErrorForWebApp(String? error, int? errorCode) {
    final err = error ?? 'Unknown Error';
    final errCode = errorCode ?? -99;
    dart_js.context.callMethod('createActionAndError', [err, errCode]);
  }

  // Tag User
  static void tagUser(String userTag) {
    dart_js.context.callMethod('tagUser', [userTag]);
  }

  // Tag Event
  static void tagEvent(String eventName) {
    dart_js.context.callMethod('tagEvent', [eventName]);
  }
}
