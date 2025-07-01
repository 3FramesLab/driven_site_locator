part of map_view_module;

class SiteAddressController extends GetxController {
  final RxString toolTipText = SLViewText.copyAddress.obs;
  Timer? delayTimer;

  Future<void> onAddressToolTipClick(
    DrivenSuperTooltipController toolTipController,
    SiteLocation siteLocation,
  ) async {
    if (toolTipText() == SLViewText.copyAddress) {
      try {
        await Clipboard.setData(
          ClipboardData(
            text: SiteInfoUtils.getFullAddress(siteLocation),
          ),
        ).timeout(
          const Duration(seconds: 3),
          onTimeout: () async => resetTooltip(toolTipController),
        );
        toolTipText(SLViewText.copied);
        toolTipText.refresh();
        startDelay(toolTipController);
      } catch (_) {
        await resetTooltip(toolTipController);
      }
    }
  }

  void startDelay(
    DrivenSuperTooltipController toolTipController,
  ) {
    delayTimer = Timer(const Duration(milliseconds: 380), () async {
      await resetTooltip(toolTipController);
    });
  }

  void cancelDelay() {
    delayTimer?.cancel();
    delayTimer = null;
  }

  Future<void> resetTooltip(
    DrivenSuperTooltipController toolTipController,
  ) async {
    await toolTipController.hideTooltip();
    resetTooltipText();
  }

  void resetTooltipText() {
    toolTipText(SLViewText.copyAddress);
  }
}
