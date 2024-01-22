import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:driven_site_locator/site_locator/views/map_view_page/widgets/menu/site_locator_menu_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SiteLocatorMenuPanel extends StatelessWidget {
  final Widget? body;

  final SiteLocatorController controller = Get.find();

  SiteLocatorMenuPanel({
    this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      margin: const EdgeInsets.only(top: SiteLocatorDimensions.dp100),
      controller: controller.menuPanelController,
      maxHeight: Get.height > 600 ? Get.height * 0.55 : Get.height * 0.7,
      body: body,
      minHeight: SiteLocatorDimensions.dp0,
      panelBuilder: _panelBuilder,
      borderRadius: SiteInfoUtils.infoPanelTopBorder,
    );
  }

  Widget _panelBuilder(ScrollController controller) => SiteLocatorMenuContent();
}
