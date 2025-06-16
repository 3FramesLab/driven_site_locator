part of sl_filter_module;

class SLApplyFilterButton extends StatelessWidget {
  final Filter filter;

  final _controller = Get.find<AuthSLTypeChoicesController>();

  SLApplyFilterButton({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: _onPressed,
      text: SLViewText.applyFilters,
    );
  }

  void _onPressed() {
    _controller.onApplyFilterClick(filter);
  }
}
