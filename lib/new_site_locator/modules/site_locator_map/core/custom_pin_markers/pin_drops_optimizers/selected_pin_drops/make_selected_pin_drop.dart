// ignore_for_file: deprecated_member_use

part of site_locator_map_module;

class SelectedPinDrop {
  static Future<BitmapDescriptor> make(Site site) async {
    final type = PinDyeType.pc.name;
    final dyeKey = PinDropDyesCache.dyeKey(site, type, isBig: true);

    return dispatchAfterCache(dyeKey, site);
  }

  static Future<BitmapDescriptor> dispatchAfterCache(
      PinDropDyeKey dyeKey, Site site) async {
    final cachedStore = PinDropDyesCache.selectedPinDyeStore;
    if (cachedStore.containsKey(dyeKey)) {
      return dispatchFinalizedPinDrop(site, cachedStore[dyeKey]!);
    }

    final dyeImage = await makeSelectedPinDropDyeImage(site);
    cachedStore.putIfAbsent(dyeKey, () => dyeImage);

    return dispatchFinalizedPinDrop(site, dyeImage);
  }

  static Future<ui.Image> makeSelectedPinDropDyeImage(Site site) async {
    final double? price = site.price;
    final shopBrandLogoIdentifier = site.brandLogoIdentifier;

    final selectedPinMarkerImage = CustomPin.selectedPinBgForNormalPrice;

    if (site.isServiceStation) {
      return CustomPin.selectedPinServiceStation;
    }

    if (!NormalPinDrop.isTopBrand(shopBrandLogoIdentifier)) {
      return CustomPin.selectedNoLogoFuelPin;
    }

    ui.Image? logoResized;
    ui.Image brandLogoToBePassed;

    bool hasBrandLogo = false;

    if (CustomPin.hasBrandLogoIdentifier(shopBrandLogoIdentifier)) {
      final ui.Image? cachedItem =
          CustomPin.brandLogosImageCacheStore[site.brandLogoIdentifier];

      if (cachedItem != null) {
        final pngByteData =
            await cachedItem.toByteData(format: ui.ImageByteFormat.png);
        if (pngByteData != null) {
          logoResized = await CustomPin.bytesToResizedImage(
            pngByteData,
            BrandLogoSize.big,
            BrandLogoSize.big,
          );
          hasBrandLogo = true;
        }
      }
    }

    if (!hasBrandLogo) {
      return CustomPin.selectedNoLogoFuelPin;
    }
    brandLogoToBePassed = logoResized!;

    // Regular Selected Pin assembler
    final selectedMarkerPainter = SelectedMarkerPainter(
      selectedPinMarkerImage,
      brandLogoToBePassed,
      price: price,
      site: site,
    );

    final width = selectedPinMarkerImage.width.toDouble();
    final height = selectedPinMarkerImage.height.toDouble();
    final widthAsInt = width.floor();
    final heightAsInt = height.floor();

    final pictureRecorder = ui.PictureRecorder();

    final canvas = Canvas(pictureRecorder);

    selectedMarkerPainter.paint(canvas, Size(width, height));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(widthAsInt, heightAsInt);
    return img;
  }

  static Future<BitmapDescriptor> dispatchFinalizedPinDrop(
      Site site, ui.Image dyeImage) async {
    final pinDropByteData =
        await dyeImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(pinDropByteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> writePrice(
      Site site, ui.Image dyeImage) async {
    final pictureRecorder = ui.PictureRecorder();
    ByteData? pinDropByteData;
    final canvas = Canvas(pictureRecorder);
    final pricePainter = MCPinSelectedPinPricePainter(
      site: site,
      dyeImageBg: dyeImage,
    );

    pricePainter.paint(
        canvas, Size(dyeImage.width.toDouble(), dyeImage.height.toDouble()));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(dyeImage.width, dyeImage.height);
    pinDropByteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(pinDropByteData!.buffer.asUint8List());
  }
}
