import 'package:driven_site_locator/driven_site_locator_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [DrivenSiteLocatorPlatform] that uses method channels.
class MethodChannelDrivenSiteLocator extends DrivenSiteLocatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('driven_site_locator');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
