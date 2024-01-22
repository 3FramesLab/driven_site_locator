import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/map_pin_description_view.dart';

class SetUpFeatureInfoTitleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const padding = SetUpWizardConstants.containerPadding;
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!AppUtils.isComdata)
            const Text(SetUpWizardConstants.title,
                style: f28ExtraboldBlackDark),
          if (!AppUtils.isComdata) const SizedBox(height: 22),
          const Text(
            SetUpWizardConstants.discountBannerPinInfo,
            style: f16BoldBlackDark,
          ),
          const SizedBox(height: 22),
          const MapPinDescriptionView(),
        ],
      ),
    );
  }
}
