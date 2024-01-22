// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:driven_site_locator/site_locator/controllers/setup_wizard_controller.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/setup_wizard_panel_hood.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SetUpWizardSlidingPanel extends StatelessWidget {
  final Widget? body;
  final Function(double position)? onPanelSlide;

  final SiteLocatorController controller = Get.find();
  final SetUpWizardController setUpWizardController = Get.find();

  SetUpWizardSlidingPanel({
    this.body,
    this.onPanelSlide,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double setUpWizardPanelHeight = controller.panelMaxHeight(context);
    final double topPadding = MediaQuery.of(context).padding.top;
    final adjustedHeight =
        // Get.currentRoute == SiteLocatorRoutes.dashboard ? 70 : 30;
        // DrivenSiteLocator.instance.isUserAuthenticated ? 70 : 30;
        controller.isUserAuthenticated ? 70 : 30;
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      controller: controller.setUpWizardPanelController,
      maxHeight: setUpWizardPanelHeight - (topPadding - adjustedHeight),
      minHeight: 0,
      body: body,
      panelBuilder: _setUpWizardPanelBuilder,
      borderRadius: SiteInfoUtils.infoPanelTopBorder,
      onPanelClosed: setUpWizardController.onSetUpWizardClosedHandler,
    );
  }

  Widget _setUpWizardPanelBuilder(ScrollController controller) =>
      SetUpWizardPanelHood(controller);
}
