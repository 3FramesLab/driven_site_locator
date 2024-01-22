import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_filters_constants.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/personalize_filters_wizard/preference_checkbox.dart';

class FeaturePreferencesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          SetUpWizardConstants.featuresTitle,
          style: f16BoldBlackDark,
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            ...SiteFilters.featuresPreferencesList
                .map(
                  (filter) => PersonalizedPreferenceCheckbox(
                    filter: filter,
                  ),
                )
                .toList()
          ],
        ),
      ],
    );
  }
}
