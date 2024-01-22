part of filter_module;

class BadgeView extends StatelessWidget {
  final EnhancedFilterController filterController = Get.find();

  BadgeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => filterController.showSelectedFilterInBadges
          ? _content
          : const SizedBox.shrink(),
    );
  }

  Widget get _content => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterByText,
            const SizedBox(height: 8),
            _selectedBadges,
          ],
        ),
      );

  Widget get _filterByText => const Text(
        EnhancedFilterConstants.filterBy,
        style: f16SemiboldBlack,
      );

  Widget get _selectedBadges => Wrap(
        children: filterController.selectedFiltersIgnoreFavorites
            .map(_badge)
            .toList(),
      );

  Widget _badge(SiteFilter filter) {
    return DrivenBadge(
      label: filter.label,
      onTap: () => filterController.onFilterCheckChange(
        siteFilter: filter,
        isChecked: false,
      ),
    );
  }
}
