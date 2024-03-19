import 'dart:js' as js;

import 'package:driven_site_locator/dynatrace_utils/js_library.dart';
import 'package:js/js_util.dart';

class JSHelper {
  /// This method name inside 'getPlatform' should be same in JavaScript file
  String getPlatformFromJS() {
    return js.context.callMethod('getPlatform');
  }

  Future<String> callJSPromise() async {
    return promiseToFuture(jsPromiseFunction('I am back from JS'));
  }

  void logError(String errorMessage, int errorCode) {
    // js.context.callMethod(reportError('Report Error', 41));
    // js.context.callMethod(createActionAndError('create action error', 97));

    js.context.callMethod('createActionAndError', [errorMessage, errorCode]);
  }
}
