import 'package:driven_common/data/data_module.dart';
import 'package:driven_site_locator/config/web_app_service.dart';

class WebGlobals {
  static late WebAppService webAppService;

  static Future<void> initAll() async {
    webAppService = WebAppService();
    await PreferenceUtils.init();
  }

  static bool get kIsWeb => webAppService.getkIsWeb();
}
