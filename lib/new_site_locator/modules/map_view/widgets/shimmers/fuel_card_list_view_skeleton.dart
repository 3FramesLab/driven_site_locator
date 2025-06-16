part of map_view_module;

class FuelCardListViewItemSkeleton extends StatelessWidget {
  const FuelCardListViewItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: cardListViewItemSkeleton,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget cardListViewItemSkeleton(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ShimmatorShape.roundedRectangular(height: 80),
    );
  }
}
