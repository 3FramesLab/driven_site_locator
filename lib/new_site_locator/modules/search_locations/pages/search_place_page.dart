// ignore_for_file: must_be_immutable

part of search_location_module;

class SearchPlacePage extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final SLSearchPlacesController searchPlaceController = Get.find();
  String fromScreen = '';

  SearchPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    _initData();
    return DrivenScaffold(
      backgroundColor: DrivenColors.white,
      appBar: DrivenAppBar(
        leading: const DrivenBackButton(),
        backgroundColor: DrivenColors.white,
      ),
      body: Column(
        children: [
          _searchTextField(),
          _currentView,
        ],
      ),
    );
  }

  void _initData() {
    _getArguments();
    if (fromScreen == SLRoutes.unauthSiteLocator) {
      searchPlaceController.placesList.clear();
    } else if (fromScreen == SLInternalText.listView) {
      searchPlaceController.getPlacesResults();
    }
    // should clear search if coming from mapview
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchPlaceController.getRecentSearches();
    });
  }

  Widget get _currentView => Obx(() {
        if (searchPlaceController.isLoading()) {
          return _loadingContainer;
        } else if (searchPlaceController.placesList.isEmpty) {
          return _recentSearches;
        } else {
          return NewSearchPlacesListView(
            placesList: searchPlaceController.placesList,
          );
        }
      });

  Widget get _loadingContainer => const CupertinoActivityIndicator(
        color: DrivenColors.primary,
        radius: 20,
      );

  Widget get _recentSearches => Expanded(
        child: SingleChildScrollView(
          child: RecentSearches(),
        ),
      );

  Widget _searchTextField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SearchPlaceTextField(
          currentLocation: _getLatLngAsString(),
          hasShadow: false,
        ),
      );

  String _getLatLngAsString() => [
        siteLocatorController.currentLocation().latitude,
        siteLocatorController.currentLocation().longitude
      ].join(',');

  void _getArguments() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args[SLRouteArguments.fromScreen] != null) {
        fromScreen = args[SLRouteArguments.fromScreen];
      }
    }
  }
}
