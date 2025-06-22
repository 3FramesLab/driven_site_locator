part of site_locator_map_module;

class MCPinSelectedPinPricePainter extends CustomPainter {
  MCPinSelectedPinPricePainter({
    required this.site,
    required this.dyeImageBg,
  });

  final ui.Image dyeImageBg;
  final Site site;

  @override
  void paint(Canvas canvas, Size size) {
    final price = site.price;
    final Paint paint = Paint();
    canvas.drawImage(dyeImageBg, Offset.zero, paint);
    final priceTextColor = site.hasDiscount ? Colors.black : Colors.white;

    final textStyle = CustomPin.priceStyle.copyWith(
      color: priceTextColor,
      fontSize: CustomPin.priceNot10(price) ? 38 : 28,
    );

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

      final dx = (((size.width) - textPainter.width) * 0.5) - 0;
      final dy = ((size.height - textPainter.height) * 0.33) - 0;

      final offset = Offset(dx, dy);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(MCPinSelectedPinPricePainter oldDelegate) {
    return false;
  }
}
