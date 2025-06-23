part of sl_list_module;

class ListViewCardShimmer extends StatelessWidget {
  const ListViewCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SLSemanticStrings.siteLocatorListViewLoading,
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: skeletonLayout,
        ),
      ),
    );
  }

  Widget skeletonLayout(BuildContext context, int index) {
    return Container(
      color: SiteInfoUtils.getCardBgColor(index),
      child: Padding(
        padding: SiteInfoUtils.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _layoutSkeletons(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _layoutSkeletons(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSkeleton(),
          _itemsSkeleton(),
          _itemsSkeleton(),
          const SizedBox(height: 5),
          SiteInfoUtils.divider(),
          _footerSkeleton(),
        ],
      ),
    );
  }

  Widget _itemsSkeleton() {
    const item = Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: SkeletonShape(height: 10, width: 120),
    );
    return const Row(children: [item, SizedBox(width: 20), item]);
  }

  Widget _headerSkeleton() {
    return Row(
      children: [
        const SkeletonShape(height: 48, width: 48),
        const SizedBox(width: 10),
        ShimmatorShape.roundedRectangular(width: 200, height: 20),
      ],
    );
  }

  Widget _footerSkeleton() {
    const item = Expanded(
      child: Center(child: SkeletonShape(height: 30, width: 80)),
    );
    return const Padding(
      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Row(children: [item, item]),
    );
  }
}
