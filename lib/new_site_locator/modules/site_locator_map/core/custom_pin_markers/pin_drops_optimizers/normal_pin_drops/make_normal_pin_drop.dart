// ignore_for_file: deprecated_member_use

part of site_locator_map_module;

class NormalPinDrop {
  static Future<BitmapDescriptor> make(
    Site site, {
    bool isLowestFuelPrice = false,
  }) async {
    final type = PinDyeType.pc.name;
    final dyeKey = PinDropDyesCache.dyeKey(
      site,
      type,
      hasLowestFuelPrice: isLowestFuelPrice,
    );

    return dispatchAfterCache(
      dyeKey,
      site,
      isLowestFuelPrice: isLowestFuelPrice,
    );
  }

  static Future<BitmapDescriptor> dispatchAfterCache(
    PinDropDyeKey dyeKey,
    Site site, {
    bool isLowestFuelPrice = false,
  }) async {
    final cachedStore = PinDropDyesCache.normalPinDyeStore;

    if (cachedStore.containsKey(dyeKey)) {
      return dispatchFinalizedPinDrop(
        site,
        cachedStore[dyeKey]!,
        isLowestFuelPrice: isLowestFuelPrice,
      );
    }
    // Caching DyeImage Bg
    final dyeImage = await makePinDropDyeImage(
      site,
      isLowestFuelPrice: isLowestFuelPrice,
    );
    cachedStore.putIfAbsent(dyeKey, () => dyeImage);

    return dispatchFinalizedPinDrop(
      site,
      dyeImage,
      isLowestFuelPrice: isLowestFuelPrice,
    );
  }

  static Future<ui.Image> makePinDropDyeImage(
    Site site, {
    bool isLowestFuelPrice = false,
  }) async {
    ui.Image bannerPinMarkerImageBg;
    final double? price = CustomPin.fuelPriceOnPinDrop(site);

    final String? shopBrandLogoIdentifier = site.brandLogoIdentifier;

    if (site.isServiceStation) {
      return CustomPin.normalPinServiceStation;
    }
    if (!isTopBrand(shopBrandLogoIdentifier) &&
        (site.price != null && site.price! > 0)) {
      if (isLowestFuelPrice) {
        return CustomPin.lowestPriceNoLogoBg;
      }
      return CustomPin.normalPriceNoLogoBg;
    }
    if (!isTopBrand(shopBrandLogoIdentifier) &&
        (site.price == null || site.price! <= 0)) {
      return CustomPin.normalPinNoLogoNoPrice;
    }

    ui.Image? logoResized;
    ui.Image brandLogoToBePassed;
    CustomPin.defaultBrandLogoSmall =
        DefaultBrandLogos.small ?? await CustomPin.getDefaultLogoSmall();

    if (CustomPin.hasBrandLogoIdentifier(shopBrandLogoIdentifier)) {
      final cachedItem =
          CustomPin.brandLogosImageCacheStore[shopBrandLogoIdentifier];
      if (cachedItem != null) {
        logoResized = await CustomPin.getResizedBrandLogoSmall(cachedItem);
      }

      if (logoResized == null) {
        if (site.price != null && site.price! >= 0) {
          if (isLowestFuelPrice) {
            return CustomPin.lowestPriceNoLogoBg;
          }
          return CustomPin.normalPriceNoLogoBg;
        } else {
          return CustomPin.normalPinNoLogoNoPrice;
        }
      }

      // TODO(Smeet): May be required for the future use-case
      // brandLogoToBePassed = logoResized ?? CustomPin.defaultBrandLogoSmall;
      brandLogoToBePassed = logoResized;
    } else {
      // TODO(Smeet): May be required for the future use-case
      // brandLogoToBePassed = CustomPin.defaultBrandLogoSmall;
      if (isLowestFuelPrice) {
        return CustomPin.lowestPriceNoLogoBg;
      }
      return CustomPin.normalPriceNoLogoBg;
    }

    if (price == null || price <= 0) {
      bannerPinMarkerImageBg = CustomPin.normalPinNoPriceWithLogo;
    } else {
      bannerPinMarkerImageBg = CustomPin.normalBannerPinBg;
      if (isLowestFuelPrice) {
        bannerPinMarkerImageBg = CustomPin.lowestPriceBannerPinBg;
      }
    }

    final pictureRecorder = ui.PictureRecorder();
    ui.Image? pinDropImage;

    // ignore: join_return_with_assignment
    pinDropImage = await RegularPinDropPrepWork.normalPinDropImage(
      pictureRecorder: pictureRecorder,
      bannerPinMarkerImageBg: bannerPinMarkerImageBg,
      brandLogoToBePassed: brandLogoToBePassed,
      price: price,
      site: site,
    );

    return pinDropImage;
  }

  static Future<BitmapDescriptor> dispatchFinalizedPinDrop(
    Site site,
    ui.Image dyeImage, {
    bool isLowestFuelPrice = false,
  }) async {
    if (hasPrice(site)) {
      return writePrice(
        site,
        dyeImage,
        isLowestFuelPrice: isLowestFuelPrice,
      );
    }
    return uiImageToBitMap(dyeImage);
  }

  static bool hasPrice(Site site) {
    final price = site.price;
    return price != null && price > 0;
  }

  static Future<BitmapDescriptor> writePrice(
    Site site,
    ui.Image dyeImage, {
    bool isLowestFuelPrice = false,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    ByteData? pinDropByteData;
    final canvas = Canvas(pictureRecorder);
    final pinPricePainter = PinPricePainter(
      site: site,
      dyeImageBg: dyeImage,
      isLowestFuelPrice: isLowestFuelPrice,
    );
    pinPricePainter.paint(
      canvas,
      Size(dyeImage.width.toDouble(), dyeImage.height.toDouble()),
    );

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(dyeImage.width, dyeImage.height);
    pinDropByteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(pinDropByteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> uiImageToBitMap(ui.Image uiImage) async {
    final pinDropByteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(pinDropByteData!.buffer.asUint8List());
  }

  static bool isTopBrand(String? brand) {
    if (UmaSLProperties.topFuelBrands.isEmpty) {
      return true;
    }
    final flag = UmaSLProperties.topFuelBrands.contains(brand);
    return flag;
  }
}
