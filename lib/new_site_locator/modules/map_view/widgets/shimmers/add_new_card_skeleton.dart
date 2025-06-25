part of map_view_module;

class SLAddNewCardSkeleton extends StatelessWidget {
  const SLAddNewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: ShimmatorShape.roundedRectangular(
        height: 24,
      ),
    );
  }
}
