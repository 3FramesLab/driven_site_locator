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
              _filterButtonContainer(),
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

  FloatingMapButton _filterButton() => FloatingMapButton(
        key: const Key('filter_button'),
        icon: Icons.filter_alt_outlined,
        label: SiteLocatorConstants.filterButtonLabel,
        onPressed: siteLocatorController.filterButtonTap,
      );

  Widget get _filterCountBadge => Positioned(
        right: -1,
        top: -1,
        child: SelectedFilterCountBadge(),
      );

  Widget _listViewButton() {
    return FloatingMapButton(
      key: const Key('list_view_button'),
      icon: Icons.format_list_bulleted_outlined,
      label: SiteLocatorConstants.listViewButtonLabel,
      onPressed: siteLocatorController.onListViewButtonTap,
    );
  }
}
