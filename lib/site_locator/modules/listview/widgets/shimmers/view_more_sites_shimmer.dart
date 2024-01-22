part of list_view_module;

class ViewMoreSitesShimmer extends StatelessWidget {
  const ViewMoreSitesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticStrings.viewMoreSitesLoading,
      child: ShimmatorShape.roundedRectangular(
        isPurple: true,
        width: MediaQuery.of(context).size.width * 0.6,
        height: 30,
      ),
    );
  }
}
