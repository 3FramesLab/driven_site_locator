import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class NoFuelPricesDialog extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  NoFuelPricesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: DrivenRectangleBorder.mediumRounded,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: SiteLocatorConstants.minLocationEnableDialogHeight,
        ),
        child: DrivenColumn(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.all(SiteLocatorDimensions.dp16),
          children: [
            _dialogPrimaryText(),
            const SizedBox(height: SiteLocatorDimensions.dp24),
            _buildRefreshButton(),
            _dismissButton(),
          ],
        ),
      ),
    );
  }

  DialogButton _buildRefreshButton() {
    return DialogButton(
      onPressed: _refreshButtonTap,
      text: SiteLocatorConstants.refreshMap,
      height: SiteLocatorDimensions.dp48,
    );
  }

  Future<void> _refreshButtonTap() async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    await siteLocatorController.refreshFuelPriceApi();
  }

  Widget _dismissButton() => UnderlinedButton.black(
        onPressed: Get.back,
        text: ViewText.dismissSettingPopup,
      );

  Text _dialogPrimaryText() => const Text(
        SiteLocatorConstants.fuelPriceApiErrorMsg,
        textAlign: TextAlign.center,
        style: f14RegularBlack,
        overflow: TextOverflow.visible,
      );
}
