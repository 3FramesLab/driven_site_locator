part of sl_filter_module;

class AuthSLChoiceChipButton extends StatelessWidget {
  AuthSLChoiceChipButton({
    required this.item,
    required this.isSelectedOption,
  });

  final Filter item;
  final bool isSelectedOption;

  final AuthSLTypeChoicesController authSLTypeChoiceController = Get.find();

  @override
  Widget build(BuildContext context) {
    const tealColor = DrivenColors.primary;
    final normalChipText = f14SemiBoldBlack.copyWith(color: tealColor);
    return ChoiceChip(
      key: Key('${item.key}_option'),
      padding: const EdgeInsets.all(12),
      label: Text(
        item.quickFilterLabel,
        style: isSelectedOption ? f14SemiboldWhite : normalChipText,
      ),
      selectedColor: tealColor,
      backgroundColor: DrivenColors.white,
      shadowColor: DrivenColors.grey.withOpacity(0.5),
      selected: isSelectedOption,
      elevation: 2,
      onSelected: (selected) {
        authSLTypeChoiceController.buttonActionHandler(item);
        if (item.key == SLInternalText.cardTypeKey) {
          _openCardTypeBottomSheet();
        } else {
          authSLTypeChoiceController.onParentFilterClick(item);
          authSLTypeChoiceController.setFilterListOnParentFilterClick(item);
          showFilterOptionBottomSheet(
            context,
            item,
          );
        }
      },
    );
  }

  Future<void> _openCardTypeBottomSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (_) => const SizedBox(),
      // TODO(Smeet): important.
      // builder: (context) => CardTypeListBottomSheet(),
    );

    authSLTypeChoiceController.selectedFilterHeader('');
  }

  Future<void> showFilterOptionBottomSheet(
      BuildContext context, Filter filter) async {
    await showModalBottomSheet(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SLFilterOptionContent(
            filter: filter,
          );
        });

    authSLTypeChoiceController.selectedFilterHeader('');
  }
}
