part of cardholder_setup_module;

class CardholderPreferenceCheckbox extends StatelessWidget {
  final CardholderSetupController _cardholderSetupController = Get.find();
  final SiteFilter filter;

  CardholderPreferenceCheckbox({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: DrivenCheckbox(
            textWidget: Text(
              filter.label,
              style: f14RegularBlack,
            ),
            value: _value,
            onChanged: (value) => _onCheckboxChanged(isChecked: value),
            onTap: _onCheckboxTitleClick,
          ),
        ));
  }

  bool get _value => _cardholderSetupController.containsFilter(filter.key);

  void _onCheckboxChanged({bool? isChecked}) {
    final bool checkedFlag = isChecked ?? false;
    _cardholderSetupController.onPreferenceCheckChange(
      siteFilter: filter,
      isChecked: checkedFlag,
    );
  }

  void _onCheckboxTitleClick() {
    _onCheckboxChanged(isChecked: !_value);
  }
}
