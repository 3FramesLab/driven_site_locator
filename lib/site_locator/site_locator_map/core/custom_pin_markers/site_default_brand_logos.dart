import 'dart:ui' as ui;

import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';

class DefaultBrandLogos {
  static ui.Image? small;
  static ui.Image? big;
  static Future<void> setup() async {
    small =
        await CustomPin.defaultLogo(BrandLogoSize.small, BrandLogoSize.small);
    big = await CustomPin.defaultLogo(BrandLogoSize.big, BrandLogoSize.big);
  }
}
