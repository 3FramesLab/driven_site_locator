part of filter_module;

class DrivenBadge extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;
  final IconData? iconData;

  const DrivenBadge({
    required this.label,
    this.iconData = Icons.clear,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticStrings.badge,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: _margin,
          padding: _padding,
          decoration: _boxDecoration,
          child: _contentRow,
        ),
      ),
    );
  }

  Widget get _contentRow => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _labelText,
          const SizedBox(width: 4),
          _icon,
        ],
      );

  Widget get _labelText => Text(
        label,
        style: f12SemiboldWhite,
      );

  Widget get _icon => iconData == null
      ? const SizedBox.shrink()
      : Icon(
          iconData,
          color: SiteLocatorColors.white,
          size: 16,
        );

  EdgeInsetsGeometry get _margin => const EdgeInsets.only(
        right: 8,
        bottom: 8,
      );

  EdgeInsetsGeometry get _padding => const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      );

  BoxDecoration get _boxDecoration => const BoxDecoration(
        color: SiteLocatorColors.black,
        borderRadius: BorderRadius.all(Radius.circular(12.5)),
      );
}
