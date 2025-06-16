part of sl_filter_module;

class DcNoLocationFoundDialog extends StatelessWidget {
  final double radius;

  const DcNoLocationFoundDialog({
    required this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      titleWidget: _titleWidget,
      text: _text,
      primaryButton: _primaryButton,
    );
  }

  Widget get _titleWidget => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: DrivenColors.orangeAccent,
            size: 40,
          ),
          Text(
            SLViewText.noLocationFound,
            style: f16SemiBoldBlack,
          )
        ],
      );

  List<TextSpan> get _text => [
        TextSpan(
          text: _desc,
          style: f16RegularBlack,
        )
      ];

  Widget get _primaryButton => PrimaryButton(
        onPressed: Get.back,
        text: SLViewText.ok,
      );

  String get _desc =>
      'Unfortunately, no locations within ${radius.round()} miles match your selected filters. Please adjust or remove some filters and try again.';
}
