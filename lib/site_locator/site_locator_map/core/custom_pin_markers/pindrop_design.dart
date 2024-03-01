import 'dart:ui' as ui;

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:flutter/foundation.dart';

class PindropDesign {
  static TextStyle getPriceStyle(Site site) {
    final price = site.price;
    Color priceTextColor = site.hasDiscount ? Colors.black : Colors.white;
    // DFC Asset updates
    if (AppUtils.isComdata) {
      priceTextColor = site.hasGallonUp ? Colors.white : Colors.black;
    }
    return TextStyle(
      color: priceTextColor,
      fontFamily: DrivenFonts.avertaFontFamily,
      fontSize: (price != null && price.length < 5)
          ? (kIsWeb ? 12 : 28)
          : (kIsWeb ? 10 : 24),
      fontWeight: FontWeight.w600,
    );
  }

  static double getMarkerImageWidth(Site site) {
    final price = site.price;
    double markerImageWidth = price != null ? 230 : 73;
    if (kIsWeb) {
      final double pinWidth = site.hasDiscount ? 100.0 : 85.0;
      markerImageWidth = price != null ? pinWidth : 39;
    }
    return markerImageWidth;
  }

  static LogoAlignment getLogoAlignment({
    required Site site,
    required double markerImageWidth,
    required ui.Image brandLogoImage,
  }) {
    const sizingFactor = kIsWeb ? 2 : 1;
    double ofX, ofY;
    ofX = (markerImageWidth - brandLogoImage.width) - 20;
    ofY = 12 / sizingFactor;
    double logoAlignX = site.price != null ? ofX : ofX + 20;

    if (AppUtils.isComdata) {
      // DFC Asset updates
      logoAlignX = site.price != null ? ofX + 2 : ofX + 20;
    }
    double logoAlignY = kIsWeb
        ? 4
        : site.hasDiscount
            ? ofY + 5
            : site.price != null
                ? ofY + 4
                : ofY + 5;

    if (kIsWeb) {
      if (site.hasDiscount) {
        logoAlignX =
            site.price != null ? (logoAlignX + 15) : (logoAlignX - 5) + 0.5;
      } else {
        logoAlignX =
            site.price != null ? (logoAlignX + 15) : (logoAlignX - 5) + 0.5;
      }
      if (site.hasDiscount) {
        logoAlignY = site.price != null ? logoAlignY + 1 : logoAlignY + 1;
      } else {
        logoAlignY = site.price != null ? logoAlignY + 1 : logoAlignY + 1;
      }
    }
    return LogoAlignment(offsetX: logoAlignX, offsetY: logoAlignY);
  }

  static LogoAlignment getSelectedLogoAlignment(
    ui.Image brandLogoImage,
  ) {
    const double markerImageWidth = kIsWeb ? 64 : 134;

    double offsetX, offsetY;
    offsetX = (markerImageWidth - brandLogoImage.width) - 22;
    offsetY = 23;
    if (kIsWeb) {
      offsetX = offsetX + 16;
      offsetY = offsetY - 17.5;
    }
    return LogoAlignment(offsetX: offsetX, offsetY: offsetY);
  }
}

class LogoAlignment {
  final double offsetX;
  final double offsetY;

  LogoAlignment({
    required this.offsetX,
    required this.offsetY,
  });
}
