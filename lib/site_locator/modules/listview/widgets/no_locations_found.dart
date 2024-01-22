part of list_view_module;

class NoLocationsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _noLocationsText(),
          _searchForNewLocationText(),
        ],
      ),
    );
  }

  EdgeInsets get _containerPadding => const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 48,
      );

  Widget _noLocationsText() => const Text(
        SiteLocatorConstants.noLocationText,
        style: f15RegularBlack,
      );

  Widget _searchForNewLocationText() => const Padding(
        padding: EdgeInsets.only(top: 14),
        child: Text(
          SiteLocatorConstants.searchForNewLocationText,
          style: f15RegularBlack,
        ),
      );
}
