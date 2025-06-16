part of sl_filter_module;

class BrandQuickFilterList extends StatelessWidget {
  BrandQuickFilterList({super.key});

  final AuthSLTypeChoicesController authSLTypeChoicesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Obx(() {
        final displayBrandsList = authSLTypeChoicesController.displayBrandsList;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: displayBrandsList.length,
          itemBuilder: (_, index) {
            final brandSiteFilter = displayBrandsList[index];
            return _itemBuilder(brandSiteFilter);
          },
        );
      }),
    ));
  }

  Widget _itemBuilder(SiteFilter brandSiteFilter) {
    return brandSiteFilter.isVisible
        ? BrandQuickFilterItem(
            siteFilter: brandSiteFilter,
            value: brandSiteFilter.isChecked,
            onChanged: () => authSLTypeChoicesController
                .onBrandSiteFilterSelect(brandSiteFilter),
          )
        : const SizedBox.shrink();
  }
}
