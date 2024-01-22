part of filter_module;

class ShowMoreFuelBrands extends StatelessWidget {
  final EnhancedFilterController _filterController = Get.find();
  ShowMoreFuelBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _filterController.isFuelBrandSearchTextEmpty()
          ? _content
          : const SizedBox.shrink(),
    );
  }

  Widget get _content => ClickableText(
        title: _filterController.showOrHideFuelBrandLabel,
        onTap: _filterController.onShowHideFuelBrandClick,
        alignment: MainAxisAlignment.start,
      );
}
