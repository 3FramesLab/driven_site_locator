import 'dart:ui' as ui;

import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
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
    Color priceTextColor = site.hasDiscount ? Colors.black : Colors.white;
    // DFC Asset updates
    if (AppUtils.isComdata) {
      priceTextColor = site.hasGallonUp ? Colors.white : Colors.black;
    }
    final textStyle = TextStyle(
      color: priceTextColor,
      fontFamily: 'OpenSans',
      fontSize: (price != null && price!.length < 5) ? 28 : 24,
      fontWeight: FontWeight.bold,
    );

    final double markerImageWidth = price != null ? 230 : 73;
    final Paint paint = Paint();

    canvas.drawImage(priceTagImage, Offset.zero, paint);
    double ofX, ofY;
    ofX = (markerImageWidth - brandLogoImage.width) - 20;
    ofY = 12;
    double logoAlignX = site.price != null ? ofX : ofX + 20;

    if (AppUtils.isComdata) {
      // DFC Asset updates
      logoAlignX = site.price != null ? ofX + 2 : ofX + 20;
    }
    final double logoAlignY = site.hasDiscount
        ? ofY + 5
        : site.price != null
            ? ofY + 4
            : ofY + 5;

    canvas.drawImage(brandLogoImage, Offset(logoAlignX, logoAlignY), paint);

    // if Price available then paint the price banner
    if (price != null) {
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
      final dx = (((size.width) - textPainter.width) * 0.5) - xAdjuster;
      final dy = ((size.height - textPainter.height) * 0.6) - adjustTop;

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
    const double markerImageWidth = 134;
    final Paint paint = Paint();
    canvas.drawImage(priceTagImage, Offset.zero, paint);
    double ofX, ofY;
    ofX = (markerImageWidth - brandLogoImage.width) - 22;
    ofY = 23;
    canvas.drawImage(brandLogoImage, Offset(ofX, ofY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
