import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';

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
      label: SemanticStrings.tapSiteInfoCallDirectionsListItem,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemTapped?.call(itemValue),
        child: listViewItemValue(itemValue),
      ),
    );
  }

  Widget listViewItemValue(String? value) => SizedBox(
        height: SiteLocatorConstants.siteInfoBottomListItemHeight,
        child: Center(
          child: SubTitleText(
            title: value ?? '',
            color: SiteLocatorColors.blueColor,
            fontSize: 20,
          ),
        ),
      );
}
