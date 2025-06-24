// ignore_for_file: must_be_immutable

part of map_view_module;

class SiteInfoPopupBottomContent extends StatelessWidget {
  SiteInfoPopupBottomContent(this.selectedSiteLocation);

  final SLSiteLocatorController siteLocatorController = Get.find();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;
  final SiteLocation selectedSiteLocation;
  String cardAccepted = '';
  List<String> amenities = [];

  void _setCardAccepted() {
    if (_entitlementRepository.isAcceptedCardSectionEnabled) {
      if (DcSiteLocatorUtils.isGuest) {
        cardAccepted = siteLocatorController.getFormattedAcceptedCards(
          selectedSiteLocation,
        );
      }
    }
  }

  void _setAmenities() {
    final amenitiesKeys = selectedSiteLocation.amenities?.split(',') ?? [];
    amenitiesKeys.removeWhere((e) => e == SLInternalText.gallonUpFeeKey);

    if (UmaSLProperties.showAllAmenities) {
      amenities = amenitiesKeys
          .map((key) =>
              UmaSLProperties.merchSiteAmenitiesMapping[key.trim()] ??
              key.trim())
          .toSet()
          .toList();
    } else {
      for (final key in amenitiesKeys) {
        final trimmedKey = key.trim();
        final value = UmaSLProperties.merchSiteAmenitiesMapping[trimmedKey];
        final isInFilters = UmaSLProperties.filters.any(
          (filter) => filter.filters.any(
            (subFilter) => subFilter.keys.contains(trimmedKey),
          ),
        );
        if (isInFilters && value.isNotNullEmptyOrWhitespace) {
          amenities.add(value!);
        }
      }
      amenities = amenities.toSet().toList();
    }

    amenities.sort();
  }

  @override
  Widget build(BuildContext context) {
    _setCardAccepted();
    _setAmenities();
    return _popupBottomContent(context);
  }

  Widget _popupBottomContent(context) {
    return Column(
      children: [
        _amenityRow(context),
        const SizedBox(height: 2),
        _amenitiesDescription(),
        _cardAcceptedView,
      ],
    );
  }

  Widget _amenityRow(context) {
    return Row(
      children: [
        _amenities(),
        const Spacer(),
        _time,
      ],
    );
  }

  Widget _amenitiesDescription() {
    return Align(
      alignment: Alignment.centerLeft,
      child: amenities.isEmpty
          ? const SubTitleText(
              title: SLViewText.amenitiesAndFeatureNotAvailable,
              fontSize: 16,
            )
          : _amenitiesGrid(),
    );
  }

  Widget _amenitiesGrid() => GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 1,
          childAspectRatio: 8.5,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => Text(
          '• ${amenities[index]}',
          style: f14RegularGrey,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: const TextScaler.linear(1),
        ),
        itemCount: amenities.length,
      );

  Widget get _time {
    final time = DcSiteLocatorUtils.getHours(selectedSiteLocation);
    return
        // _checkAmenitiesAvailability() !=
        //             SLViewText.amenitiesAndFeatureNotAvailable &&
        time != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: const BoxDecoration(
                  color: DrivenColors.whiteShadedBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SubTitleText(
                  title: time,
                  fontSize: 12,
                  fontWeight: DrivenFonts.fontWeightSemibold,
                  color: DrivenColors.checkboxBorderColor,
                ),
              )
            : const SizedBox.shrink();
  }

  Widget _amenities() {
    return const DrivenText(
      text: SLViewText.amenities,
      style: f16ExtraBoldBlack,
    );
  }

  Widget get _cardAcceptedView {
    if (_entitlementRepository.isAcceptedCardSectionEnabled) {
      return DcSiteLocatorUtils.isGuest
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const DrivenText(
                  text: SLViewText.cardAccepted,
                  style: f16ExtraBoldBlack,
                ),
                const SizedBox(height: 2),
                DrivenText(text: cardAccepted),
              ],
            )
          : const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }
}
