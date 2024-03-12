part of filter_module;

class ClearAllFilterButton extends StatelessWidget {
  final Function()? onFilterBackButtonTap;
  final EnhancedFilterController filterController = Get.find();

  ClearAllFilterButton({
    this.onFilterBackButtonTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => filterController.showSelectedFilterInBadges
          ? _clearAllFilterButton
          : const SizedBox.shrink(),
    );
  }

  Widget get _clearAllFilterButton => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ClickableText(
          onTap: () {
            if (kIsWeb && onFilterBackButtonTap != null) {
              onFilterBackButtonTap!();
            }
            filterController.onClearAllClick();
          },
          title: EnhancedFilterConstants.clearAll,
        ),
      );
}
