import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/site_info_panel_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SiteInfoSlidingPanel extends StatelessWidget {
  final Widget? body;
  final bool showExtraData;
  final Function(double position)? onPanelSlide;

  final SiteLocatorController controller = Get.find();

  SiteInfoSlidingPanel({
    this.body,
    this.showExtraData = false,
    this.onPanelSlide,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _panelHeightOpen = controller.panelMaxHeight(context);

    return Obx(
      () => SlidingUpPanel(
        controller: controller.locationPanelController,
        maxHeight: _panelHeightOpen,
        minHeight: controller.infoPanelMinHeight(),
        body: body,
        panelBuilder: _panelBuilder,
        borderRadius: SiteInfoUtils.infoPanelTopBorder,
        onPanelSlide: onPanelSlide ?? controller.onPanelSlideEventHandler,
      ),
    );
  }

  Widget _panelBuilder(ScrollController controller) => SiteInfoPanelContent(
        controller,
        showExtraData: showExtraData,
      );
}
