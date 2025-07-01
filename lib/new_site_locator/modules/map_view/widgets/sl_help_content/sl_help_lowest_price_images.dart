part of map_view_module;

class SLHelpLowestPriceImages extends StatelessWidget {
  const SLHelpLowestPriceImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              SLAssets.lowestPriceCluster,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              SLAssets.lowestPricePin,
            ),
          ),
        ),
      ],
    );
  }
}
