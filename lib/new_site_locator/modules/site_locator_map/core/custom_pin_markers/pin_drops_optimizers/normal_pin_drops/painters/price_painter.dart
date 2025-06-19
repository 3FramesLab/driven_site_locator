part of site_locator_map_module;

class PinPricePainter extends CustomPainter {
  PinPricePainter({
    required this.site,
    required this.dyeImageBg,
    this.isLowestFuelPrice = false,
  });

  final Site site;
  final ui.Image dyeImageBg;
  final bool isLowestFuelPrice;

  @override
  void paint(Canvas canvas, Size size) {
    double? price;
    if (site.price != null) {
      price = double.tryParse(site.price!.toStringAsFixed(2));
    }
    final textStyle = CustomPin.priceStyle.copyWith(
      // color: priceTextColor,
      // fontSize: CustomPin.priceNot10(price) ? 39.5 : 24,
      color: Colors.black,
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
        text: '\$${price.toStringAsFixed(2)}',
        style: textStyle,
        children: isLowestFuelPrice ? [lowestTextSpan] : [],
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(
          maxWidth: size.width,
        );

      // Offset for pins with price and no logo
      Offset offset = Offset(
        (size.width - textPainter.width) / 2,
        ((size.height - textPainter.height) / 2) * 0.9,
      );

      if (NormalPinDrop.isTopBrand(site.brandLogoIdentifier) &&
          CustomPin.hasBrandLogoIdentifier(site.brandLogoIdentifier)) {
        final cachedItem =
            CustomPin.brandLogosImageCacheStore[site.brandLogoIdentifier];
        if (cachedItem != null) {
          // Offset for pins with price and with logo
          offset = Offset(
            (size.width) * 0.4,
            ((size.height - textPainter.height) / 2) * 0.9,
          );
        }
      }

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(PinPricePainter oldDelegate) {
    return false;
  }
}
