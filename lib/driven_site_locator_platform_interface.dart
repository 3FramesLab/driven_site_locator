import 'package:driven_site_locator/driven_site_locator_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class DrivenSiteLocatorPlatform extends PlatformInterface {
  /// Constructs a DrivenSiteLocatorPlatform.
  DrivenSiteLocatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static DrivenSiteLocatorPlatform _instance = MethodChannelDrivenSiteLocator();

  /// The default instance of [DrivenSiteLocatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelDrivenSiteLocator].
  static DrivenSiteLocatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DrivenSiteLocatorPlatform] when
  /// they register themselves.
  static set instance(DrivenSiteLocatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
