import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SearchThisAreaButton extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  SearchThisAreaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PointerInterceptor(
          child: Visibility(
        visible: siteLocatorController.isShowSearchThisArea() &&
            siteLocatorController.isLatLngBoundsChanged(),
        child: FloatingMapButton(
          key: const Key(SemanticStrings.searchThisArea),
          icon: Icons.pin_drop_outlined,
          label: SiteLocatorConstants.searchThisArea,
          onPressed: siteLocatorController.onSearchThisAreaButtonTap,
          canShowBorder: false,
          buttonPadding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 14,
          )),
        ),
      ));
    });
  }
}
