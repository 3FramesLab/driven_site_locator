import 'package:driven_site_locator/config/web_app_service.dart';

class WebGlobals {
  static late WebAppService webAppService;

  static void initAll() {
    webAppService = WebAppService();
  }

  static bool get kIsWeb => webAppService.getkIsWeb();
}
