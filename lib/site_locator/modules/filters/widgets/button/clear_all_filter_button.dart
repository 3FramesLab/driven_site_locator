part of filter_module;

class ClearAllFilterButton extends StatelessWidget {
  final EnhancedFilterController filterController = Get.find();

  ClearAllFilterButton({Key? key}) : super(key: key);

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
          onTap: filterController.onClearAllClick,
          title: EnhancedFilterConstants.clearAll,
        ),
      );
}
