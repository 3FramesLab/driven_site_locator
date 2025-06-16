part of sl_widget_module;

class SiteLocatorMapViewBackButton extends StatelessWidget {
  final void Function()? onBackButtonPressed;
  const SiteLocatorMapViewBackButton({
    this.onBackButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return backButtonWithoutDecoration;
  }

  Widget get backButtonWithoutDecoration => Container(
        margin: const EdgeInsets.only(left: 10, top: 10),
        padding: EdgeInsets.zero,
        width: 70,
        height: 32,
        child: _getDrivenBackButton(onPressed: onBackButtonPressed),
      );

  Widget _getDrivenBackButton({Function()? onPressed}) {
    const color = DrivenColors.primary;
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      onPressed: onPressed ?? Get.back,
      child: Row(
        children: [
          const Icon(
            Icons.chevron_left,
            color: color,
            size: 24,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 1.20),
            width: 42,
            child: FittedBox(
              child: Text(
                SLViewText.back,
                style: f16SemiBoldBlack.copyWith(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
