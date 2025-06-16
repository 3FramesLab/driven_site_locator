part of map_view_module;

class GallonPreferredDialog extends StatelessWidget {
  const GallonPreferredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      titleWidget: _titleWidget,
      text: _text,
      textAlignment: Alignment.centerLeft,
      textAlign: TextAlign.left,
      primaryButton: _primaryButton,
      isDynamicAlert: true,
    );
  }

  Widget get _titleWidget => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _titleText,
          _descriptionText,
          const SizedBox(height: 8),
          _divider,
          const SizedBox(height: 8),
        ],
      );

  Widget get _titleText =>
      const Text(SLViewText.gallonPreferredTitle, style: f24ExtraboldBlack);

  Widget get _descriptionText =>
      const Text(SLViewText.gallonPreferredDescription, style: f16RegularBlack);

  Widget get _divider => const Divider(
        color: DrivenColors.disabledButtonTextColor,
        height: 1,
        thickness: 1,
      );

  List<TextSpan> get _text => [
        const TextSpan(
          text: SLViewText.gallonPreferredNote,
          style: f14RegularBlack,
        )
      ];

  Widget get _primaryButton => PrimaryButton(
        onPressed: Get.back,
        text: SLViewText.ok,
      );
}
