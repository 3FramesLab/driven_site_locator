@JS()
library script.js;

import 'package:js/js.dart';

// This function will do Promise to return something
@JS()
external dynamic jsPromiseFunction(String message);

@JS()
external dynamic reportError(String error, int code);

@JS()
external dynamic createActionAndError(String error, int code);

@JS()
external dynamic tagUser(String userTag);

@JS()
external dynamic tagEvent(String eventName);
