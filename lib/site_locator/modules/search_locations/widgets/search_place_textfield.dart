part of search_location_module;

class SearchPlaceTextField extends StatefulWidget {
  final String? currentLocation;
  final Function(bool) onSearchClick;

  const SearchPlaceTextField({
    required this.onSearchClick,
    super.key,
    this.currentLocation,
  });

  @override
  State<SearchPlaceTextField> createState() => _SearchPlaceTextFieldState();
}

class _SearchPlaceTextFieldState extends State<SearchPlaceTextField> {
  final SiteLocatorController siteLocatorController = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();

  @override
  void initState() {
    searchPlacesController.currentLocation = widget.currentLocation ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (onFocus) {
        if (!onFocus) {
          SiteLocatorUtils.hideKeyboard();
        }
        siteLocatorController.resetMarkers(PinVariantStore.statusList);
      },
      child: _searchTextField(),
    );
  }

  Widget _searchTextField() => CustomCardWithShadow(
        child: TextField(
          textInputAction: TextInputAction.search,
          controller: searchPlacesController.searchTextEditingController,
          onChanged: _onChanged,
          onSubmitted: (_) => searchTextfieldIconTapped(forceSearch: true),
          cursorColor: const Color.fromARGB(1, 60, 60, 60),
          cursorWidth: 1.2,
          decoration: _searchTextFieldDecoration(),
        ),
      );

  InputDecoration _searchTextFieldDecoration() =>
      SiteLocatorTextFieldStyle().searchTextFieldDecoration(
          suffixIcon: _searchTextFieldSuffixIcon(), borderWidth: 0.1);

  Widget _searchTextFieldSuffixIcon() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
        child: Semantics(
          container: true,
          label: SemanticStrings.searchButton,
          child: GestureDetector(
            onTap: searchTextfieldIconTapped,
            child: _searchTextFieldIconContainer(),
          ),
        ),
      );

  Widget _searchTextFieldIconContainer() => Obx(() {
        return SiteLocatorTextFieldStyle().searchTextFieldIconContainer(
          child: _searchTextfieldIcon(),
          color: searchPlacesController.getIconBGColor,
        );
      });

  Widget _searchTextfieldIcon() => Obx(
        () {
          return Icon(
            searchPlacesController.getIcon,
            size: SiteLocatorDimensions.dp24,
            color: searchPlacesController.getIconColor,
          );
        },
      );

  void _onChanged(String newText) {
    if (searchPlacesController.searchIconName() == SiteLocatorConstants.clear) {
      searchPlacesController.searchIconName(SiteLocatorConstants.search);
    }
  }

  Future<void> searchTextfieldIconTapped({bool forceSearch = false}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final searchText =
        searchPlacesController.searchTextEditingController.text.trim();

    if (searchText.isNotEmpty) {
      if (_isSearchIcon || forceSearch) {
        widget.onSearchClick(true);
        await _executeSearchPlace(searchText);
      } else if (_isClearIcon) {
        await onClearIconTapped();
      }
    }
  }

  Future<void> _executeSearchPlace(String searchText) async {
    siteLocatorController.getSearchTrackAction();
    searchPlacesController.searchIconName(SiteLocatorConstants.clear);
    searchPlacesController.searchText = searchText;
    if (Get.currentRoute != SiteLocatorRoutes.searchPlaceResultsView) {
      await searchPlacesController.getPlacesResults();
    } else {
      _goToResultPage();
    }
  }

  Future<void> onClearIconTapped() async {
    _clearTextInput();
    try {
      if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
        await searchPlacesController
            .resetListViewOnClearSearchTextfield(siteLocatorController);
      } else {
        await searchPlacesController
            .resetMapViewOnClearSearchTextfield(siteLocatorController);
      }
    } catch (_) {}
  }

  void _clearTextInput() {
    siteLocatorController.canClearSearchTextField = true;
    searchPlacesController.clearTextInput();
  }

  bool get _isSearchIcon =>
      searchPlacesController.searchIconName() == SiteLocatorConstants.search;

  bool get _isClearIcon =>
      searchPlacesController.searchIconName() == SiteLocatorConstants.clear;

  void _goToResultPage() {
    Get.toNamed(SiteLocatorRoutes.searchPlaceResultsView)?.then((result) {
      if (result != null) {
        if (result is bool && result) {
          _clearTextInput();
        } else if (result is Predictions) {
          searchPlacesController.searchTextEditingController.text =
              result.structuredFormatting.toString();
          searchPlacesController.searchText =
              result.structuredFormatting.toString();
          searchPlacesController.searchIconName(SiteLocatorConstants.clear);
        }
      }
    });
  }
}
