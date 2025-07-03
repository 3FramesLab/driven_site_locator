part of map_view_module;

class SiteAddress extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final SiteLocation siteLocation;
  final siteAddressController = Get.find<SiteAddressController>();
  final _superTooltipController = DrivenSuperTooltipController();

  SiteAddress({
    required this.siteLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DrivenTooltip(
        controller: _superTooltipController,
        onShow: _onShowTooltip,
        tooltipContent: _tooltipContent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _icon,
            const SizedBox(width: 4),
            _addressText,
          ],
        ),
      ),
    );
  }

  void _onShowTooltip() {
    siteAddressController.cancelDelay();
    siteAddressController.resetTooltipText();
  }

  Widget get _tooltipContent => GestureDetector(
        onTap: _onTooltipTap,
        child: Obx(
          () => Text(
            siteAddressController.toolTipText(),
            style: f14RegularWhite,
          ),
        ),
      );

  void _onTooltipTap() {
    siteAddressController.onAddressToolTipClick(
      _superTooltipController,
      siteLocation,
    );
  }

  Widget get _icon => const Icon(
        Icons.pin_drop_outlined,
        color: DrivenColors.grey,
        size: 16,
      );

  Widget get _addressText => Expanded(
        child: Text(
          getFullAddress(),
          style: f14RegularGrey,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textScaler: const TextScaler.linear(1),
        ),
      );

  String getFullAddress() {
    return SiteInfoUtils.getFullAddress(siteLocation);
  }
}
