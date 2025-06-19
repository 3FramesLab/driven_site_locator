part of site_locator_map_module;

class SelectedMarkerPainter extends CustomPainter {
  SelectedMarkerPainter(
    this.priceTagImage,
    this.brandLogoImage, {
    required this.site,
    this.price,
  });

  final double? price;
  final ui.Image priceTagImage;
  final ui.Image brandLogoImage;
  final Site site;

  @override
  void paint(Canvas canvas, Size size) {
    if (AppUtils.isComdata && !MCSitesGovernor.isMCSitesViewEnabled) {
      final Paint paint = Paint();
      canvas.drawImage(priceTagImage, Offset.zero, paint);
      double ofX, ofY;
      ofX = (size.width - brandLogoImage.width) / 2;
      ofY = ((size.height - brandLogoImage.height) / 2) * 0.75;
      canvas.drawImage(brandLogoImage, Offset(ofX, ofY), paint);
    } else {
      const double markerImageWidth = 134;
      final Paint paint = Paint();
      canvas.drawImage(priceTagImage, Offset.zero, paint);
      double ofX, ofY;
      ofX = (markerImageWidth - brandLogoImage.width) - 22;
      ofY = 23;
      canvas.drawImage(brandLogoImage, Offset(ofX, ofY), paint);
    }
  }

  @override
  bool shouldRepaint(SelectedMarkerPainter oldDelegate) {
    return false;
  }
}
