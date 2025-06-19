part of site_locator_map_module;

class RegularPinDropPrepWork {
  static Future<ByteData?> normalPinDrop({
    required ui.PictureRecorder pictureRecorder,
    required ui.Image bannerPinMarkerImageBg,
    required ui.Image brandLogoToBePassed,
    required double? price,
    required Site site,
  }) async {
    final width = bannerPinMarkerImageBg.width.toDouble();
    final height = bannerPinMarkerImageBg.height.toDouble();
    final widthAsInt = width.floor();
    final heightAsInt = height.floor();
    final canvas = Canvas(pictureRecorder);
    final markerPainter = MarkerPainter(
      bannerPinMarkerImageBg,
      brandLogoToBePassed,
      price: price,
      site: site,
    );

    markerPainter.paint(canvas, Size(width, height));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(widthAsInt, heightAsInt);
    final pinDropByteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return pinDropByteData;
  }

  static Future<ui.Image> normalPinDropImage({
    required ui.PictureRecorder pictureRecorder,
    required ui.Image bannerPinMarkerImageBg,
    required ui.Image brandLogoToBePassed,
    required double? price,
    required Site site,
  }) async {
    final width = bannerPinMarkerImageBg.width.toDouble();
    final height = bannerPinMarkerImageBg.height.toDouble();
    final widthAsInt = width.floor();
    final heightAsInt = height.floor();
    final canvas = Canvas(pictureRecorder);
    final markerPainter = MarkerPainter(
      bannerPinMarkerImageBg,
      brandLogoToBePassed,
      price: price,
      site: site,
    );

    markerPainter.paint(canvas, Size(width, height));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(widthAsInt, heightAsInt);
    return img;
    // final pinDropByteData =
    //     await img.toByteData(format: ui.ImageByteFormat.png);
    // return pinDropByteData;
  }
}
