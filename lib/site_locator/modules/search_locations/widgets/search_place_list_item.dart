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
            child: kIsWeb
                ? _buildWebSearchPlacesListRow()
                : _buildMobileSearchPlacesListRow(),
          ),
        ),
      );

  Row _buildMobileSearchPlacesListRow() {
    return Row(
      children: [
        _placeDetailsView(),
        _rightArrowIcon(),
      ],
    );
  }

  Future<dynamic> _onPlaceItemTapped() {
    siteLocatorController.clearMilesCachedData();
    return siteLocatorController
        .getLatLngForSelectedPlace(searchPlacesController.placesList[rowIndex]);
  }

  Expanded _placeDetailsView() => Expanded(
        flex: 9,
        child: _buildPlacesDetailsColumn(),
      );

  Widget _buildPlacesDetailsColumn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchResultMainText(),
          const SizedBox(height: 5),
          _searchResultSecondaryText()
        ],
      ),
    );
  }

  Text _searchResultSecondaryText() => Text(
        searchPlacesController
                .placesList[rowIndex].structuredFormatting?.secondaryText ??
            '',
        style: f14RegularGrey,
      );

  Text _searchResultMainText() => Text(
        searchPlacesController
                .placesList[rowIndex].structuredFormatting?.mainText ??
            '',
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

  Widget _buildWebSearchPlacesListRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlacesDetailsColumn(),
        Icon(
          Icons.chevron_right,
          size: 26,
        )
        // _rightArrowIcon(),
      ],
    );
  }
}
