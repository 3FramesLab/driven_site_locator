part of sl_widget_module;

class SiteInfoBottomSheetItem extends StatelessWidget {
  final String itemValue;
  final Function(String)? onItemTapped;

  const SiteInfoBottomSheetItem({
    required this.itemValue,
    this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SLSemanticStrings.tapSiteInfoCallDirectionsListItem,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemTapped?.call(itemValue),
        child: listViewItemValue(itemValue),
      ),
    );
  }

  Widget listViewItemValue(String? value) => SizedBox(
        height: SLInternalText.siteInfoBottomListItemHeight,
        child: Center(
          child: SubTitleText(
            title: value ?? '',
            color: SLColors.blueColor,
            fontSize: 20,
          ),
        ),
      );
}
