import 'package:driven_common/common/driven_dimensions.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class ZoomHandleButtons extends StatelessWidget {
  final Function()? onZoomInIconTap;
  final Function()? onZoomOutIconTap;
  ZoomHandleButtons({
    Key? key,
    this.onZoomInIconTap,
    this.onZoomOutIconTap,
  }) : super(key: key);

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: DrivenDimensions.dp16,
      bottom: DrivenDimensions.dp60,
      child: Column(
        children: [
          GestureDetector(
            onTap: onZoomInIconTap,
            child: Image.asset(SiteLocatorAssets.zoomInIcon),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onZoomOutIconTap,
            child: Image.asset(SiteLocatorAssets.zoomOutIcon),
          ),
        ],
      ),
    );
  }
}
