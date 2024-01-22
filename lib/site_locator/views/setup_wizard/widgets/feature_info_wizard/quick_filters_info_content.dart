import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_filters_constants.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/widgets/common/custom_card_with_shadow.dart';

class SetUpQuickFiltersInfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const padding = SetUpWizardConstants.containerPadding;
    return Container(
      padding: padding,
      color: SiteLocatorColors.grey100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _filterDescriptionText,
            style: f16BoldBlackDark,
          ),
          const SizedBox(height: 24),
          Center(
            child: Wrap(
              children: [
                quickFilterButtonMold(
                    filterLabel: SiteFilters.quickFiltersList[0].label),
                quickFilterButtonMold(
                    filterLabel: SiteFilters.quickFiltersList[1].label),
                if (SiteFilters.quickFiltersList.length > 2 &&
                    !AppUtils.isComdata)
                  quickFilterButtonMold(
                      filterLabel: SiteFilters.quickFiltersList[2].label),
                if (SiteFilters.quickFiltersList.length > 3)
                  quickFilterButtonMold(
                      filterLabel: SiteFilters.quickFiltersList[3].label),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quickFilterButtonMold({required String filterLabel}) {
    Widget? icon;
    if (filterLabel == SiteFilters.quickFiltersList[2].label &&
        !AppUtils.isComdata) {
      icon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2),
        ),
        child: const Center(
          child: Icon(
            Icons.percent_sharp,
            size: 20,
            color: Colors.black,
          ),
        ),
      );
    }
    return CustomCardWithShadow(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Chip(
          avatar: icon,
          backgroundColor: Colors.white,
          label: Text(
            filterLabel,
            style: f16BoldBlackDark,
          ),
        ),
      ),
    );
  }

  String get _filterDescriptionText => AppUtils.isComdata
      ? SetUpWizardConstants.cardholderQuickFiltersInfo
      : SetUpWizardConstants.fleetManagerQuickFiltersInfo;
}
