part of filter_module;

class EnhancedFilterListView extends StatelessWidget {
  final EnhancedFilterController filterController = Get.find();

  EnhancedFilterListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filterController.allEnhancedFilters.length,
        separatorBuilder: _separatorBuilder,
        itemBuilder: _menuListItem,
      ),
    );
  }

  Widget _separatorBuilder(_, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          height: 1,
          thickness: 0.2,
          color: SiteLocatorColors.grey400,
        ),
      );

  Widget _menuListItem(_, int index) => EnhancedFilterListItem(
        enhancedFilter: filterController.allEnhancedFilters[index],
      );
}
