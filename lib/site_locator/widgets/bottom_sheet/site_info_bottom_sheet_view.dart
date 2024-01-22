import 'package:driven_site_locator/site_locator/site_locator_components/common_widgets/site_locator_divider.dart';
import 'package:driven_site_locator/site_locator/widgets/bottom_sheet/site_info_bottom_sheet_item.dart';
import 'package:driven_site_locator/site_locator/widgets/list_view/custom_list_view_separated.dart';
import 'package:flutter/material.dart';

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
