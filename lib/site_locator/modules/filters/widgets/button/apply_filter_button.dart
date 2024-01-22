part of filter_module;

class ApplyFilterButton extends StatelessWidget {
  final EnhancedFilterController filterController = Get.find();

  ApplyFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _applyFilterButton,
    );
  }

  Widget get _applyFilterButton => Obx(
        () => PrimaryButton(
          text: EnhancedFilterConstants.applyFilter,
          onPressed:
              filterController.isFilterStatusChange() ? _applyFilterTap : null,
        ),
      );

  Future<void> _applyFilterTap() async {
    trackAction(
      AnalyticsTrackActionName.enhancedFiltersApplyFiltersButtonClickEvent,
    );
    await filterController.onApplyFilterClick();
  }
}
