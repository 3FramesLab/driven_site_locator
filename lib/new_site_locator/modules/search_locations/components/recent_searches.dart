part of search_location_module;

class RecentSearches extends StatelessWidget {
  final SearchPlacesController searchPlaceController = Get.find();

  RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _recentText,
        _listView,
      ],
    );
  }

  Widget get _recentText => const Padding(
        padding: EdgeInsets.only(left: 16, bottom: 8),
        child: DrivenText(
          text: SLViewText.recent,
          style: f16SemiBoldBlack,
        ),
      );

  Widget get _listView => Obx(
        () => NewSearchPlacesListView(
          placesList: searchPlaceController.recentSearches(),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      );
}
