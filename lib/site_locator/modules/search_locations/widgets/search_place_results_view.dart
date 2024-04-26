part of search_location_module;

class SearchPlaceResultsView extends StatelessWidget {
  final SearchPlacesController searchPlacesController = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();
  final Function()? onClearIconTap;
  final Function()? onBackArrowTap;

  SearchPlaceResultsView({
    this.onBackArrowTap,
    this.onClearIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? buildViewContents()
        : WillPopScope(
            onWillPop: _goBack,
            child: SafeArea(
              child: SiteLocatorScaffold(
                backgroundColor: Colors.white,
                body: buildViewContents(),
              ),
            ),
          );
  }

  Widget buildViewContents() {
    return Column(
      children: [
        if (kIsWeb) ...[
          const SizedBox(height: 48),
        ],
        backButton(),
        const SizedBox(height: kIsWeb ? 27 : 5),
        _searchTextField(),
        const SizedBox(height: 20),
        SearchPlacesListView(onResetTap: onClearIconTap),
      ],
    );
  }

  Widget _searchTextField() => Container(
        width: 375,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SearchPlaceTextField(
          currentLocation: _getLatLngAsString(),
          // onSearchIconTap: onClearIconTap,
        ),
      );

  String _getLatLngAsString() => [
        siteLocatorController.currentLocation().latitude,
        siteLocatorController.currentLocation().longitude
      ].join(',');

  Widget backButton() => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: DrivenBackButton(
          onPressed: _goBack,
          color: kIsWeb ? SiteLocatorColors.black : SiteLocatorColors.blueColor,
          buttonLabelText: _buttonLabelText,
          textStyle: backButtonTextStyle,
          verticalSpacing: 16,
        ),
      );

  String get _buttonLabelText {
    return kIsWeb ? EnhancedFilterConstants.search : DrivenConstants.back;
  }

  TextStyle get backButtonTextStyle {
    return kIsWeb
        ? f24ExtraboldBlackDark
        : const TextStyle(
            fontSize: 17,
            color: SiteLocatorColors.blueColor,
          );
  }

  Future<bool> _goBack() {
    if (kIsWeb) {
      onBackArrowTap?.call();
    }
    Get.back(result: true);
    return Future.value(false);
  }
}
