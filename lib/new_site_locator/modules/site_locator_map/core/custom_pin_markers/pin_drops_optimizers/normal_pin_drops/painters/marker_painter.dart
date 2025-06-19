part of site_locator_map_module;

class MarkerPainter extends CustomPainter {
  MarkerPainter(
    this.pinBannerImage,
    this.brandLogoImage, {
    required this.site,
    this.price,
  });

  final double? price;
  final ui.Image pinBannerImage;
  final ui.Image brandLogoImage;
  final Site site;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.drawImage(pinBannerImage, Offset.zero, paint);

    final smallX = pinBannerImage.width * 0.125; // Left side offset
    final smallY = ((pinBannerImage.height / 2) - (brandLogoImage.height / 2)) *
        0.75; // Center vertically

    Offset resultOffset = Offset(smallX, smallY);

    if (price == null || price! <= 0) {
      resultOffset = const Offset(17, 17);

      if (NormalPinDrop.isTopBrand(site.brandLogoIdentifier) &&
          CustomPin.hasBrandLogoIdentifier(site.brandLogoIdentifier)) {
        final cachedItem =
            CustomPin.brandLogosImageCacheStore[site.brandLogoIdentifier];
        if (cachedItem != null) {
          // Offset for pins with price and with logo
          final ofX = (size.width - brandLogoImage.width) / 2;
          final ofY = ((size.height - brandLogoImage.height) / 2) * 0.75;
          resultOffset = Offset(ofX, ofY);
        }
      }
    }
    canvas.drawImage(brandLogoImage, resultOffset, paint);
  }

  @override
  bool shouldRepaint(MarkerPainter oldDelegate) {
    return false;
  }
}
