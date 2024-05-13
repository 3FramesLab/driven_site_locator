export 'dynatrace_utils.dart'
    if (dart.library.js) 'dynatrace_web_utils.dart'
    if (dart.library.io) 'dynatrace_utils.dart';
