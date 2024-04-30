part of map_view_module;

class FuelCardNumberField extends GetView<FuelCardsController>
    with HasValidation {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _onFocus,
      child: Obx(
        () => CustomTextFormField(
          textEditingController: controller.cardTextEditController,
          onTextChanged: _onTextChange,
          onValidate: controller.canValidateForm() ? validate : null,
          suffixIcon: controller.cardVisibility()
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          onSuffixIconPressed: controller.toggleCardVisibility,
          textMaxLength: 24,
          keyboardType: TextInputType.number,
          isObscureText: !controller.cardVisibility(),
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

  void _onTextChange(value) {
    if (controller.cardVisibility()) {
      controller.onVisibleTextChange(value);
    } else {
      controller.onObscureTextChange(value);
    }
  }

  @override
  List<Validator> get validators => [
        CardNumberCharactersValidator(controller.cardVisibility() ? 19 : 16,
            propCardLength: 15),
      ];
}
