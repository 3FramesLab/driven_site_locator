part of search_location_module;

class SearchPlaceTextField extends StatefulWidget {
  final String? currentLocation;
  final bool? hasShadow;

  const SearchPlaceTextField({
    super.key,
    this.currentLocation,
    this.hasShadow = true,
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
        hasShadow: widget.hasShadow,
        child: TextField(
          textInputAction: TextInputAction.search,
          controller: searchPlacesController.searchTextEditingController,
          onChanged: _onChanged,
          onSubmitted: (_) => searchTextfieldIconTapped(forceSearch: true),
          cursorColor: DrivenColors.black38,
          cursorWidth: 1.2,
          decoration: _searchTextFieldDecoration().copyWith(
            hintText: SLInternalText.searchForCityStreetZip,
          ),
        ),
      );

  InputDecoration _searchTextFieldDecoration() =>
      SiteLocatorTextFieldStyle().searchTextFieldDecoration(
          suffixIcon: _searchTextFieldSuffixIcon(), borderWidth: 0.1);

  Widget _searchTextFieldSuffixIcon() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
        child: Semantics(
          container: true,
          label: SLSemanticStrings.searchButton,
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
            size: 24,
            color: searchPlacesController.getIconColor,
          );
        },
      );

  void _onChanged(String newText) {
    if (searchPlacesController.searchIconName() == SLInternalText.clear) {
      searchPlacesController.searchIconName(SLInternalText.search);
    }
  }

  Future<void> searchTextfieldIconTapped({bool forceSearch = false}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final searchText =
        searchPlacesController.searchTextEditingController.text.trim();

    if (searchText.isNotEmpty) {
      if (_isSearchIcon || forceSearch) {
        await _executeSearchPlace(searchText);
        siteLocatorController.resetMarkers(PinVariantStore.statusList);
      } else if (_isClearIcon) {
        await onClearIconTapped();
      }
    }
  }

  Future<void> _executeSearchPlace(String searchText) async {
    siteLocatorController.getSearchTrackAction();
    searchPlacesController.searchIconName(SLInternalText.clear);
    searchPlacesController.searchText = searchText;
    if (Get.currentRoute == AdminRoutes.searchPlaceResultsView ||
        Get.currentRoute == Routes.searchPlace) {
      await searchPlacesController.getPlacesResults();
    } else {
      _goToResultPage();
    }
  }

  Future<void> onClearIconTapped() async {
    _clearTextInput();
    try {
      // TODO(Smeet): may be required in future.
      // if (Get.currentRoute == AdminRoutes.siteLocationsListView) {
      //   await searchPlacesController
      //       .resetListViewOnClearSearchTextfield(siteLocatorController);
      // } else {
      //   await searchPlacesController
      //       .resetMapViewOnClearSearchTextfield(siteLocatorController);
      // }
      searchPlacesController.placesList.clear();
      await searchPlacesController
          .resetMapViewOnClearSearchTextfield(siteLocatorController);
    } catch (_) {}
  }

  void _clearTextInput() {
    siteLocatorController.canClearSearchTextField = true;
    searchPlacesController.clearTextInput();
    siteLocatorController.selectedPlace = null;
  }

  bool get _isSearchIcon =>
      searchPlacesController.searchIconName() == SLInternalText.search;

  bool get _isClearIcon =>
      searchPlacesController.searchIconName() == SLInternalText.clear;

  void _goToResultPage() {
    // Get.toNamed(AdminRoutes.searchPlaceResultsView)?.then((result) {
    //   if (result != null) {
    //     if (result is bool && result) {
    //       _clearTextInput();
    //     } else if (result is Predictions) {
    //       searchPlacesController.searchTextEditingController.text =
    //           result.structuredFormatting.toString();
    //       searchPlacesController.searchText =
    //           result.structuredFormatting.toString();
    //       searchPlacesController.searchIconName(SLInternalText.clear);
    //     }
    //   }
    // });
    NavTo.searchPlace(arguments: {
      RouteArguments.fromScreen: SLInternalText.listView,
    })?.then((result) {
      if (result != null) {
        if (result is bool && result) {
          _clearTextInput();
        } else if (result is Predictions) {
          searchPlacesController.searchTextEditingController.text =
              result.structuredFormatting.toString();
          searchPlacesController.searchText =
              result.structuredFormatting.toString();
          searchPlacesController.searchIconName(SLInternalText.clear);
        }
      }
    });
  }
}
