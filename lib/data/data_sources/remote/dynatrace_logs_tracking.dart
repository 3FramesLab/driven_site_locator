import 'package:driven_site_locator/config/globals.dart';

void fireDynatraceFuelPriceAPILogs(String content) {
  Globals().dynatrace.tagEvent(content);
  // TODO(Shailendra): Enable it if you want to debug
  // debugPrint('FPLOGS dynatrace content = $content');
}
