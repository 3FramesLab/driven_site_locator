part of site_locator_map_module;

class MCPinSelectedMarkerPainter extends CustomPainter {
  MCPinSelectedMarkerPainter(
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
    final Paint paint = Paint();
    canvas.drawImage(priceTagImage, Offset.zero, paint);
    if (price == null) {
      canvas.drawImage(brandLogoImage, const Offset(8, 0), paint);
    }
  }

  @override
  bool shouldRepaint(MCPinSelectedMarkerPainter oldDelegate) {
    return false;
  }
}
