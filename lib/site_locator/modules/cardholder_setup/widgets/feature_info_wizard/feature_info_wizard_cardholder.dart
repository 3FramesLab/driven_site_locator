import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/favorite_info_content.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/feature_info_title.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/quick_filters_info_content.dart';

class FeatureInfoWizardCardholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SetUpFeatureInfoTitleContent(),
          const SizedBox(height: 8),
          SetUpQuickFiltersInfoContent(),
          const SizedBox(height: 20),
          SetUpFavoriteInfoContent(),
        ],
      ),
    );
  }
}
