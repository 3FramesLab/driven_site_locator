import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/setup_wizard_constants.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/favorite_info_content.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/feature_info_title.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/widgets/feature_info_wizard/quick_filters_info_content.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/a_panel_handle.dart';

class FeatureInfoWizard extends StatelessWidget {
  const FeatureInfoWizard({
    required this.pageViewcontroller,
    required this.panelScrollController,
    Key? key,
  }) : super(key: key);

  final PageController pageViewcontroller;
  final ScrollController panelScrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: panelScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHandle(),
          SetUpFeatureInfoTitleContent(),
          SetUpQuickFiltersInfoContent(),
          SetUpFavoriteInfoContent(),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _actionButton() {
    const padding = SetUpWizardConstants.containerPadding;
    return Container(
      padding: padding,
      child: Column(
        children: [
          const SizedBox(height: 10),
          PrimaryButton(
            onPressed: _moveToFilterPreferencesPage,
            text: SetUpWizardConstants.nextButtonText,
          ),
        ],
      ),
    );
  }

  void _moveToFilterPreferencesPage() {
    if (pageViewcontroller.positions.isNotEmpty) {
      pageViewcontroller.nextPage(
          duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
    }
  }
}
