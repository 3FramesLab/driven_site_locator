// ignore_for_file: prefer_mixin

import 'package:driven_site_locator/driven_site_locator_method_channel.dart';
import 'package:driven_site_locator/driven_site_locator_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDrivenSiteLocatorPlatform
    with MockPlatformInterfaceMixin
    implements DrivenSiteLocatorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DrivenSiteLocatorPlatform initialPlatform =
      DrivenSiteLocatorPlatform.instance;

  test('$MethodChannelDrivenSiteLocator is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDrivenSiteLocator>());
  });

}
