part of sl_widget_module;

class SiteInfoBottomSheetView extends StatelessWidget {
  final List<String> itemList;
  final Function(String)? onItemTapped;

  const SiteInfoBottomSheetView({
    required this.itemList,
    this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListViewSeparated(
      itemBuilder: (_, index) {
        return SiteInfoBottomSheetItem(
          itemValue: itemList[index],
          onItemTapped: onItemTapped,
        );
      },
      separatorBuilder: (_, __) => _divider(),
      itemCount: itemList.length,
    );
  }

  Widget _divider() => const SiteLocatorDivider();
}
