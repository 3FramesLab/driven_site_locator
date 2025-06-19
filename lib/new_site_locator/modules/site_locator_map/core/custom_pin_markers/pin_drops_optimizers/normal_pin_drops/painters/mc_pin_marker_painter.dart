part of site_locator_map_module;

class MCPinMarkerPainter extends CustomPainter {
  MCPinMarkerPainter(
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
      canvas.drawImage(brandLogoImage, const Offset(10, -8), paint);
    }
  }

  @override
  bool shouldRepaint(MCPinMarkerPainter oldDelegate) {
    return false;
  }
}
