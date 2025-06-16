part of map_view_module;

class FloatingMapButtonsContainer extends StatelessWidget {
  FloatingMapButtonsContainer({Key? key}) : super(key: key);

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: siteLocatorController.canShowFloatingMapButtons(),
        child: Container(
          padding: EdgeInsets.zero,
          width: 100,
          child: Column(
            children: [
              Visibility(
                visible: !siteLocatorController.hasToSwitchMCSites(),
                child: _filterButtonContainer(),
              ),
              const SizedBox(height: 15),
              _listViewButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButtonContainer() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _filterButton(),
        _filterCountBadge,
      ],
    );
  }

  Widget _filterButton() => FloatingMapButton(
        key: const Key(SLSemanticStrings.filtersButton),
        icon: Icons.filter_alt_outlined,
        label: SLInternalText.filterButtonLabel,
        onPressed: siteLocatorController.filterButtonTap,
        semanticsLabel: SLSemanticStrings.filtersButton,
      );

  Widget get _filterCountBadge =>
      !siteLocatorController.hasToSwitchMCSites.value
          ? Positioned(
              right: -1,
              top: -1,
              child: SelectedFilterCountBadge(),
            )
          : const SizedBox();

  Widget _listViewButton() {
    return FloatingMapButton(
      key: const Key(SLSemanticStrings.listViewButton),
      icon: Icons.format_list_bulleted_outlined,
      label: SLInternalText.listViewButtonLabel,
      onPressed: siteLocatorController.onListViewButtonTap,
      semanticsLabel: SLSemanticStrings.listViewButton,
    );
  }
}
