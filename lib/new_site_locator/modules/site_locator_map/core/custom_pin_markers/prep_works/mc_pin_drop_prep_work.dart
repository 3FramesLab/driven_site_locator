part of site_locator_map_module;

class MCPinDropPrepWork {
  static Future<ByteData?> normalPinDrop({
    required ui.PictureRecorder pictureRecorder,
    required ui.Image bannerPinMarkerImageBg,
    required ui.Image brandLogoToBePassed,
    required double? price,
    required Site site,
  }) async {
    final canvas = Canvas(pictureRecorder);
    final mcPinMarkerPainter = MCPinMarkerPainter(
      bannerPinMarkerImageBg,
      brandLogoToBePassed,
      price: price,
      site: site,
    );

    mcPinMarkerPainter.paint(
        canvas,
        Size(
          MCPinDropBannerSize.width.toDouble(),
          MCPinDropBannerSize.height.toDouble(),
        ));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(
        MCPinDropBannerSize.width, MCPinDropBannerSize.height);
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
    final canvas = Canvas(pictureRecorder);
    final mcPinMarkerPainter = MCPinMarkerPainter(
      bannerPinMarkerImageBg,
      brandLogoToBePassed,
      price: price,
      site: site,
    );

    mcPinMarkerPainter.paint(
        canvas,
        Size(
          MCPinDropBannerSize.width.toDouble(),
          MCPinDropBannerSize.height.toDouble(),
        ));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(
        MCPinDropBannerSize.width, MCPinDropBannerSize.height);
    return img;
  }
}
