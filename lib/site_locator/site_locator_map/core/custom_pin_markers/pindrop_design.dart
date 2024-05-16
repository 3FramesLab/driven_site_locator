import 'dart:ui' as ui;

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:flutter/foundation.dart';

class PindropDesign {
  static final isWebForMobile = SiteLocatorAssets.isWebForMobile();
  static TextStyle getPriceStyle(Site site, String? price) {
    Color priceTextColor = site.hasDiscount ? Colors.black : Colors.white;
    // DFC Asset updates
    if (AppUtils.isComdata) {
      priceTextColor = site.hasGallonUp ? Colors.white : Colors.black;
    }

    if (kIsWeb) {
      return TextStyle(
        color: priceTextColor,
        fontFamily: DrivenFonts.avertaFontFamily,
        fontSize: (price != null && price.length < 5)
            ? (isWebForMobile ? 6 : 12)
            : (isWebForMobile ? 4 : 10),
        fontWeight: isWebForMobile ? FontWeight.w500 : FontWeight.w600,
      );
    }
    // for Mobile App
    return TextStyle(
      color: priceTextColor,
      fontFamily: DrivenFonts.avertaFontFamily,
      fontSize: (price != null && price.length < 5) ? 28 : 24,
      fontWeight: FontWeight.w600,
    );
  }

  static double getMarkerImageWidth(Site site, String? price) {
    double markerImageWidth = price != null ? 230 : 73;
    if (kIsWeb) {
      final double pinWidth = site.hasDiscount ? 100.0 : 85.0;
      markerImageWidth = price != null ? pinWidth : 39;
      if (isWebForMobile) {
        markerImageWidth = price != null ? 54 : 21;
      }
    }
    return markerImageWidth;
  }

  static LogoAlignment getLogoAlignment({
    required Site site,
    required double markerImageWidth,
    required ui.Image brandLogoImage,
    required String? price,
  }) {
    // intial dimension default setup starts
    const sizingFactor = 1;
    double ofX, ofY;
    ofX = (markerImageWidth - brandLogoImage.width) - 20;
    ofY = 12 / sizingFactor;
    double logoAlignX = price != null ? ofX : ofX + 20;

    if (AppUtils.isComdata) {
      // DFC Asset updates
      logoAlignX = price != null ? ofX + 2 : ofX + 20;
    }
    double logoAlignY = site.hasDiscount
        ? ofY + 5
        : price != null
            ? ofY + 4
            : ofY + 5;
    // intial dimension default setup ends

    if (kIsWeb) {
      // ALL WEB RELATED CODE;
      final sizingFactor = isWebForMobile ? 4 : 2;

      ofX = (markerImageWidth - brandLogoImage.width) - 20;
      ofY = 12 / sizingFactor;
      logoAlignX = price != null ? ofX : ofX + 20;

      if (AppUtils.isComdata) {
        // DFC Asset updates
        logoAlignX = price != null ? ofX + 2 : ofX + 20;
      }
      logoAlignY = 4;
      if (!isWebForMobile) {
        // For web and desktop/tablet assets only
        if (site.hasDiscount) {
          logoAlignX =
              price != null ? (logoAlignX + 15) : (logoAlignX - 5) + 0.5;
        } else {
          logoAlignX =
              price != null ? (logoAlignX + 15) : (logoAlignX - 5) + 0.5;
        }
        if (site.hasDiscount) {
          logoAlignY = price != null ? logoAlignY + 1 : logoAlignY + 1;
        } else {
          logoAlignY = price != null ? logoAlignY + 1 : logoAlignY + 1;
        }
      }
      if (isWebForMobile) {
        // For web+mobile browsersassets only
        if (site.hasDiscount) {
          logoAlignX =
              price != null ? (logoAlignX + 17.25) : (logoAlignX - 3.25);
        } else {
          logoAlignX = price != null ? (logoAlignX + 8.5) : (logoAlignX - 3.25);
        }
        if (site.hasDiscount) {
          logoAlignY = price != null ? logoAlignY - 1.25 : logoAlignY - 1.25;
        } else {
          logoAlignY = price != null ? logoAlignY - 1.25 : logoAlignY - 1.25;
        }
      }
    } else {
      // For Mobile App assets only
      const sizingFactor = 1;
      ofX = (markerImageWidth - brandLogoImage.width) - 20;
      ofY = 12 / sizingFactor;
      logoAlignX = price != null ? ofX : ofX + 20;

      if (AppUtils.isComdata) {
        // DFC Asset updates
        logoAlignX = price != null ? ofX + 2 : ofX + 20;
      }
      logoAlignY = site.hasDiscount
          ? ofY + 5
          : price != null
              ? ofY + 4
              : ofY + 5;
    }

    // +++++++++++++

    return LogoAlignment(offsetX: logoAlignX, offsetY: logoAlignY);
  }

  static LogoAlignment getSelectedLogoAlignment(
    ui.Image brandLogoImage,
  ) {
    double markerImageWidth = 134;
    if (kIsWeb) {
      markerImageWidth = 64;
      if (isWebForMobile) {
        markerImageWidth = 26;
      }
    }

    double offsetX, offsetY;
    offsetX = (markerImageWidth - brandLogoImage.width) - 22;
    offsetY = 23;
    if (kIsWeb) {
      offsetX = isWebForMobile ? offsetX + 25 : offsetX + 16;
      offsetY = isWebForMobile ? offsetY - 20.5 : offsetY - 17.5;
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
