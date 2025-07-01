part of map_view_module;

class SiteAddressController extends GetxController {
  final RxString toolTipText = SLViewText.copyAddress.obs;

  Future<void> onAddressToolTipClick(
    DrivenSuperTooltipController toolTipController,
    SiteLocation siteLocation,
  ) async {
    if (toolTipText() == SLViewText.copyAddress) {
      await Clipboard.setData(
        ClipboardData(
          text: SiteInfoUtils.getFullAddress(siteLocation),
        ),
      );
      toolTipText(SLViewText.copied);
      toolTipText.refresh();
      await Future.delayed(const Duration(milliseconds: 500), () async {
        await toolTipController.hideTooltip();
        toolTipText(SLViewText.copyAddress);
      });
    }
  }
}
