part of site_locator_map_module;

class CustomShapeCluster {
  static Future<BitmapDescriptor> make(
      double bestPrice, String siteCount) async {
    const double width = 230;
    const double height = 100;
    const double cornerRadius = 100;

    // Create a PictureRecorder
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(pictureRecorder);
    final ui.Paint paint = ui.Paint()
      // ..color = ui.Color.fromARGB(255, 16, 65, 211);
      ..color = DrivenColors.primary;
    //Colors.white;

    // Draw a rounded rectangle for the main shape
    final RRect rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rect, paint);

    canvas.drawRect(const Rect.fromLTRB(0, 0, 50, 100), paint);

    canvas.drawCircle(
      const Offset(178, 50),
      45,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // Draw the price text

    final textStyle = CustomPin.priceStyle.copyWith(
      color: Colors.white,
      fontSize: CustomPin.priceNot10(bestPrice) ? 38.5 : 23,
    );
    final TextPainter bestPricePainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '\$$bestPrice',
        style: textStyle,
      ),
    );

    bestPricePainter.layout(maxWidth: width);
    bestPricePainter.paint(
      canvas,
      const Offset(15, 5),
    );

    final TextPainter bestTextPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: const TextSpan(
        text: 'Best',
        style: TextStyle(
          fontSize: 38,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

    bestTextPainter.layout(maxWidth: width);
    bestTextPainter.paint(
      canvas,
      const Offset(15, 50),
    );
    // siteCount = '99';
    final TextPainter countTextPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: siteCount,
        style: TextStyle(
          fontSize: siteCount == '99+' ? 28 : 40,
          color: DrivenColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    countTextPainter.layout(maxWidth: width);
    if (siteCount == '99+') {
      countTextPainter.paint(
        canvas,
        const Offset(152, 30),
      );
    } else {
      final sc = siteCount.isEmpty ? 0 : int.parse(siteCount);
      final double dx = sc < 10 ? 166 : 152;
      countTextPainter.paint(
        canvas,
        Offset(dx, 25),
      );
    }

    // Create an image from the canvas drawing
    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }
}



// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:driven/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';
// import 'package:driven_common_sl_pkg/styles/styles_module.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CustomShapeCluster {
//   static Future<BitmapDescriptor> make(
//       String bestPrice, String siteCount) async {
//     final double width = 230.0;
//     final double height = 100.0;
//     final double cornerRadius = 100.0;

//     // Create a PictureRecorder
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final ui.Canvas canvas = ui.Canvas(pictureRecorder);
//     final ui.Paint paint = ui.Paint()
//       // ..color = ui.Color.fromARGB(255, 16, 65, 211);
//       ..color = DrivenColors.primary;
//     //Colors.white;
//     final double pointerHeight = 20.0;

//     // Draw a rounded rectangle for the main shape
//     final RRect rect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(0, 0, width, height),
//       Radius.circular(cornerRadius),
//     );
//     canvas.drawRRect(rect, paint);

//     canvas.drawRect(Rect.fromLTRB(0, 0, 50, 100), paint);

//     // Draw the pointer (small triangle at the bottom center)
//     // Path pointerPath = Path();
//     // pointerPath.moveTo(width / 2 - 20, height); // Starting point
//     // pointerPath.lineTo(width / 2 + 20, height); // Right side
//     // pointerPath.lineTo(width / 2, height + pointerHeight); // Bottom point
//     // pointerPath.close();
//     // // canvas.drawPath(pointerPath, paint);

//     // // Draw the Logo image painting
//     // final Paint logoPaint = Paint();
//     // final priceTagImage = CustomPin.defaultBrandLogoSmall;

//     // canvas.drawImage(priceTagImage, Offset(10, 12), logoPaint);

//     canvas.drawCircle(
//       Offset(178, 50),
//       45,
//       Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill,
//     );

//     // final RRect whiteCircle = RRect.fromRectAndRadius(
//     //   Rect.fromLTWH(0, 0, cornerRadius, cornerRadius),
//     //   Radius.circular(cornerRadius),
//     // );
//     // canvas.drawRRect(whiteCircle, paint);

//     // Draw the price text
//     TextPainter textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         text: '\$$bestPrice',
//         style: TextStyle(
//           fontSize: 34,
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );

//     textPainter.layout(minWidth: 0, maxWidth: width);
//     textPainter.paint(
//       canvas,
//       Offset(24, 10),
//     );

//     TextPainter BestTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         text: 'Best',
//         style: TextStyle(
//           fontSize: 32,
//           color: Colors.white,
//           fontWeight: FontWeight.normal,
//         ),
//       ),
//     );

//     BestTextPainter.layout(minWidth: 0, maxWidth: width);
//     BestTextPainter.paint(
//       canvas,
//       Offset(24, 50),
//     );

//     TextPainter CountTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         text: siteCount,
//         style: TextStyle(
//           fontSize: siteCount == '99+' ? 28 : 35,
//           color: DrivenColors.primary,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );

//     CountTextPainter.layout(minWidth: 0, maxWidth: width);
//     if (siteCount == '99+') {
//       CountTextPainter.paint(
//         canvas,
//         Offset(152, 30),
//       );
//     } else {
//       final sc = int.parse(siteCount);
//       final double dx = sc < 10 ? 166 : 160;
//       CountTextPainter.paint(
//         canvas,
//         Offset(dx, 28),
//       );
//     }

//     //  final textPainter = TextPainter(
//     //     text: textSpan,
//     //     textDirection: TextDirection.ltr,
//     //   )..layout(
//     //       maxWidth: size.width,
//     //     );

//     // Create an image from the canvas drawing
//     final ui.Image image = await pictureRecorder
//         .endRecording()
//         .toImage(width.toInt(), (height).toInt());
//     final ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);
//     final Uint8List pngBytes = byteData!.buffer.asUint8List();

//     return BitmapDescriptor.fromBytes(pngBytes);
//   }
// }

// ignore_for_file: deprecated_member_use
