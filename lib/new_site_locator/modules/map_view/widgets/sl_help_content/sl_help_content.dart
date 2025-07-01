part of map_view_module;

class SLHelpContent extends StatelessWidget {
  final List<String> filterHeaders;

  const SLHelpContent({
    required this.filterHeaders,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PanelHandle(color: Color(0xFFdee3ea)),
          _titleText,
          _easierToFilterText,
          _listView,
          _divider,
          _lookingForLowestPriceText,
          _lowestPriceRow,
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Decoration get _boxDecoration => const BoxDecoration(
        color: DrivenColors.lightBlueBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      );

  Widget get _titleText => const Padding(
        padding: EdgeInsets.only(top: 12, left: 16, right: 16),
        child: Text(
          SLViewText.getReadyToStartSavingNow,
          style: f24ExtraboldPrimary,
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1),
        ),
      );

  Widget get _easierToFilterText => const Padding(
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Text(
          SLViewText.easierToFilterDesc,
          style: f16SemiBoldBlack,
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1),
        ),
      );

  Widget get _listView => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SLHelpFilterList(filterHeaders: filterHeaders),
      );

  Widget get _divider => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Divider(
          height: 1,
          thickness: 1,
          color: DrivenColors.grey500,
        ),
      );

  Widget get _lookingForLowestPriceText => const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Text(
          SLViewText.lookingForLowestPriceDesc,
          style: f16SemiBoldBlack,
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1),
        ),
      );

  Widget get _lowestPriceRow => const Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SLHelpLowestPriceImages(),
      );
}
