part of filter_module;

class SelectedFilterCountBadge extends StatelessWidget {
  final EnhancedFilterController filterController = Get.find();

  SelectedFilterCountBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => filterController.showSelectedFilterInBadges
          ? CountBadge(count: filterController.selectedFilterCount)
          : const SizedBox.shrink(),
    );
  }
}
