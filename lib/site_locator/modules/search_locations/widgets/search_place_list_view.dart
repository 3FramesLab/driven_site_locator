part of search_location_module;

class SearchPlacesListView extends StatefulWidget {
  const SearchPlacesListView({super.key});

  @override
  State<SearchPlacesListView> createState() => _SearchPlacesListViewState();
}

class _SearchPlacesListViewState extends State<SearchPlacesListView> {
  final SearchPlacesController searchPlacesController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getPlacesData());
  }

  Future<void> getPlacesData() async {
    await searchPlacesController.getPlacesResults();
  }

  @override
  Widget build(BuildContext context) => Obx(
        () =>
            searchPlacesController.isLoading() ? _loadingContainer : _placeList,
      );

  Widget get _loadingContainer => const CupertinoActivityIndicator(
        color: Colors.purple,
        radius: 20,
      );

  Widget get _placeList => Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) => SearchPlaceListItem(rowIndex: index),
          itemCount: searchPlacesController.placesList.length,
        ),
      );
}
