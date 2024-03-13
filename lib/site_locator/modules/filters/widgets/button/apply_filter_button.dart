part of filter_module;

class ApplyFilterButton extends StatelessWidget {
  final Function()? onFilterBackButtonTap;

  final EnhancedFilterController filterController = Get.find();

  ApplyFilterButton({
    this.onFilterBackButtonTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildApplyFilterButton();
  }

  Widget _buildApplyFilterButton() {
    return kIsWeb
        ? Container(
            width: 375,
            child: _buildButton,
          )
        : _buildButton;
  }

  Padding get _buildButton => Padding(
        padding: const EdgeInsets.all(16),
        child: _applyFilterButton,
      );

  Widget get _applyFilterButton => Obx(
        () => PrimaryButton(
          text: EnhancedFilterConstants.applyFilter,
          onPressed:
              filterController.isFilterStatusChange() ? _applyFilterTap : null,
        ),
      );

  Future<void> _applyFilterTap() async {
    if (kIsWeb) {
      if (onFilterBackButtonTap != null) {
        onFilterBackButtonTap!();
      }
    } else {
      trackAction(
        AnalyticsTrackActionName.enhancedFiltersApplyFiltersButtonClickEvent,
        // // adobeCustomTag: AdobeTagProperties.enhancedFilters,
      );
    }

    await filterController.onApplyFilterClick();
  }
}
