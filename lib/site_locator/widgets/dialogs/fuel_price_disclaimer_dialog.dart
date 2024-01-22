import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/controllers/fuel_price_disclaimer_controller.dart';
import 'package:get/get.dart';

class FuelPriceDisclaimerDialog extends StatelessWidget {
  FuelPriceDisclaimerDialog({Key? key}) : super(key: key);

  final FuelPriceDisclaimerController fuelPriceDisclaimerController =
      Get.find();

  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      enableBackPress: false,
      isDynamicAlert: true,
      text: _dialogPrimaryText,
      secondaryBody: _dialogSecondaryView(),
      primaryButton: _okButton(),
    );
  }

  Obx _dialogSecondaryView() => Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _fuelDisclaimerCheckBox(),
        ),
      );

  DrivenCheckbox _fuelDisclaimerCheckBox() => DrivenCheckbox(
        onTap: _updateFuelDisclaimerStatus,
        onChanged: fuelPriceDisclaimerController.isFuelDisclaimerCheckboxMarked,
        value: fuelPriceDisclaimerController.isFuelDisclaimerCheckboxMarked(),
        textWidget: _dialogSecondaryText(),
      );

  void _updateFuelDisclaimerStatus() =>
      fuelPriceDisclaimerController.isFuelDisclaimerCheckboxMarked(
          !fuelPriceDisclaimerController.isFuelDisclaimerCheckboxMarked());

  Obx _okButton() => Obx(
        () => PrimaryButton(
          text: ViewText.ok,
          onPressed: _isEnableOkButton
              ? fuelPriceDisclaimerController.onAcceptFuelPriceDisclaimer
              : null,
        ),
      );

  bool get _isEnableOkButton =>
      fuelPriceDisclaimerController.isFuelDisclaimerCheckboxMarked();

  Text _dialogSecondaryText() => const Text(
        SiteLocatorConstants.fuelPriceAcknowledge,
        style: f14SemiboldGrey,
        overflow: TextOverflow.visible,
      );

  List<TextSpan> get _dialogPrimaryText => const [
        TextSpan(
          text: SiteLocatorConstants.fuelPriceDisclaimer,
          style: f16SemiboldBlack,
        )
      ];
}
