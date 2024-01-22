import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/favorite_card_mold.dart';

class SetUpFavoriteInfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const padding = SetUpWizardConstants.containerPadding;
    return Container(
      padding: padding,
      child: Column(
        children: [
          const Text(
            SetUpWizardConstants.favoritesInfo,
            style: f16BoldBlackDark,
          ),
          const SizedBox(height: 24),
          FavoriteCardMold(),
        ],
      ),
    );
  }
}
