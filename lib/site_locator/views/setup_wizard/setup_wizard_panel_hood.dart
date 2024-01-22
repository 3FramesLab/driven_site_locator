import 'package:driven_site_locator/site_locator/views/setup_wizard/page_views/a_feature_info_wizard.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/page_views/b_personalize_filters_wizard.dart';
import 'package:flutter/material.dart';

class SetUpWizardPanelHood extends StatelessWidget {
  const SetUpWizardPanelHood(this.scrollController);

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final _wizardPageViewcontroller = PageController();
    return PageView(
      controller: _wizardPageViewcontroller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FeatureInfoWizard(
          pageViewcontroller: _wizardPageViewcontroller,
          panelScrollController: scrollController,
        ),
        PersonalizeFiltersWizard(
          pageViewcontroller: _wizardPageViewcontroller,
          panelScrollController: scrollController,
        ),
      ],
    );
  }
}
