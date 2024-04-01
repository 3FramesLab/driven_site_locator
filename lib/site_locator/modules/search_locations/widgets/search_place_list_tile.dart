part of search_location_module;

class SearchPlaceListTile extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();
  final int rowIndex;
  final Function()? onResetViewTap;
  final Function()? onBackArrowTap;

  SearchPlaceListTile({
    required this.rowIndex,
    this.onResetViewTap,
    this.onBackArrowTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticStrings.searchPlaceListItem,
      container: true,
      child: Container(
        color: SiteInfoUtils.getCardBgColor(rowIndex),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          title: _searchResultMainText(rowIndex),
          subtitle: _searchResultSecondaryText(rowIndex),
          trailing: _arrowIcon(),
          onTap: () {
            _onPlaceItemTapped(rowIndex, onResetTapFunc: onResetViewTap);
          },
        ),
      ),
    );
  }

  Widget _searchResultMainText(int rowIndex) => Text(
        searchPlacesController
                .placesList[rowIndex].structuredFormatting?.mainText ??
            '',
        style: f16SemiboldBlack,
      );

  Widget _searchResultSecondaryText(int rowIndex) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          searchPlacesController
                  .placesList[rowIndex].structuredFormatting?.secondaryText ??
              '',
          style: f14RegularGrey,
        ),
      );

  Future<dynamic> _onPlaceItemTapped(int rowIndex,
      {Function()? onResetTapFunc}) {
    siteLocatorController.clearMilesCachedData();
    if (onResetTapFunc != null) {
      onResetTapFunc();
    }
    searchPlacesController.searchTextEditingController.text =
        searchPlacesController.placesList[rowIndex].structuredFormatting
            .toString();
    searchPlacesController.searchText = searchPlacesController
        .placesList[rowIndex].structuredFormatting
        .toString();
    return siteLocatorController
        .getLatLngForSelectedPlace(searchPlacesController.placesList[rowIndex]);
  }

  Widget _arrowIcon() {
    return const Icon(
      Icons.chevron_right,
      size: 26,
      color: Colors.black,
    );
  }
}
