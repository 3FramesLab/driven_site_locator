import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/controllers/site_locator_token_controller.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locations_service.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locator_access_token_service.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_controller.dart';
import 'package:driven_site_locator/site_locator/modules/cardholder_setup/cardholder_setup_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/painter.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/use_cases/pin_drop_image_path_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

int cacheStartingTime = 0;

class CustomPin {
  static bool remoteBrandLogo = true;

  static late ui.Image defaultBrandLogoSmall;
  static late ui.Image defaultBrandLogoBig;
  static late ui.Image normalPinBg;
  static late ui.Image discountPinBg;
  static late ui.Image normalBannerPinBg;
  static late ui.Image discountBannerPinBg;
  static late ui.Image selectedPinBgForNormalPrice;
  static late ui.Image selectedPinBgForDiscountPrice;
  static Map<String, ui.Image> brandLogosImageCacheStore = {};
  static Map<String, String> brandLogosBase64CacheStore = {};
  static late ui.Image clusterImage;

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
    Get.lazyPut(CardholderSetupController.new);
    Get.lazyPut(SitesLoadingProgressController.new);
  }

  static Future<void> preCache({bool canCacheAllLogos = true}) async {
    brandLogosImageCacheStore = {};
    brandLogosBase64CacheStore = {};

    defaultBrandLogoSmall =
        await defaultLogo(BrandLogoSize.small, BrandLogoSize.small);
    defaultBrandLogoBig =
        await defaultLogo(BrandLogoSize.big, BrandLogoSize.big);
    normalPinBg = await pinDropImageBg(hasDiscount: false);
    discountPinBg = await pinDropImageBg(hasDiscount: true);
    normalBannerPinBg = await bannerPinImageBg(hasDiscount: false);
    discountBannerPinBg = await bannerPinImageBg(hasDiscount: true);
    selectedPinBgForNormalPrice = await getBigPinBgImage(hasDiscount: false);
    selectedPinBgForDiscountPrice = await getBigPinBgImage(hasDiscount: true);
    cacheStartingTime = DateTime.now().millisecondsSinceEpoch;
    clusterImage = await _getClusterImage();

    if (AppUtils.isComdata) {
      normalPinBg = await pinDropImageBg(hasGallonUp: false);
      discountPinBg = await pinDropImageBg(hasGallonUp: true);
      normalBannerPinBg = await bannerPinImageBg(hasGallonUp: false);
      discountBannerPinBg = await bannerPinImageBg(hasGallonUp: true);
      selectedPinBgForNormalPrice = await getBigPinBgImage(hasGallonUp: false);
      selectedPinBgForDiscountPrice = await getBigPinBgImage(hasGallonUp: true);
    }

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
    Globals().dynatrace.tagUser('Fuelman Brandlogo caching');
    Globals().dynatrace.tagEvent(timeLogValue);
    if (kDebugMode) {
      log(timeLogValue);
    }
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
    } on Exception catch (e) {
      var errorMessage = DynatraceErrorMessages.getBrandLogosErrorName;
      if (e is ErrorResponse) {
        errorMessage = e.errorSummary ?? errorMessage;
      }
      Globals().dynatrace.logError(
            name: DynatraceErrorMessages.getBrandLogosErrorValue,
            value: errorMessage,
          );
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
      final imageResized = await unit8ListBytesToImageConverter(imageBytes);
      brandLogosImageCacheStore.putIfAbsent(key, () => imageResized);
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

  static Future<ui.Image> defaultLogo(int width, int height) async {
    ByteData defaultLogoByteData =
        await rootBundle.load(SiteLocatorConfig.defaultBrandLogoPath);
    // DFC Asset updates
    if (AppUtils.isComdata) {
      defaultLogoByteData = await rootBundle
          .load(SiteLocatorConfig.defaultComdataSiteBrandLogoPath);
    }

    return bytesToResizedImage(defaultLogoByteData, width, height);
  }

  static Future<ui.Image> pinDropImageBg(
      {bool? hasDiscount, bool? hasGallonUp}) async {
    final param = PindropImagePathUseCaseParam(
      hasDiscount: hasDiscount ?? false,
      hasGallonUp: hasGallonUp ?? false,
    );
    final pinDropImageBgPath = pindropImagePathUseCase.execute(param);
    final ByteData imageByteData = await rootBundle.load(pinDropImageBgPath);

    final Uint8List assetImageByteData = imageByteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: PinDropSize.width,
      targetHeight: PinDropSize.height,
    );
    final logoImage = (await codec.getNextFrame()).image;
    return logoImage;
  }

  static Future<ui.Image> bannerPinImageBg(
      {bool? hasDiscount, bool? hasGallonUp}) async {
    final param = PindropImagePathUseCaseParam(
      type: PinDropImageType.bannerPinDropBg,
      hasDiscount: hasDiscount ?? false,
      hasGallonUp: hasGallonUp ?? false,
    );
    final bannerPinImageBgPath = pindropImagePathUseCase.execute(param);
    final ByteData bgBannerByte = await rootBundle.load(bannerPinImageBgPath);

    final Uint8List bgImageByteData = bgBannerByte.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      bgImageByteData.buffer.asUint8List(),
      targetWidth: PinDropBannerSize.width,
      targetHeight: PinDropBannerSize.height,
    );
    final bannerPinMarkerImageBg = (await codec.getNextFrame()).image;
    return bannerPinMarkerImageBg;
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
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: PinDropBigSize.width,
      targetHeight: PinDropBigSize.height,
    );
    return (await codec.getNextFrame()).image;
  }

  static Future<BitmapDescriptor> selectedMarker(Site site) async {
    final String? price = site.price;
    final hasDiscount =
        AppUtils.isComdata ? site.hasGallonUp : site.hasDiscount;
    final shopBrandLogoIdentifier = site.brandLogoIdentifier;
    final selectedPinMarkerImage = hasDiscount
        ? selectedPinBgForDiscountPrice
        : selectedPinBgForNormalPrice;

    ui.Image? logoResized;
    ui.Image brandLogoToBePassed;
    if (hasBrandLogoIdentifier(shopBrandLogoIdentifier)) {
      final ui.Image? cachedItem =
          brandLogosImageCacheStore[site.brandLogoIdentifier];

      if (cachedItem != null) {
        final pngByteData =
            await cachedItem.toByteData(format: ImageByteFormat.png);
        if (pngByteData != null) {
          logoResized = await bytesToResizedImage(
            pngByteData,
            BrandLogoSize.big,
            BrandLogoSize.big,
          );
        }
      } else {
        logoResized = defaultBrandLogoBig;
      }
    } else {
      brandLogoToBePassed = defaultBrandLogoBig;
    }
    brandLogoToBePassed = logoResized ?? defaultBrandLogoBig;

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
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<ui.Image?> getResizedBrandLogoSmall(
      ui.Image logoImageBig) async {
    ui.Image? resizedLogoSmall;
    Codec? codec;
    final byteData = await logoImageBig.toByteData(format: ImageByteFormat.png);
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

  static Future<BitmapDescriptor> normalMarker(Site site) async {
    ui.Image bannerPinMarkerImageBg;
    final String? price = site.price;
    final hasDiscount =
        AppUtils.isComdata ? site.hasGallonUp : site.hasDiscount;

    final String? shopBrandLogoIdentifier = site.brandLogoIdentifier;
    ui.Image? logoResized;
    ui.Image brandLogoToBePassed;

    if (hasBrandLogoIdentifier(shopBrandLogoIdentifier)) {
      final logoImageCachedBig =
          brandLogosImageCacheStore[shopBrandLogoIdentifier];
      if (logoImageCachedBig != null) {
        logoResized = await getResizedBrandLogoSmall(logoImageCachedBig);
      }
    } else {
      brandLogoToBePassed = defaultBrandLogoSmall;
    }
    brandLogoToBePassed = logoResized ?? defaultBrandLogoSmall;

    if (price == null) {
      bannerPinMarkerImageBg = hasDiscount ? discountPinBg : normalPinBg;
    } else {
      bannerPinMarkerImageBg =
          hasDiscount ? discountBannerPinBg : normalBannerPinBg;
    }

    final width = bannerPinMarkerImageBg.width.toDouble();
    final height = bannerPinMarkerImageBg.height.toDouble();
    final widthAsInt = width.floor();
    final heightAsInt = height.floor();

    final pictureRecorder = ui.PictureRecorder();

    final canvas = Canvas(pictureRecorder);
    final markerPainter = MarkerPainter(
      bannerPinMarkerImageBg,
      brandLogoToBePassed,
      price: price,
      site: site,
    );
    markerPainter.paint(canvas, Size(width, height));

    final recordedPicture = pictureRecorder.endRecording();
    final img = await recordedPicture.toImage(widthAsInt, heightAsInt);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  /// Paints the Cluster Count Text
  static Future<ui.Image> _getClusterImage() async {
    const logoBgPath = SiteLocatorAssets.icClusterMarker;
    final ByteData bigPinBgByteData = await rootBundle.load(logoBgPath);

    final Uint8List assetImageByteData = bigPinBgByteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetWidth: ClusterSize.width,
      targetHeight: ClusterSize.height,
    );
    return (await codec.getNextFrame()).image;
  }

  static Future<BitmapDescriptor> getMarkerBitmap(
    int size, {
    String? text,
    Site? site,
  }) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    if (site == null) {
      canvas.drawImage(clusterImage, Offset.zero, Paint());
      _paintText(
        canvas,
        Colors.white,
        text != null ? _getClusterCount(text) : '',
        size,
      );
    } else {
      return normalMarker(site);
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static void _paintText(Canvas canvas, Color color, String text, int size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: text,
      style: f26BoldWhite,
    );

    textPainter.layout();
    final dx = (clusterImage.width - textPainter.width) * 0.1;
    final dy = (clusterImage.width - textPainter.height) * 0.17;
    textPainter.paint(
      canvas,
      Offset(dx, dy),
    );
  }

  static String _getClusterCount(String count) {
    String label = count;
    if (count.trim().length > 2) {
      label = '99+';
    }
    return '$label sites ';
  }
}

class BrandLogoSize {
  static int small = 55;
  static int big = 90;
}

class PinDropSize {
  static int width = 90;
  static int height = 105;
}

class PinDropBigSize {
  static int width = 134;
  static int height = 156;
}

class PinDropBannerSize {
  static int width = 230;
  static int height = 105;
}

class ClusterSize {
  static int width = 200;
  static int height = 101;
}
