// ignore_for_file: deprecated_member_use

part of site_locator_map_module;

int cacheStartingTime = 0;

class CustomPin {
  static bool remoteBrandLogo = true;

  static late ui.Image normalBannerPinBg;
  static late ui.Image lowestPriceBannerPinBg;
  static late ui.Image discountBannerPinBg;
  static late ui.Image selectedPinBgForNormalPrice;
  static late ui.Image selectedPinBgForDiscountPrice;

  static late ui.Image normalPinNoPriceWithLogo;
  static late ui.Image normalPriceNoLogoBg;
  static late ui.Image lowestPriceNoLogoBg;
  static late ui.Image normalPinNoLogoNoPrice;
  static late ui.Image normalMCPinNoLogoNoPrice;
  static late ui.Image normalPinServiceStation;
  static late ui.Image selectedPinServiceStation;
  static late ui.Image selectedNoLogoFuelPin;

  static late ui.Image clusterImage;
  static late ui.Image clusterLowest;
  static Map<String, ui.Image> brandLogosImageCacheStore = {};

  static const priceStyle = TextStyle(
    fontFamily: DrivenFonts.avertaFontFamily,
    fontWeight: FontWeight.bold,
  );

  static final pindropImagePathUseCase = Get.put(PindropImagePathUseCase());
  static SiteLocatorAccessTokenService siteLocatorAccessTokenService =
      Get.put(SiteLocatorAccessTokenService());

  static SiteLocatorAccessTokenController siteLocatorAccessTokenController =
      Get.put(SiteLocatorAccessTokenController());

  static SiteLocatorController siteLocatorController =
      Get.put(SiteLocatorController());

  static Future<void> initEvents(
      {bool setup = true, bool canCacheAllLogos = true}) async {
    bindAdhocDependencies();
    brandLogosImageCacheStore = {};
    if (setup) {
      await preCache(canCacheAllLogos: canCacheAllLogos);
    }
  }

  static void bindAdhocDependencies() {
    // Get.lazyPut(CardholderSetupController.new);
    Get.lazyPut(SitesLoadingProgressController.new);
  }

  static Future<void> preCache({bool canCacheAllLogos = true}) async {
    await preCacheSiteLocatorAssets();
    await preCacheBrandLogosAssets(canCacheAllLogos: canCacheAllLogos);
  }

  static Future<void> preCacheSiteLocatorAssets() async {
    normalBannerPinBg = await bannerPinImageBg(hasDiscount: false);
    lowestPriceBannerPinBg = await bannerPinImageBg(hasLowestFuelPrice: true);
    discountBannerPinBg = await bannerPinImageBg(hasDiscount: true);
    selectedPinBgForNormalPrice = await getBigPinBgImage(hasDiscount: false);
    selectedPinBgForDiscountPrice = await getBigPinBgImage(hasDiscount: true);

    normalPriceNoLogoBg = await normalPriceNoLogoBgImage();
    lowestPriceNoLogoBg = await normalPriceNoLogoBgImage(hasLowestPrice: true);
    normalPinNoLogoNoPrice = await normalPinNoLogoNoPriceImage();
    normalMCPinNoLogoNoPrice = await normalMCPinNoLogoNoPriceImage();
    normalPinServiceStation = await normalServicePinImage();
    normalPinNoPriceWithLogo = await normalPinNoPriceWithLogoPinImage();
    selectedPinServiceStation = await selectedNoLogoNoPricePinImage(
      SLAssets.selectedServicePinFilePathDFC,
    );
    selectedNoLogoFuelPin = await selectedNoLogoNoPricePinImage(
      SLAssets.selectedNoLogoFuelPinFilePathDFC,
    );

    cacheStartingTime = DateTime.now().millisecondsSinceEpoch;
    clusterImage = await _getClusterImage(SLAssets.clusterRegular);
    clusterLowest = await _getClusterImage(SLAssets.clusterLowest);
  }

  static Future<void> preCacheBrandLogosAssets(
      {bool canCacheAllLogos = true}) async {
    brandLogosImageCacheStore = {};
    if (canCacheAllLogos) {
      await preCacheAllBrandLogos();
      trackDuration(cacheStartingTime);
    }
  }

