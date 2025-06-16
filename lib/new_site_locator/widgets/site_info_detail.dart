part of sl_widget_module;

class SiteInfoDetail extends StatelessWidget {
  final IconData iconData;
  final String description;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? descriptionTextStyle;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final VoidCallback? onDescriptionTap;

  const SiteInfoDetail({
    required this.iconData,
    required this.description,
    super.key,
    this.iconSize = SLInternalText.siteInfoIconSize,
    this.iconColor = DrivenColors.textColor,
    this.descriptionTextStyle = f14RegularBlack,
    this.textOverflow,
    this.maxLines,
    this.onDescriptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDescriptionTap,
      child: _content,
    );
  }

  Widget get _content => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: iconSize, color: iconColor),
          const HorizontalSpacer(size: 7.5),
          _description(),
        ],
      );

  Widget _description() => Text(
        description,
        style: descriptionTextStyle,
        overflow: textOverflow,
        maxLines: maxLines,
      );
}
