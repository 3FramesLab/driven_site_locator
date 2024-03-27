import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_controller.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_props.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/widgets/sites_loading_indicator_icon.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class SitesLoadingProgressIndicator extends StatelessWidget {
  final SitesLoadingProgressController loadingProgressController = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: siteLocatorController.getHastoShowSitesLoadingIndicator()
            ? _getProgressIndicator(context)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _getProgressIndicator(BuildContext context) {
    return Container(
      color: SitesLoadingProgressProps.modalBgColor,
      padding: EdgeInsets.zero,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SitesLoadingIndicatorIcon(),
          _displayProgressValue(),
          _getLoadingInfo(),
        ],
      ),
    );
  }

  Widget _getLoadingInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Obx(() => Text(
            loadingProgressController.statusMessage(),
            style: SitesLoadingProgressProps.loadingInfoStyle,
          )),
    );
  }

  Widget _displayProgressValue() {
    return Obx(() {
      final value = loadingProgressController.progressValue();
      final progressPercentage = value > SitesLoadingProgressProps.maxValue
          ? SitesLoadingProgressProps.maxValue
          : value;
      return Text(
        '${progressPercentage.toInt()}%',
        style: SitesLoadingProgressProps.loadingValueStyle,
      );
    });
  }
}
