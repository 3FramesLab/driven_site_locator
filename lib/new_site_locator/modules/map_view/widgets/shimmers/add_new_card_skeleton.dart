part of map_view_module;

class AddNewCardSkeleton extends StatelessWidget {
  const AddNewCardSkeleton({super.key});

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