  /// ****  PRECACHE STARTS */
  static void trackDuration(int startingTime) {
    final int trackedTime =
        DateTime.now().millisecondsSinceEpoch - startingTime;
    final timeLogValue =
        'Brand logo cache event duration: ${trackedTime.toString()}';
    Globals().dynatrace.tagEvent(timeLogValue);
  }

  static Future<void> preCacheAllBrandLogos() async {
    final SiteLocationsService siteLocationsService =
        Get.put(SiteLocationsService());
    List<dynamic> urlStoreList = [];

    try {
      final accessToken = await siteLocatorController.getAccessTokenForSites();
      urlStoreList = await siteLocationsService.fetchBrandLogoUrls(
              headerQueryParams: accessToken) ??
          [];
    } on Exception catch (_) {
      //   var errorMessage = DynatraceErrorMessages.getBrandLogosErrorName;
      //   if (e is ErrorResponse) {
      //     errorMessage = e.errorSummary ?? errorMessage;
      //   }
      //   Globals.dynatrace.logError(
      //     name: DynatraceErrorMessages.getBrandLogosErrorValue,
      //     value: errorMessage,
      //   );
    }
    processCachingBrandLogos(urlStoreList);
  }

  static void processCachingBrandLogos(List<dynamic> urlStoreList) {
    for (int i = 0; i < urlStoreList.length; i++) {
      final Map<String, dynamic> urlHash =
          urlStoreList[i] as Map<String, dynamic>;
      final String key = urlHash.keys.first;
      final String url = urlHash[key] ?? '';
      if (url.isNotEmpty) {
        unawaited(cachingImageFromNetwork(url, key));
      }
    }
  }

  static Future<void> cacheBrandLogo(String key, Uint8List? imageBytes) async {
    if (imageBytes != null) {
      try {
        final imageResized = await unit8ListBytesToImageConverter(imageBytes);
        brandLogosImageCacheStore.putIfAbsent(key, () => imageResized);
      } catch (_) {
        Globals().dynatrace.logError(
              name: 'Invalid Image',
              value: 'Invalid Image unit8ListBytesToImageConverter',
            );
      }
    }
  }

  static Future<void> cachingImageFromNetwork(
      String logoUrl, String key) async {
    try {
      final http.Response? responseData = await http.get(Uri.parse(logoUrl));
      final Uint8List? imageBytes = responseData?.bodyBytes;
      unawaited(cacheBrandLogo(key, imageBytes));
    } catch (_) {}
  }

  static Future<ui.Image> unit8ListBytesToImageConverter(
      Uint8List byteData) async {
    final codec = await ui.instantiateImageCodec(
      byteData,
      targetWidth: BrandLogoSize.big,
      targetHeight: BrandLogoSize.big,
    );
    final logoImage = (await codec.getNextFrame()).image;
    return logoImage;
  }

  /// **** PRECACHE ENDS */

  static Future<void> cachingBrandLogoStore(
      ByteData byteData, String key) async {
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: BrandLogoSize.small,
      targetHeight: BrandLogoSize.small,
    );

