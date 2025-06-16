part of map_view_module;

class ShareMyLocationDialog extends StatelessWidget {
  final Future<void> Function()? onAllowShareMyLocation;

  const ShareMyLocationDialog({
    this.onAllowShareMyLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      titleWidget: _titleWidget,
      text: _text,
      primaryButton: _primaryButton,
      secondaryButton: _secondaryButton,
    );
  }

  Widget get _titleWidget => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fmd_good,
            color: DrivenColors.green,
            size: 40,
          ),
          Text(
            SLViewText.allowShareMyLocation,
            style: f16SemiBoldGreen,
          )
        ],
      );

  List<TextSpan> get _text => const [
        TextSpan(
          text: SLViewText.allowShareMyLocationDesc,
          style: f16RegularBlack,
        )
      ];

  Widget get _primaryButton => PrimaryButton(
        onPressed: () async {
          Get.back();
          if (onAllowShareMyLocation != null) {
            await onAllowShareMyLocation!();
          }
        },
        text: SLViewText.allowShareMyLocation,
      );

  Widget get _secondaryButton => ClickableText(
        onTap: Get.back,
        title: SLViewText.cancel,
      );
}
