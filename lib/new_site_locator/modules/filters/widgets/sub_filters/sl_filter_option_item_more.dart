part of sl_filter_module;

class SLFilterOptionItemMore extends StatelessWidget {
  final NewSiteFilter siteFilter;
  final int index;
  final bool isRadioButton;

  final _controller = Get.find<AuthSLTypeChoicesController>();

  SLFilterOptionItemMore({
    required this.siteFilter,
    required this.index,
    required this.isRadioButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => _viewMoreContainer);
  }

  Widget get _viewMoreContainer => InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _labelText,
              const SizedBox(width: 8),
              _viewMoreOrLessIcon,
            ],
          ),
        ),
      );

  Widget get _labelText => DrivenText(
        text: isViewMoreClicked
            ? SLViewText.viewLess
            : SLViewText.viewMoreCamelCase,
        style: f16SemiBoldPrimary.copyWith(
          decoration: TextDecoration.underline,
        ),
      );

  Widget get _viewMoreOrLessIcon => Icon(
        isViewMoreClicked
            ? Icons.keyboard_double_arrow_up_outlined
            : Icons.keyboard_double_arrow_down_outlined,
        color: DrivenColors.primary,
      );

  void _onTap() {
    _controller.onFilterOptionSelected(
      isRadioButton: isRadioButton,
      siteFilter: siteFilter,
    );
  }

  bool get isViewMoreClicked => _controller.selectedFilterIsViewMoreClicked();
}
