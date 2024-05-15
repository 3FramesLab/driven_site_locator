part of map_view_module;

class FuelCardNickNameField extends StatefulWidget {
  @override
  State<FuelCardNickNameField> createState() => _NickNameUnAuthorized();
}

class _NickNameUnAuthorized extends State<FuelCardNickNameField>
    with HasValidation {
  final FuelCardsController controller = Get.find();
  final isFocused = false.obs;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _onFocus,
      child: Obx(
        () => CustomTextFormField(
          textEditingController: controller.nickNameEditController,
          textInputFormatters: [alphaNumericSpaceInputFilter],
          onTextChanged: (value) =>
              controller.onNickNameTextChanged(value, validators),
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
          controller.existingNickNames(),
        )
      ];
}
