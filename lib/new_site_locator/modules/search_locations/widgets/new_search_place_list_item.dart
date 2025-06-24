part of search_location_module;

class NewSearchPlaceListItem extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final SLSearchPlacesController searchPlacesController = Get.find();
  final Predictions predictions;
  final int rowIndex;

  NewSearchPlaceListItem({
    required this.predictions,
    required this.rowIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Semantics(
        label: SLSemanticStrings.searchPlaceListItem,
        container: true,
        child: GestureDetector(
          onTap: _onPlaceItemTapped,
          child: Container(
            color: SiteInfoUtils.getCardBgColor(rowIndex),
            child: Row(
              children: [
                _placeDetailsView(),
                _rightArrowIcon(),
              ],
            ),
          ),
        ),
      );

  Future<dynamic> _onPlaceItemTapped() {
    siteLocatorController.clearMilesCachedData();
    searchPlacesController.savePrediction(predictions);
    siteLocatorController.selectedPlace = predictions;
    return siteLocatorController.getLatLngForSelectedPlace(
      predictions,
      shouldNavigateBack: true,
    );
  }

  Expanded _placeDetailsView() => Expanded(
        flex: 9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchResultMainText(),
              const SizedBox(height: 5),
              _searchResultSecondaryText()
            ],
          ),
        ),
      );

  Text _searchResultSecondaryText() => Text(
        predictions.structuredFormatting?.secondaryText ?? '',
        style: f14RegularGrey,
      );

  Text _searchResultMainText() => Text(
        predictions.structuredFormatting?.mainText ?? '',
        style: f16SemiBoldBlack,
      );

  Expanded _rightArrowIcon() => const Expanded(
        flex: 2,
        child: Center(
          child: Icon(
            Icons.chevron_right,
            size: 26,
          ),
        ),
      );
}
