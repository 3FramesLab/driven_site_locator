import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/controllers/setup_wizard_controller.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/personalize_filters_wizard/feature_preferences_content.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/personalize_filters_wizard/fuel_preferences_content.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/a_panel_handle.dart';
import 'package:get/get.dart';

class PersonalizeFiltersWizard extends StatelessWidget {
  PersonalizeFiltersWizard({
    required this.pageViewcontroller,
    required this.panelScrollController,
    Key? key,
  }) : super(key: key);

  final PageController pageViewcontroller;
  final ScrollController panelScrollController;
  final SetUpWizardController setUpWizardController = Get.find();

  @override
  Widget build(BuildContext context) {
    const padding = SetUpWizardConstants.containerPadding;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHandle(),
          Container(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  SetUpWizardConstants.personalizeTitle,
                  style: f28ExtraboldBlackDark,
                ),
                const SizedBox(height: 24),
                const Text(
                  SetUpWizardConstants.filtersSubtitle,
                  style: f16BoldBlackDark,
                ),
                const SizedBox(height: 24),
                FuelPreferencesContent(),
                FeaturePreferencesContent(),
                const SizedBox(height: 50),
                const Text(SetUpWizardConstants.setupLaterContent),
                const SizedBox(height: 24),
                _applyButton(),
                const SizedBox(height: 24),
                _skipButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Obx _applyButton() {
    return Obx(
      () => PrimaryButton(
        onPressed: setUpWizardController.selectedPreferences().isNotEmpty
            ? _completeSetUpWizardSettings
            : null,
        text: SetUpWizardConstants.applyButtonText,
      ),
    );
  }

  void _completeSetUpWizardSettings() {
    setUpWizardController.applyFilterPreferences();
    setUpWizardController.completesSetUpWizard();
  }

  Widget _skipButton() {
    return Center(
      child: TextButton(
        onPressed: setUpWizardController.completesSetUpWizard,
        child: Text(
          SetUpWizardConstants.skipForNow,
          style: f16SemiboldBlack.copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
