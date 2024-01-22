part of filter_module;

class SitesListFilterButton extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  SitesListFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _filterButtonContainer(),
        _filterCountBadge,
      ],
    );
  }

  Widget get _filterCountBadge => Positioned(
        right: -7,
        top: -3,
        child: SelectedFilterCountBadge(),
      );

  Widget _filterButtonContainer() => Container(
        height: SiteLocatorDimensions.dp40,
        width: SiteLocatorDimensions.dp40,
        decoration: _listFilterIconDecoration(),
        child: _listFilterIcon(),
      );

  BoxDecoration _listFilterIconDecoration() => BoxDecoration(
        border: Border.all(width: 2),
        shape: BoxShape.circle,
      );

  Widget _listFilterIcon() => Semantics(
        label: SemanticStrings.sitesListViewFilterButton,
        container: true,
        child: GestureDetector(
          onTap: _listFilterIconTap,
          child: const Icon(
            Icons.filter_alt_outlined,
            size: SiteLocatorDimensions.dp24,
            color: Colors.black,
          ),
        ),
      );

  void _listFilterIconTap() {
    siteLocatorController.getListViewFilterClickTrackAction();
    siteLocatorController.navigateToEnhancedFilter();
  }
}
