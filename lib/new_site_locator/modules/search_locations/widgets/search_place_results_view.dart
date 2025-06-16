part of search_location_module;

class SearchPlaceResultsView extends StatelessWidget {
  final SearchPlacesController searchPlacesController = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();

  SearchPlaceResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _goBack(didPop),
      child: SafeArea(
        child: SiteLocatorScaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              backButton(),
              const SizedBox(height: 5),
              _searchTextField(),
              const SizedBox(height: 20),
              const SearchPlacesListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchTextField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SearchPlaceTextField(
          currentLocation: _getLatLngAsString(),
        ),
      );

  String _getLatLngAsString() => [
        siteLocatorController.currentLocation().latitude,
        siteLocatorController.currentLocation().longitude
      ].join(',');

  Widget backButton() => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: DrivenBackButton(onPressed: () => _goBack(false)),
      );

  void _goBack(bool didPop) {
    if (didPop) {
      return;
    }
    Get.back(result: true);
  }
}
