part of site_ratings_module;

class SiteRatingController extends GetxController {
  final SiteLocatorController siteLocatorController = Get.find();
  late SiteLocationsService siteLocationsService;

  SiteRatingEntity calculateSiteRating(SiteLocation siteLocation) {
    final identifier = siteLocation.masterIdentifier;
    final ratingRaw = siteLocatorController.siteRatingCacheStore()[identifier];
    final starCount = getStarsCount(ratingRaw);
    return SiteRatingEntity(star: starCount, rate: ratingRaw);
  }

  double getStarsCount(double? value) {
    // Stars display strategy
    // Decimals upto 0.2 no half stars
    // Decimals from 0.3 to 0.7 half stars
    // Decimals > 0.8 full stars
    if (value != null) {
      final rawValue = value;
      final intValue = rawValue.toInt();
      final d = rawValue - intValue;
      double result = 0;
      if (d < 0.3) {
        result = intValue.toDouble();
      } else if (d >= 0.3 && d < 0.8) {
        result = intValue.toDouble() + 0.5;
      } else {
        result = intValue.toDouble() + 1;
      }

      return result > 5 ? 5 : result;
    }
    return PlaceRatingEntity.noRating;
  }
}
