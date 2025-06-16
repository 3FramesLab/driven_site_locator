part of sl_filter_module;

class AuthSLTypeChoices extends StatelessWidget {
  final AuthSLTypeChoicesController authSLTypeChoiceController = Get.find();
  final SelectYourCardController selectYourCardController =
      Get.find<SelectYourCardController>();
  final bool isNeedWidthAdjuster = true;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final filterButtonsDisplayList =
            authSLTypeChoiceController.authFilterList;
        final choicesCount = filterButtonsDisplayList.length;
        final widthAdjuster = choicesCount > 2 ? 10.0 : 0.0;
        return Container(
          color: Colors.transparent,
          width:
              isNeedWidthAdjuster ? (choicesCount * 125) - widthAdjuster : null,
          padding: EdgeInsets.zero,
          height: 54,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: slTypeChoicesList(filterButtonsDisplayList),
          ),
        );
      },
    );
  }

  List<Widget> slTypeChoicesList(List<Filter> filterButtonsDisplayList) {
    final typeChoicesList = <Widget>[];

    for (int i = 0; i < filterButtonsDisplayList.length; i++) {
      final item = filterButtonsDisplayList[i];
      final bool isSelectedOption = authSLTypeChoiceController
              .selectedFilterHeader()
              .contains(item.key) ||
          authSLTypeChoiceController
                  .selectedSiteFiltersKeysMap[item.key]?.isNotEmpty ==
              true;
      final isFirstItem = i == 0;
      final isLastItem = i == filterButtonsDisplayList.length - 1;

      final optionWidget = Semantics(
        key: Key('${item.key}_chip_option'),
        container: true,
        label: '${item.quickFilterLabel}_option',
        selected: isSelectedOption,
        child: Padding(
          padding: EdgeInsets.only(
            left: isFirstItem ? 10 : 0,
            right: isLastItem ? 10 : 0,
          ),
          child: displayChoiceChipButton(
            item: item,
            isSelectedOption: isSelectedOption,
          ),
        ),
      );
      typeChoicesList.add(optionWidget);
    }

    return typeChoicesList;
  }

  Widget displayChoiceChipButton({
    required Filter item,
    required bool isSelectedOption,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: EdgeInsets.zero,
      child: item.key == SLInternalText.cardTypeKey
          ? _cardTypeChip(item: item, isSelectedOption: isSelectedOption)
          : Obx(() {
              return AuthSLChoiceChipBadgedButton(
                item: item,
                isSelectedOption: isSelectedOption,
                count: _count(item),
              );
            }),
    );
  }

  Widget _cardTypeChip({
    required Filter item,
    required bool isSelectedOption,
  }) {
    return AuthSLChoiceChipBadgedButton(
      item: item,
      isSelectedOption:
          isSelectedOption || selectYourCardController.isAnyCardSelected(),
      count: selectYourCardController.isAnyCardSelected() ? 1 : 0,
    );
  }

  int? _count(Filter item) {
    return authSLTypeChoiceController
        .selectedSiteFiltersKeysMap[item.key]?.length;
  }
}
