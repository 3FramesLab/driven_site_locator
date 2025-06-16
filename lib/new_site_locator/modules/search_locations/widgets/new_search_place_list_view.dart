part of search_location_module;

class NewSearchPlacesListView extends StatelessWidget {
  final List<Predictions> placesList;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const NewSearchPlacesListView({
    required this.placesList,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _placeList;
  }

  Widget get _placeList => shrinkWrap ? _listView : Expanded(child: _listView);

  Widget get _listView => ListView.builder(
        itemBuilder: (context, index) => NewSearchPlaceListItem(
          rowIndex: index,
          predictions: placesList[index],
        ),
        itemCount: placesList.length,
        shrinkWrap: shrinkWrap,
        physics: physics,
      );
}
