import 'package:driven_common/driven_components/form_widgets/validators/already_in_use_validator.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:get/get.dart';

class FuelCardNickNameField extends StatefulWidget {
  @override
  State<FuelCardNickNameField> createState() => _NickNameUnAuthorized();
}

class _NickNameUnAuthorized extends State<FuelCardNickNameField>
    with HasValidation {
  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _onFocus,
      child: Obx(
        () => CustomTextFormField(
          textEditingController: controller.nickNameEditController,
          textInputFormatters: [alphaNumericSpaceInputFilter],
          onTextChanged: controller.onNickNameTextChanged,
          textCapitalization: TextCapitalization.sentences,
          onValidate: controller.canValidateForm() ? validate : null,
          textMaxLength: SiteLocatorConstants.nickNameLength,
          keyboardType: TextInputType.visiblePassword,
          autocorrect: false,
          fillColor: DrivenColors.white,
        ),
      ),
    );
  }

  void _onFocus(focus) {
    if (!focus && !controller.isOnBackPress()) {
      controller.canValidateForm(true);
    }
  }

  @override
  List<Validator> get validators => [
        const HasAtLeastNCharactersValidator(1),
        AlreadyInUseValidator(
          ViewText.cardNickname,
          controller.existingNickNames,
        )
      ];
}
