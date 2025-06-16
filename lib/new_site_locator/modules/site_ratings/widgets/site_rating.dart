part of site_ratings_module;

class SiteRating extends StatelessWidget {
  final SiteRatingController siteRatingController = Get.find();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

  final SiteLocation siteLocation;
  final bool showSeparator;
  final EdgeInsetsGeometry? padding;

  SiteRating(
    this.siteLocation, {
    this.showSeparator = true,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_entitlementRepository.isGoogleRatingEnabled &&
        siteLocation.masterIdentifier.isNotNullEmptyOrWhitespace) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: buildStarRatings(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildStarRatings() {
    return SizedBox(
      child: Obx(
        () {
          if (siteRatingController.siteLocatorController
              .ratingsApiInProgress()) {
            return shimmer();
          } else {
            final ratingEntity =
                siteRatingController.calculateSiteRating(siteLocation);
            final rating = ratingEntity.rate;
            return (rating != null && rating > 0)
                ? _displayRate(
                    rating: ratingEntity.rate, star: ratingEntity.star)
                : _displayNoReviews();
          }
        },
      ),
    );
  }

  Widget _displayRate({required double? rating, required double star}) {
    return Stack(
      children: [
        // grey bg stars
        greyStarsBg(rating: rating),
        Row(
          children: [
            Semantics(
              container: true,
              label: SLSemanticStrings.rating,
              child: StarRating(rating: star),
            ),
            const HorizontalSpacer(size: 4),
            Text(
              '$rating ${showSeparator ? '• ' : ''}${SLViewText.googleRating}',
              style: f14RegularGrey,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  Widget _displayNoReviews() {
    return const Text(
      SLViewText.noReviews,
      style: f14RegularGrey,
    );
  }

  Widget shimmer() {
    return ShimmatorShape.roundedRectangular(width: 140, height: 24);
  }

  Widget greyStarsBg({required double? rating}) {
    return Row(
      children: [
        const StarRating(rating: 5, color: SLInternalText.unratedStarColor),
        const HorizontalSpacer(size: 4),
        Text(
          '$rating',
          style: f12RegularGrey.copyWith(color: Colors.transparent),
        ),
      ],
    );
  }
}
