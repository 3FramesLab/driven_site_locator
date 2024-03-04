import 'dart:ui' as ui;

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/pindrop_design.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  MarkerPainter(
    this.priceTagImage,
    this.brandLogoImage, {
    required this.site,
    this.price,
  });

  final String? price;
  final ui.Image priceTagImage;
  final ui.Image brandLogoImage;
  final Site site;

  @override
  void paint(Canvas canvas, Size size) {
    final markerImageWidth = PindropDesign.getMarkerImageWidth(site);
    final Paint paint = Paint();
    canvas.drawImage(priceTagImage, Offset.zero, paint);

    final brandLogoAlignment = PindropDesign.getLogoAlignment(
      site: site,
      markerImageWidth: markerImageWidth,
      brandLogoImage: brandLogoImage,
    );
    canvas.drawImage(brandLogoImage,
        Offset(brandLogoAlignment.offsetX, brandLogoAlignment.offsetY), paint);

    // if Price available then paint the price banner
    if (price != null) {
      final textStyle = PindropDesign.getPriceStyle(site);
      final textSpan = TextSpan(
        text: '\$$price',
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(
          maxWidth: size.width,
        );
      int adjustLeft = site.hasDiscount ? 11 : 15;
      int adjustTop = 8;
      if (AppUtils.isComdata) {
        // DFC Asset updates
        adjustLeft = site.hasGallonUp ? 18 : 15;
        adjustTop = 10;
      }
      final xAdjuster = (price != null && price!.length < 5) ? adjustLeft : 12;
      double dx = (((size.width) - textPainter.width) * 0.5) - xAdjuster;
      double dy = ((size.height - textPainter.height) * 0.6) - adjustTop;
      dx = kIsWeb ? (site.hasDiscount ? dx + 4 : dx + 1) : dx;
      dy = kIsWeb ? (site.hasDiscount ? dy + 3 : dy + 3) : dy;
      final offset = Offset(dx, dy);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SelectedMarkerPainter extends CustomPainter {
  SelectedMarkerPainter(
    this.priceTagImage,
    this.brandLogoImage, {
    required this.site,
    this.price,
  });

  final String? price;
  final ui.Image priceTagImage;
  final ui.Image brandLogoImage;
  final Site site;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    canvas.drawImage(priceTagImage, Offset.zero, paint);
    final logoAlignment =
        PindropDesign.getSelectedLogoAlignment(brandLogoImage);
    canvas.drawImage(brandLogoImage,
        Offset(logoAlignment.offsetX, logoAlignment.offsetY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