    final logoImage = (await codec.getNextFrame()).image;
    brandLogosImageCacheStore.putIfAbsent(key, () => logoImage);
  }

  static Future<ui.Image> bytesToResizedImage(
      ByteData byteData, int width, int height) async {
    final Uint8List assetImageByteData = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: width,
    );
    final logoImage = (await codec.getNextFrame()).image;
    return logoImage;
  }

  static Future<ui.Image> pinDropImageBg({
    bool? hasDiscount,
    bool? hasGallonUp,
    bool hasLowestFuelPrice = false,
  }) async {
    final param = PindropImagePathUseCaseParam(
      hasDiscount: hasDiscount ?? false,
      hasGallonUp: hasGallonUp ?? false,
      hasLowestFuelPrice: hasLowestFuelPrice,
    );
    final pinDropImageBgPath = pindropImagePathUseCase.execute(param);
    final ByteData imageByteData = await rootBundle.load(pinDropImageBgPath);

    final Uint8List assetImageByteData = imageByteData.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: getPinDropImageBgWidth(),
      targetHeight: getPinDropImageBgHeight(),
    );
    final logoImage = (await codec.getNextFrame()).image;
    return logoImage;
  }

  static int getPinDropImageBgWidth() {
    return PinDropSize.width;
  }

  static int getPinDropImageBgHeight() {
    return PinDropSize.height;
  }

  static Future<ui.Image> bannerPinImageBg({
    bool? hasDiscount,
    bool? hasGallonUp,
    bool hasLowestFuelPrice = false,
  }) async {
    final param = PindropImagePathUseCaseParam(
      type: PinDropImageType.bannerPinDropBg,
      hasDiscount: hasDiscount ?? false,
      hasGallonUp: hasGallonUp ?? false,
      hasLowestFuelPrice: hasLowestFuelPrice,
    );
    final bannerPinImageBgPath = pindropImagePathUseCase.execute(param);
    final ByteData bgBannerByte = await rootBundle.load(bannerPinImageBgPath);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: getBannerPinImageBgWidth(),
      targetHeight: getBannerPinImageBgHeight(),
    );
    final bannerPinMarkerImageBg = (await codec.getNextFrame()).image;
    return bannerPinMarkerImageBg;
  }

  static Future<ui.Image> normalPriceNoLogoBgImage({
    bool hasLowestPrice = false,
  }) async {
    String path = SLAssets.normalNoLogoFilePathDFC;
    if (hasLowestPrice) {
      path = SLAssets.lowestPriceNoLogoPinDrop;
    }
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: hasLowestPrice
          ? NewLowestPinDropNoLogoBannerSize.width
          : NewPinDropNoLogoBannerSize.width,
      targetHeight: hasLowestPrice
          ? NewLowestPinDropNoLogoBannerSize.height
          : NewPinDropNoLogoBannerSize.height,
    );
    final normalPriceNoLogoBg = (await codec.getNextFrame()).image;
    return normalPriceNoLogoBg;
  }

  static Future<ui.Image> normalPinNoLogoNoPriceImage() async {
    const path = SLAssets.normalPinNoLogoNoPriceFilePathDFC;
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: NewServicePinDropSize.width,
      targetHeight: NewServicePinDropSize.height,
    );
    final normalPinNoLogoNoPriceImage = (await codec.getNextFrame()).image;
    return normalPinNoLogoNoPriceImage;
  }

  static Future<ui.Image> normalMCPinNoLogoNoPriceImage() async {
    const path = SLAssets.normalMCPinNoLogoNoPriceFilePathDFC;
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: PinDropSize.width,
      targetHeight: PinDropSize.height,
    );
    final mcPinImage = (await codec.getNextFrame()).image;
    return mcPinImage;
  }

  static Future<ui.Image> normalServicePinImage() async {
    const path = SLAssets.normalServicePinFilePathDFC;
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: NewServicePinDropSize.width,
      targetHeight: NewServicePinDropSize.height,
    );
    final servicePinImage = (await codec.getNextFrame()).image;
    return servicePinImage;
  }

  static Future<ui.Image> normalPinNoPriceWithLogoPinImage() async {
    const path = SLAssets.normalPinNoPriceWithLogo;
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 121,
    );
    final servicePinImage = (await codec.getNextFrame()).image;
    return servicePinImage;
  }

  static Future<ui.Image> selectedNoLogoNoPricePinImage(String path) async {
    final ByteData bgBannerByte = await rootBundle.load(path);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: NewPinDropSelectedSize.width,
      targetHeight: NewPinDropSelectedSize.height,
    );

    return (await codec.getNextFrame()).image;
  }

  static int getBannerPinImageBgWidth() {
    return NewPinDropBannerSize.width;
  }

  static int getBannerPinImageBgHeight() {
    return NewPinDropBannerSize.height;
  }

  static Future<ui.Image> getBigPinBgImage(
      {bool? hasDiscount, bool? hasGallonUp}) async {
    final param = PindropImagePathUseCaseParam(
      type: PinDropImageType.bigPinDropBg,
      hasDiscount: hasDiscount ?? false,
      hasGallonUp: hasGallonUp ?? false,
    );
    final bigPinBgImagePath = pindropImagePathUseCase.execute(param);

    final ByteData bigPinBgByteData = await rootBundle.load(bigPinBgImagePath);

    final Uint8List assetImageByteData = bigPinBgByteData.buffer.asUint8List();

    final width = NewPinDropSelectedSize.width;
    final height = NewPinDropSelectedSize.height;

    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    return (await codec.getNextFrame()).image;
  }

  static Future<BitmapDescriptor> selectedPinMarker(Site site) async {
    return SelectedPinDrop.make(site);
  }

  static Future<ui.Image?> getResizedBrandLogoSmall(
      ui.Image logoImageBig) async {
    ui.Image? resizedLogoSmall;
    ui.Codec? codec;
    final byteData =
        await logoImageBig.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: BrandLogoSize.small,
        targetHeight: BrandLogoSize.small,
      );
    }

    if (codec != null) {
      resizedLogoSmall = (await codec.getNextFrame()).image;
    }
    return resizedLogoSmall;
  }

  static bool hasBrandLogoIdentifier(String? shopBrandLogoIdentifier) =>
      (shopBrandLogoIdentifier?.isNotEmpty ?? false) && remoteBrandLogo;

  static double? fuelPriceOnPinDrop(Site site) => site.price;

  static Future<BitmapDescriptor> normalPinMarker(Site site) async {
    return NormalPinDrop.make(site);
  }

  // TODO(Smeet): may be use later
  // static Future<ui.Image> bytesToImage(ByteData byteData) async {
  //   final Uint8List assetImageByteData = byteData.buffer.asUint8List();
  //   final codec = await ui.instantiateImageCodec(
  //     assetImageByteData.buffer.asUint8List(),
  //   );
  //   final logoImage = (await codec.getNextFrame()).image;
  //   return logoImage;
  // }

  static bool priceNot10(double? price) =>
      price != null && price.toString().length < 5;

  /// Paints the Cluster Count Text
  static Future<ui.Image> _getClusterImage(String logoBgPath) async {
    final ByteData bigPinBgByteData = await rootBundle.load(logoBgPath);

    final Uint8List assetImageByteData = bigPinBgByteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: ClusterSize.width,
      targetHeight: ClusterSize.height,
    );
    return (await codec.getNextFrame()).image;
  }

  static Future<BitmapDescriptor> getClusterBitmap({
    String? text,
    Site? site,
    double? lowestFuelPrice,
    double? bestPriceInCluster,
  }) async {
    if (lowestFuelPrice == null && bestPriceInCluster == null) {
      return _createClusterMarker(
        count: text == null ? '' : _getClusterCount(text),
      );
    }
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const labelColor = DrivenColors.black;

    if (site == null) {
      canvas.drawImage(
        lowestFuelPrice == null ? clusterImage : clusterLowest,
        Offset.zero,
        Paint(),
      );
      _paintClusterCount(
        canvas,
        labelColor,
        text != null ? _getClusterCount(text) : '',
        0,
        lowestFuelPrice: bestPriceInCluster ?? lowestFuelPrice,
        isBestPrice: bestPriceInCluster != null,
      );
    } else {
      return normalPinMarker(site);
    }

    final img = await pictureRecorder.endRecording().toImage(
          clusterImage.width,
          clusterImage.height,
        );
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> _createClusterMarker({
    required String count,
    double size = 110,
    Color borderColor = DrivenColors.black,
    Color backgroundColor = DrivenColors.white,
    double borderWidth = 7,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Define the size and center of the marker
    final double radius = size / 2;
    final Offset center = Offset(radius, radius);

    // Clear the canvas with transparent background
    canvas.clipRect(Rect.fromLTWH(0, 0, size, size));

    // Create paint for the border (black background circle)
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = false; // Disable anti-aliasing to prevent gray edges

    // Create paint for the main circle (white)
    final Paint circlePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = false; // Disable anti-aliasing to keep white pure

    // Draw the border circle (larger, black)
    canvas.drawCircle(center, radius - 1, borderPaint);

    // Draw the main circle (smaller, white) - this creates the border effect
    canvas.drawCircle(center, radius - borderWidth, circlePaint);

    // Create text painter for the cluster count
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: count,
        style: f26BoldBlack.copyWith(
          fontSize: _getFontSizeForClusterCount(count),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position to center the text
    final Offset textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    // Draw the text
    textPainter.paint(canvas, textOffset);

    // Convert the canvas to an image with higher pixel density for mobile
    final ui.Picture picture = pictureRecorder.endRecording();
    final int imageSize =
        (size * 2).toInt(); // Double resolution for crisp rendering
    final ui.Image image = await picture.toImage(imageSize, imageSize);

    // Convert the image to bytes
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    // Create and return BitmapDescriptor
    return BitmapDescriptor.fromBytes(bytes);
  }

  static void _paintClusterCount(
    Canvas canvas,
    Color color,
    String text,
    int size, {
    double? lowestFuelPrice,
    bool isBestPrice = false,
  }) {
    bool hasLowestFuelPrice = false;
    if (lowestFuelPrice != null && lowestFuelPrice > 0) {
      hasLowestFuelPrice = true;
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    final textStyle = f26BoldWhite.copyWith(
      color: color,
      fontSize: _getFontSizeForClusterCount(text), // 999+ and 999
    );
    textPainter.text = TextSpan(
      text: text,
      style: textStyle,
    );

    textPainter.layout();

    final dy = _getDyForClusterCount(text);

    final dxNormalCluster = (clusterImage.width - textPainter.width / 2) * dy;
    final dyNormalCluster = (clusterImage.height - textPainter.height) / 2;
    final offSet = Offset(dxNormalCluster, dyNormalCluster);

    textPainter.paint(
      canvas,
      offSet,
    );

    if (hasLowestFuelPrice) {
      _paintClusterLowestPrice(
        canvas: canvas,
        lowestFuelPrice: lowestFuelPrice!,
        isBestPrice: isBestPrice,
      );
    }
  }

  static double _getFontSizeForClusterCount(String count) {
    if (count.length > 3) {
      return 30; // For '999+'
    } else if (count.length == 3) {
      return 36; // For '999'
    } else if (count.length == 2) {
      return 40; // 99
    } else {
      return 45; // Default size for single digit counts
    }
  }

  static double _getDyForClusterCount(String count) {
    if (count.length > 3) {
      return 0.73; // For '999+'
    } else if (count.length == 3) {
      return 0.73; // For '999'
    } else if (count.length == 2) {
      return 0.74; // 99
    } else {
      return 0.755; // Default size for single digit counts
    }
  }

  static void _paintClusterLowestPrice({
    required Canvas canvas,
    required double lowestFuelPrice,
    bool isBestPrice = false,
  }) {
    final priceTextPainter = TextPainter(textDirection: TextDirection.ltr);

    final priceTextStyle = f20BoldBlack.copyWith(
      fontSize: CustomPin.priceNot10(lowestFuelPrice) ? 38 : 24,
      color: isBestPrice ? DrivenColors.white : DrivenColors.black,
    );

    priceTextPainter.text = TextSpan(
      text: '\$${lowestFuelPrice.toStringAsFixed(2)}',
      style: priceTextStyle,
      children: [
        TextSpan(
          text: '\n${isBestPrice ? SLViewText.best : SLViewText.lowest}',
          style: f20SemiBoldBlack.copyWith(
            fontSize: 30,
            color: isBestPrice ? DrivenColors.white : DrivenColors.black,
          ),
        )
      ],
    );

    priceTextPainter.layout();

    final dxPricePainter = (clusterImage.width - priceTextPainter.width) * 0.17;
    final dyPricePainter =
        (clusterImage.width - (priceTextPainter.height / 2)) * 0.08;

    final offset = Offset(dxPricePainter, dyPricePainter);

    priceTextPainter.paint(
      canvas,
      offset,
    );
  }

  static String _getClusterCount(String count) {
    String label = count;
    if (count.trim().length > 3) {
      label = '999+';
    }
    return label;
  }
}

class BrandLogoSize {
  static int small = 48;
  static int big = 90;
}

class PinDropSize {
  static int width = 83;
  static int height = 99;
}

class PinDropBigSize {
  static int width = 134;
  static int height = 156;
}

class PinDropBannerSize {
  static int width = 184;
  static int height = 99;
}

class PinDropNoLogoBannerSize {
  static int width = 119;
  static int height = 99;
}

class NewPinDropNoLogoBannerSize {
  static int width = 150;
  static int height = 119;
}

class NewLowestPinDropNoLogoBannerSize {
  static int width = 158;
  static int height = 125;
}

class NewPinDropBannerSize {
  static int width = 232;
  static int height = 119;
}

class NewServicePinDropSize {
  static int width = 91;
  static int height = 110;
}

class NewPinDropSelectedSize {
  // static int width = 151;
  // static int height = 183;
  static int width = 160;
  static int height = 192;
}

class MCPinDropBannerSize {
  static int width = 100;
  static int height = 90;
}

class MCLogoSize {
  static int small = 80;
  static int big = 120;
}

class ClusterSize {
  static int width = 230;
  static int height = 110;
}
