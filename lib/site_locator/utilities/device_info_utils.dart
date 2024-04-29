import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtils {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Future<WebBrowserInfo> getWebBrowserInfo() async {
    return deviceInfoPlugin.webBrowserInfo;
  }

  static Future<String> getWebBrowserName() async {
    final deviceInfo = await deviceInfoPlugin.webBrowserInfo;
    return deviceInfo.browserName.name;
  }
}
