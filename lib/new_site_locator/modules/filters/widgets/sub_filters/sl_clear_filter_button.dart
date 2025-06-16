part of sl_filter_module;

class SLClearFilterButton extends StatelessWidget {
  final Filter filter;

  final _controller = Get.find<AuthSLTypeChoicesController>();

  SLClearFilterButton({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedPrimaryButton(
      onPressed: _onPressed,
      text: SLViewText.clearFilters,
    );
  }

  void _onPressed() {
    _controller.onClearFilterClick(filter);
  }
}
