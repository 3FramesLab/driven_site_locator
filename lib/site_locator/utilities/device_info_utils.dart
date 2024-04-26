import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtils {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Future<WebBrowserInfo> getWebBrowserInfo() async {
    return deviceInfoPlugin.webBrowserInfo;
  }
}
