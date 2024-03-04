part of search_location_module;

class SearchPlaceListItem extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();
  final int rowIndex;

  SearchPlaceListItem({
    required this.rowIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Semantics(
        label: SemanticStrings.searchPlaceListItem,
        container: true,
        child: GestureDetector(
          onTap: _onPlaceItemTapped,
          child: Container(
            color: SiteInfoUtils.getCardBgColor(rowIndex),
            child: Row(
              children: [
                _placeDetailsView(),
                // _rightArrowIcon(),
              ],
            ),
          ),
        ),
      );

  Future<dynamic> _onPlaceItemTapped() {
    siteLocatorController.clearMilesCachedData();
    return siteLocatorController
        .getLatLngForSelectedPlace(searchPlacesController.placesList[rowIndex]);
  }

  Widget _placeDetailsView() => Container(
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
        searchPlacesController
                .placesList[rowIndex].structuredFormatting?.secondaryText ??
            'test',
        style: f14RegularGrey,
      );

  Text _searchResultMainText() => Text(
        searchPlacesController
                .placesList[rowIndex].structuredFormatting?.mainText ??
            'sasas',
        style: f16SemiboldBlack,
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
