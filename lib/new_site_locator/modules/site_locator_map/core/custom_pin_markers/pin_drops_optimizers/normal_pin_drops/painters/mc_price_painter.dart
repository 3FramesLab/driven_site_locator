part of site_locator_map_module;

class MCPinPricePainter extends CustomPainter {
  MCPinPricePainter({
    required this.site,
    required this.dyeImageBg,
    this.isLowestFuelPrice = false,
  });

  final Site site;
  final ui.Image dyeImageBg;
  final bool isLowestFuelPrice;

  @override
  void paint(Canvas canvas, Size size) {
    final price = site.price;
    const priceTextColor = Colors.black;
    final textStyle = CustomPin.priceStyle.copyWith(
      color: priceTextColor,
      // fontSize: CustomPin.priceNot10(price) ? 30 : 28,
      fontSize: CustomPin.priceNot10(price) ? 38.5 : 24,
      height: 0.9,
    );

    final Paint paint = Paint();

    canvas.drawImage(dyeImageBg, Offset.zero, paint);
    // if Price available then paint the price banner
    if (price != null) {
      const lowestTextSpan = TextSpan(
        text: '\n${SLViewText.lowest}',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      );

      final textSpan = TextSpan(
        text: '\$$price',
        style: textStyle,
        children: isLowestFuelPrice ? [lowestTextSpan] : [],
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(
          maxWidth: size.width,
        );

      final offset = Offset(
        (size.width - textPainter.width) / 2,
        ((size.height - textPainter.height) / 2) * 0.75,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(MCPinPricePainter oldDelegate) {
    return false;
  }
}
