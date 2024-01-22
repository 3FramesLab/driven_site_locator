part of filter_module;

class CountBadge extends StatelessWidget {
  final int count;

  const CountBadge({
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SiteLocatorDimensions.dp20,
      width: SiteLocatorDimensions.dp20,
      alignment: Alignment.center,
      decoration: boxDecoration,
      child: countText,
    );
  }

  Widget get countText => Text(
        count.toString(),
        style: f12BoldWhite,
      );

  Decoration get boxDecoration => const BoxDecoration(
        color: DrivenColors.brandPurple,
        shape: BoxShape.circle,
      );
}
